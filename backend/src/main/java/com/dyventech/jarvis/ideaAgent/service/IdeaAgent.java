package com.dyventech.jarvis.ideaAgent.service;

import com.dyventech.jarvis.orchestrator.dto.IdeaResponse;
import com.dyventech.jarvis.ideaAgent.tool.IdeaTool;
import dev.langchain4j.agentic.Agent;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import dev.langchain4j.service.V;
import io.quarkiverse.langchain4j.RegisterAiService;
import io.quarkiverse.langchain4j.ToolBox;

@RegisterAiService
public interface IdeaAgent {

    @SystemMessage(fromResource = "prompts/idea-agent.txt")
    @UserMessage("""
            Generate fresh, non-duplicate content ideas based on the following research:
            {researchOutput}

            PREVIOUSLY CREATED SCRIPTS (DO NOT REPEAT THESE TOPICS OR ANGLES):
            {contentHistory}

            Additional Feedback/Constraints:
            {feedback}
            """)
    @Agent("Creative Content Strategist")
    @ToolBox({ IdeaTool.class })
    IdeaResponse generate(
            @V("researchOutput") String researchOutput,
            @V("contentHistory") String contentHistory,
            @V("feedback") String feedback
    );
}
