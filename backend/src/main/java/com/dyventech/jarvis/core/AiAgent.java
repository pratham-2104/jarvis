package com.dyventech.jarvis.core;

/**
 * Base generic interface for all AI Agents in the Jarvis system.
 * @param <T> The input context type
 * @param <R> The output response type
 */
public interface AiAgent<T, R> {
    R execute(T context);
}
