package com.dyventech.jarvis.orchestrator.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.jackson.Jacksonized;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Jacksonized
public class IdeaResponse {
    private List<ContentIdeaDTO> ideas;
}
