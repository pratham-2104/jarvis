package com.dyventech.jarvis.workspace.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WorkspaceDTO {
    private String name;
    private List<String> knowledgeFiles;
    private List<String> brandFiles;
    private List<String> scriptFiles;
}
