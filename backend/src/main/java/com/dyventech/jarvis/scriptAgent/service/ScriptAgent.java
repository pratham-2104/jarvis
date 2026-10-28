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
            ### REFERENCE CONTEXT ###
            Application: {appName}

            BRAND GUIDELINES & VOICE:
            {workspaceContext}

            RESEARCH INSIGHTS:
            {researchData}

            ======================================================================
            ### YOUR ASSIGNMENT (CRITICAL DIRECTIVE) ###
            You are a multi-platform content strategist and viral scriptwriter.
            DO NOT greet the user. DO NOT act as a chatbot or support agent.
            DO NOT say "Hello! I'm {appName}".
            
            Transform the selected idea below into a COMPLETE 3-FORMAT REPURPOSED CONTENT BUNDLE:
            1. Short-Form Video Script (Reel/TikTok)
            2. 6-Slide Carousel Blueprint (Instagram/LinkedIn)
            3. Founder Thought-Leadership Post (LinkedIn/X)
            4. Instagram SEO Caption & Hashtags

            SELECTED IDEA TO REPURPOSE:
            - Platform: {platform}
            - Strategic Intent (COCA): {intent}
            - Hook Type: {hookType}
            - Title: {title}
            - Opening Hook: "{hook}"
            - Concept Arc: {description}
            - User Refinement/Feedback: {feedback}

            TASK:
            Generate the complete repurposed bundle following the REQUIRED MARKDOWN OUTPUT FORMAT from your system instructions. Start immediately with '# 📦 REPURPOSED CONTENT SUITE'.
            ======================================================================
            """)
    @Agent("Viral Scriptwriter")
    @ToolBox({ScriptTool.class})
    String generateScript(
            @V("appName") String appName,
            @V("workspaceContext") String workspaceContext,
            @V("title") String title,
            @V("description") String description,
            @V("hook") String hook,
            @V("platform") String platform,
            @V("intent") String intent,
            @V("hookType") String hookType,
            @V("researchData") String researchData,
            @V("feedback") String feedback
    );
}
