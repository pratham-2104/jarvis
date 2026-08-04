package com.dyventech.jarvis.orchestrator.dto;

import com.dyventech.jarvis.orchestrator.model.PipelineStatus;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class PipelineContext {
    private String sessionId;
    private String appName;
    private String initialUserPrompt; // The optional brief from the start
    private PipelineStatus status;

    // Research data
    private String researchOutput;
    private String researchFeedback;

    // Idea data
    private List<ContentIdeaDTO> suggestedIdeas;
    private ContentIdeaDTO selectedIdea;
    private String ideaFeedback;

    // Script data
    private String finalScript;
    private String scriptFeedback;
}
