package com.dyventech.jarvis.researchAgent.service;

import com.dyventech.jarvis.researchAgent.tool.ResearchTool;
import dev.langchain4j.agentic.Agent;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import io.quarkiverse.langchain4j.RegisterAiService;
import io.quarkiverse.langchain4j.ToolBox;

@RegisterAiService
public interface ResearchAgent {

    @SystemMessage(fromResource = "prompts/research-agent.txt")
    @UserMessage("Perform comprehensive research for the application: {appName}. User Instruction: {userPrompt}")
    @Agent("App and Trend Research Specialist")
    @ToolBox({ResearchTool.class})
    String execute(@dev.langchain4j.service.V("appName") String appName, @dev.langchain4j.service.V("userPrompt") String userPrompt);
    }

