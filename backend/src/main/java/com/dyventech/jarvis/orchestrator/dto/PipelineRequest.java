package com.dyventech.jarvis.orchestrator.dto;

import lombok.Data;

@Data
public class PipelineRequest {
    private String appName;
    private String userPrompt; // Optional initial direction
}
