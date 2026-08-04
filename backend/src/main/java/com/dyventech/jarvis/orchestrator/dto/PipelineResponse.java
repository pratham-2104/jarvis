package com.dyventech.jarvis.orchestrator.dto;

import com.dyventech.jarvis.orchestrator.model.PipelineStatus;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class PipelineResponse {
    private String sessionId;
    private PipelineStatus status;
    private String researchData;
    private List<ContentIdeaDTO> suggestedIdeas;
    private String content; // Final selected idea or script
    private String message;
}
