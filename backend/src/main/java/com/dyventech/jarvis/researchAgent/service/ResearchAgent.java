package com.dyventech.jarvis.researchAgent.service;

import com.dyventech.jarvis.researchAgent.tool.ResearchTool;
import dev.langchain4j.agentic.Agent;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import dev.langchain4j.service.V;
import io.quarkiverse.langchain4j.RegisterAiService;
import io.quarkiverse.langchain4j.ToolBox;

@RegisterAiService
public interface ResearchAgent {

    @SystemMessage(fromResource = "prompts/research-agent.txt")
    @UserMessage("""
            Perform comprehensive research for the application: {appName}.
            
            APPLICATION DOCUMENTATION & CONTEXT:
            {appKnowledge}

            User Instruction: {userPrompt}
            """)
    @Agent("App and Trend Research Specialist")
    @ToolBox({ResearchTool.class})
    String execute(
            @V("appName") String appName,
            @V("appKnowledge") String appKnowledge,
            @V("userPrompt") String userPrompt
    );
}

