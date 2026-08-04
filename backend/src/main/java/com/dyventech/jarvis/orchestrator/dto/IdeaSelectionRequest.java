package com.dyventech.jarvis.orchestrator.dto;

import lombok.Data;

@Data
public class IdeaSelectionRequest {
    private int selectedId; // 0 means reject all and redo research
    private String feedback;
}
