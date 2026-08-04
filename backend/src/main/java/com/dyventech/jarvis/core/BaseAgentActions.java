package com.dyventech.jarvis.core;

import jakarta.inject.Inject;
import org.jboss.logging.Logger;

/**
 * Abstract class for all agent actions and tools.
 */
public abstract class BaseAgentActions {

    @Inject
    protected Logger log;

    protected void logAction(String action, String details) {
        log.infof("Agent Action: %s | Details: %s", action, details);
    }
}
