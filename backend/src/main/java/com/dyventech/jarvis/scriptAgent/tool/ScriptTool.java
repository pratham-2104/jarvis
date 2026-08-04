package com.dyventech.jarvis.scriptAgent.tool;

import com.dyventech.jarvis.core.BaseAgentActions;
import dev.langchain4j.agent.tool.Tool;
import jakarta.enterprise.context.ApplicationScoped;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Collectors;

@ApplicationScoped
public class ScriptTool extends BaseAgentActions {

    private static final Path ROOT_PATH = Paths.get("workspaces");

    @Tool("Read brand guidelines and application knowledge from the workspace")
    public String readWorkspaceKnowledge(String appName) {
        logAction("readWorkspaceKnowledge", appName);
        StringBuilder content = new StringBuilder();
        
        // Read Brand data first (Priority)
        content.append("### BRAND GUIDELINES ###\n");
        content.append(readFromSubdir(appName, "brand"));
        
        // Read Knowledge data
        content.append("\n### APPLICATION FEATURES & KNOWLEDGE ###\n");
        content.append(readFromSubdir(appName, "knowledge"));
        
        return content.toString();
    }

    private String readFromSubdir(String appName, String subdir) {
        Path path = ROOT_PATH.resolve(appName).resolve(subdir);
        if (!Files.exists(path)) return "No files found in " + subdir;
        try (var stream = Files.walk(path)) {
            return stream.filter(Files::isRegularFile)
                    .filter(p -> !p.getFileName().toString().startsWith(".")) // Filter hidden files like .DS_Store
                    .map(this::readFileContent)
                    .collect(Collectors.joining("\n---\n"));
        } catch (Exception e) {
            return "Error reading " + subdir + ": " + e.getMessage();
        }
    }

    @Tool("Save the final generated script to the workspace")
    public String saveScript(String appName, String scriptTitle, String content) {
        logAction("saveScript", appName + " - " + scriptTitle);
        Path scriptDir = ROOT_PATH.resolve(appName).resolve("scripts");
        try {
            Files.createDirectories(scriptDir);
            String fileName = scriptTitle.replaceAll("[^a-zA-Z0-9]", "_") + ".md";
            Path filePath = scriptDir.resolve(fileName);
            Files.writeString(filePath, content);
            return "Script saved successfully to: " + filePath.toString();
        } catch (IOException e) {
            return "Error saving script: " + e.getMessage();
        }
    }

    private String readFileContent(Path path) {
        try {
            return "File: " + path.getFileName() + "\nContent:\n" + Files.readString(path);
        } catch (Exception e) {
            return "Error reading " + path + ": " + e.getMessage();
        }
    }
}
