package com.dyventech.jarvis.scriptAgent.service;

import com.dyventech.jarvis.scriptAgent.tool.ScriptTool;
import dev.langchain4j.agentic.Agent;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;
import dev.langchain4j.service.V;
import io.quarkiverse.langchain4j.RegisterAiService;
import io.quarkiverse.langchain4j.ToolBox;

@RegisterAiService
public interface ScriptAgent {

    @SystemMessage(fromResource = "prompts/script-agent.txt")
    @UserMessage("""
            Write a detailed text script for the following idea:
            Title: {title}
            Description: {description}
            Hook: {hook}
            Platform: {platform}

            Context from Research:
            {researchData}

            User Refinement/Feedback:
            {feedback}

            Application Name: {appName}
            """)
    @Agent("Viral Scriptwriter")
    @ToolBox({ScriptTool.class})
    String generateScript(
            @V("appName") String appName,
            @V("title") String title,
            @V("description") String description,
            @V("hook") String hook,
            @V("platform") String platform,
            @V("researchData") String researchData,
            @V("feedback") String feedback
    );
}
