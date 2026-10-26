package com.dyventech.jarvis.workspace.service;

import com.dyventech.jarvis.workspace.dto.WorkspaceDTO;
import jakarta.enterprise.context.ApplicationScoped;
import java.io.IOException;
import java.nio.file.*;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@ApplicationScoped
public class WorkspaceService {

    private static final Path ROOT_PATH = Paths.get("workspaces");

    public WorkspaceService() {
        try {
            if (!Files.exists(ROOT_PATH)) {
                Files.createDirectories(ROOT_PATH);
            }
        } catch (IOException e) {
            throw new RuntimeException("Could not initialize workspace root directory", e);
        }
    }

    public List<WorkspaceDTO> listWorkspaces() {
        try (Stream<Path> stream = Files.list(ROOT_PATH)) {
            return stream.filter(Files::isDirectory)
                    .map(path -> WorkspaceDTO.builder()
                            .name(path.getFileName().toString())
                            .knowledgeFiles(getFilesFromSubdir(path.getFileName().toString(), "knowledge"))
                            .brandFiles(getFilesFromSubdir(path.getFileName().toString(), "brand"))
                            .scriptFiles(getFilesFromSubdir(path.getFileName().toString(), "scripts"))
                            .build())
                    .collect(Collectors.toList());
        } catch (IOException e) {
            return Collections.emptyList();
        }
    }

    public WorkspaceDTO createWorkspace(String name) {
        Path workspacePath = ROOT_PATH.resolve(name);
        try {
            Files.createDirectories(workspacePath.resolve("knowledge"));
            Files.createDirectories(workspacePath.resolve("brand"));
            Files.createDirectories(workspacePath.resolve("scripts"));
            return WorkspaceDTO.builder()
                    .name(name)
                    .knowledgeFiles(Collections.emptyList())
                    .brandFiles(Collections.emptyList())
                    .scriptFiles(Collections.emptyList())
                    .build();
        } catch (IOException e) {
            throw new RuntimeException("Failed to create workspace: " + name, e);
        }
    }

    public WorkspaceDTO getWorkspace(String name) {
        Path workspacePath = ROOT_PATH.resolve(name);
        if (!Files.exists(workspacePath)) {
            throw new RuntimeException("Workspace not found: " + name);
        }
        return WorkspaceDTO.builder()
                .name(name)
                .knowledgeFiles(getFilesFromSubdir(name, "knowledge"))
                .brandFiles(getFilesFromSubdir(name, "brand"))
                .scriptFiles(getFilesFromSubdir(name, "scripts"))
                .build();
    }

    public String getFileContent(String workspaceName, String subdir, String fileName) {
        Path filePath = ROOT_PATH.resolve(workspaceName).resolve(subdir).resolve(fileName);
        try {
            if (!Files.exists(filePath)) return "File not found";
            return Files.readString(filePath);
        } catch (IOException e) {
            throw new RuntimeException("Error reading file: " + fileName, e);
        }
    }

    public void deleteWorkspace(String name) {
        Path workspacePath = ROOT_PATH.resolve(name);
        try (Stream<Path> walk = Files.walk(workspacePath)) {
            walk.sorted((p1, p2) -> p2.compareTo(p1)) // Delete files before directories
                .forEach(path -> {
                    try {
                        Files.delete(path);
                    } catch (IOException e) {
                        throw new RuntimeException("Failed to delete: " + path, e);
                    }
                });
        } catch (IOException e) {
            throw new RuntimeException("Failed to delete workspace: " + name, e);
        }
    }

    public void saveKnowledgeFile(String workspaceName, String subdir, String fileName, String content) {
        Path filePath = ROOT_PATH.resolve(workspaceName).resolve(subdir).resolve(fileName);
        try {
            Files.createDirectories(filePath.getParent());
            Files.writeString(filePath, content);
        } catch (IOException e) {
            throw new RuntimeException("Failed to save file: " + fileName, e);
        }
    }

    public String getAggregatedWorkspaceContext(String workspaceName) {
        StringBuilder sb = new StringBuilder();
        
        // Brand data
        sb.append("### BRAND GUIDELINES & DESIGN SYSTEM ###\n");
        sb.append(readSubdirContent(workspaceName, "brand"));
        
        // Knowledge data
        sb.append("\n\n### APPLICATION DOCUMENTATION & FEATURES ###\n");
        sb.append(readSubdirContent(workspaceName, "knowledge"));
        
        return sb.toString();
    }

    private String readSubdirContent(String workspaceName, String subdir) {
        Path path = ROOT_PATH.resolve(workspaceName).resolve(subdir);
        if (!Files.exists(path)) return "(No files found in " + subdir + ")";
        try (Stream<Path> stream = Files.walk(path)) {
            return stream.filter(Files::isRegularFile)
                    .filter(p -> !p.getFileName().toString().startsWith("."))
                    .map(p -> "=== FILE: " + p.getFileName() + " ===\n" + readFileQuietly(p))
                    .collect(Collectors.joining("\n\n"));
        } catch (Exception e) {
            return "Error reading " + subdir + ": " + e.getMessage();
        }
    }

    private String readFileQuietly(Path path) {
        try {
            return Files.readString(path);
        } catch (Exception e) {
            return "Error reading file " + path.getFileName() + ": " + e.getMessage();
        }
    }

    private List<String> getFilesFromSubdir(String workspaceName, String subdir) {
        Path path = ROOT_PATH.resolve(workspaceName).resolve(subdir);
        if (!Files.exists(path)) return Collections.emptyList();
        try (Stream<Path> stream = Files.walk(path)) {
            return stream.filter(Files::isRegularFile)
                    .filter(p -> !p.getFileName().toString().startsWith(".")) // Filter hidden files like .DS_Store
                    .map(p -> path.relativize(p).toString())
                    .collect(Collectors.toList());
        } catch (IOException e) {
            return Collections.emptyList();
        }
    }
}
