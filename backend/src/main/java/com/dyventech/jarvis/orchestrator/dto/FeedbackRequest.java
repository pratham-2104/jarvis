package com.dyventech.jarvis.orchestrator.dto;

import lombok.Data;

@Data
public class FeedbackRequest {
    private boolean approved;
    private String feedback;
}
