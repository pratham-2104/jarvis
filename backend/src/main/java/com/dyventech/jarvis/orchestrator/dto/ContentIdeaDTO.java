package com.dyventech.jarvis.orchestrator.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@lombok.extern.jackson.Jacksonized
public class ContentIdeaDTO {
    private int id;
    private String title;
    private String description;
    private String platform;
    private String hook;
    private String intent;    // COCA: Growth, Objection, Connection, Authority
    private String hookType;  // Visual, Contrarian, Curiosity Gap, Question, Teaser
}
