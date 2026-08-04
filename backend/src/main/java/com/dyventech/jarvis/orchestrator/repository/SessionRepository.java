package com.dyventech.jarvis.orchestrator.repository;

import com.dyventech.jarvis.orchestrator.dto.PipelineContext;
import jakarta.enterprise.context.ApplicationScoped;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

@ApplicationScoped
public class SessionRepository {
    private final Map<String, PipelineContext> sessions = new ConcurrentHashMap<>();

    public void save(PipelineContext context) {
        sessions.put(context.getSessionId(), context);
    }

    public Optional<PipelineContext> findById(String sessionId) {
        return Optional.ofNullable(sessions.get(sessionId));
    }
}
