package com.dyventech.jarvis.researchAgent.tool;

import com.dyventech.jarvis.core.BaseAgentActions;
import dev.langchain4j.agent.tool.Tool;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Collectors;

@ApplicationScoped
public class ResearchTool extends BaseAgentActions {

    @Inject
    dev.langchain4j.web.search.WebSearchEngine searchEngine;

    @Tool("Read application knowledge from the local workspace")
    public String readAppKnowledge(String appName) {
        logAction("readAppKnowledge", appName);
        Path path = Paths.get("workspaces", appName, "knowledge");
        if (!Files.exists(path)) return "No knowledge files found for " + appName;
        try (var stream = Files.walk(path)) {
            return stream.filter(Files::isRegularFile)
                    .filter(p -> !p.getFileName().toString().startsWith(".")) // Filter hidden files like .DS_Store
                    .map(this::readFileContent)
                    .collect(Collectors.joining("\n---\n"));
        } catch (Exception e) {
            return "Error reading knowledge: " + e.getMessage();
        }
    }

    @Tool("Read brand guidelines and positioning from the local workspace")
    public String readBrandGuidelines(String appName) {
        logAction("readBrandGuidelines", appName);
        Path path = Paths.get("workspaces", appName, "brand");
        if (!Files.exists(path)) return "No brand files found for " + appName;
        try (var stream = Files.walk(path)) {
            return stream.filter(Files::isRegularFile)
                    .filter(p -> !p.getFileName().toString().startsWith(".")) // Filter hidden files like .DS_Store
                    .map(this::readFileContent)
                    .collect(Collectors.joining("\n---\n"));
        } catch (Exception e) {
            return "Error reading brand guidelines: " + e.getMessage();
        }
    }

    @Tool("Search for trending content ideas related to the app niche on Tavily")
    public String searchTrendingIdeas(String niche) {
        logAction("searchTrendingIdeas", niche);
        try {
            return searchEngine.search(niche).toString();
        } catch (Exception e) {
            return "Error searching Tavily: " + e.getMessage();
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
