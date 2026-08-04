package com.dyventech.jarvis.orchestrator.service;

import com.dyventech.jarvis.orchestrator.dto.PipelineContext;
import com.dyventech.jarvis.orchestrator.dto.PipelineResponse;
import com.dyventech.jarvis.orchestrator.model.PipelineStatus;
import com.dyventech.jarvis.orchestrator.repository.SessionRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import com.dyventech.jarvis.orchestrator.dto.ContentIdeaDTO;
import java.util.List;
import java.util.UUID;

@ApplicationScoped
public class OrchestratorService {

    @Inject
    SessionRepository repository;

    @Inject
    com.dyventech.jarvis.researchAgent.service.ResearchAgent researchAgent;

    @Inject
    com.dyventech.jarvis.ideaAgent.service.IdeaAgent ideaAgent;

    @Inject
    com.dyventech.jarvis.scriptAgent.service.ScriptAgent scriptAgent;

    public PipelineResponse startPipeline(String appName, String userPrompt) {
        String sessionId = UUID.randomUUID().toString();
        PipelineContext context = PipelineContext.builder()
                .sessionId(sessionId)
                .appName(appName)
                .initialUserPrompt(userPrompt)
                .status(PipelineStatus.STARTED)
                .build();
        
        repository.save(context);
        
        // Step 1: Research
        return runResearch(context);
    }

    private PipelineResponse runResearch(PipelineContext context) {
        context.setStatus(PipelineStatus.RESEARCHING);
        repository.save(context);

        String initialPrompt = context.getInitialUserPrompt() != null ? context.getInitialUserPrompt() : "None";
        String feedback = context.getResearchFeedback() != null ? context.getResearchFeedback() : "None";
        
        String combinedPrompt = "Initial User Vision: " + initialPrompt + " | Feedback for Re-Research: " + feedback;
        
        String result = researchAgent.execute(context.getAppName(), combinedPrompt);
        context.setResearchOutput(result);
        repository.save(context);
        
        return runIdeation(context);
    }

    private PipelineResponse runIdeation(PipelineContext context) {
        context.setStatus(PipelineStatus.IDEATING);
        repository.save(context);

        String feedback = context.getIdeaFeedback() != null ? context.getIdeaFeedback() : "None";
        String initialPrompt = context.getInitialUserPrompt() != null ? context.getInitialUserPrompt() : "None";
        
        String combinedFeedback = "Initial Vision: " + initialPrompt + " | Recent Feedback: " + feedback;
        
        com.dyventech.jarvis.orchestrator.dto.IdeaResponse response = ideaAgent.generate(context.getResearchOutput(), combinedFeedback);
        List<ContentIdeaDTO> ideas = response.getIdeas();
        
        context.setSuggestedIdeas(ideas);
        context.setStatus(PipelineStatus.AWAITING_IDEA_APPROVAL);
        repository.save(context);

        return PipelineResponse.builder()
                .sessionId(context.getSessionId())
                .status(context.getStatus())
                .researchData(context.getResearchOutput())
                .suggestedIdeas(context.getSuggestedIdeas())
                .message("Research and Ideation complete. Please select an idea (ID 1-3) or provide feedback to redo research (ID 0).")
                .build();
    }

    @com.dyventech.jarvis.core.HumanInTheLoop("User selects, refines, or rejects content ideas")
    public PipelineResponse handleIdeaSelection(String sessionId, int selectedId, String feedback) {
        PipelineContext context = repository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found: " + sessionId));

        // Scenario 3: Redo Everything (Redo Research)
        // MANDATORY: Feedback must be provided to redo research
        if (selectedId == 0) {
            if (feedback == null || feedback.trim().isEmpty()) {
                return buildResponse(context, "Feedback is required to perform new research. Please tell us what to change.", null);
            }
            context.setResearchFeedback(feedback);
            return runResearch(context);
        }

        // Find the selected idea from the list
        ContentIdeaDTO selectedIdea = context.getSuggestedIdeas().stream()
                .filter(i -> i.getId() == selectedId)
                .findFirst()
                .orElse(null);

        if (selectedIdea == null) {
            return buildResponse(context, "Invalid Idea selected. Please select a valid idea or provide feedback for new research.", null);
        }

        // Scenario 2: Modify/Refine the selected Idea (OPTIONAL Feedback)
        // If an idea is picked AND there is feedback, we redo ideation with that context
        if (feedback != null && !feedback.trim().isEmpty()) {
            String refinementPrompt = "Focus on this idea: [" + selectedIdea.getTitle() + "]. " +
                                     "Changes requested: " + feedback;
            context.setIdeaFeedback(refinementPrompt);
            return runIdeation(context);
        }

        // Scenario 1: Direct Selection (Approval) - No feedback provided
        context.setSelectedIdea(selectedIdea);
        context.setIdeaFeedback(null); // Clear any old feedback
        return runScripting(context);
    }

    private PipelineResponse runScripting(PipelineContext context) {
        context.setStatus(PipelineStatus.SCRIPTING);
        repository.save(context);

        ContentIdeaDTO idea = context.getSelectedIdea();
        
        String result = scriptAgent.generateScript(
                context.getAppName(),
                idea.getTitle(),
                idea.getDescription(),
                idea.getHook(),
                idea.getPlatform(),
                context.getResearchOutput(),
                context.getIdeaFeedback() != null ? context.getIdeaFeedback() : "None"
        );

        context.setFinalScript(result);
        context.setStatus(PipelineStatus.AWAITING_SCRIPT_APPROVAL);
        repository.save(context);

        return buildResponse(context, "Script generated for selected idea. Please approve or provide feedback.", context.getFinalScript());
    }

    @Inject
    com.dyventech.jarvis.scriptAgent.tool.ScriptTool scriptTool;

    public PipelineResponse handleScriptFeedback(String sessionId, boolean approved, String feedback) {
        PipelineContext context = repository.findById(sessionId)
                .orElseThrow(() -> new RuntimeException("Session not found: " + sessionId));

        if (approved) {
            context.setStatus(PipelineStatus.COMPLETED);
            
            // Save the final approved script to the workspace
            scriptTool.saveScript(
                context.getAppName(), 
                context.getSelectedIdea().getTitle(), 
                context.getFinalScript()
            );
            
            repository.save(context);
            return buildResponse(context, "Pipeline completed and script saved successfully!", context.getFinalScript());
        } else {
            context.setScriptFeedback(feedback);
            return runScripting(context); // Loop back to scripting
        }
    }

    private PipelineResponse buildResponse(PipelineContext context, String message, String content) {
        return PipelineResponse.builder()
                .sessionId(context.getSessionId())
                .status(context.getStatus())
                .researchData(context.getResearchOutput())
                .suggestedIdeas(context.getSuggestedIdeas())
                .content(content)
                .message(message)
                .build();
    }
}
