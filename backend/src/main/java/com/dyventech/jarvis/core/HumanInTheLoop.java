package com.dyventech.jarvis.core;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Marker annotation to identify "Human-in-the-loop" gates where the pipeline 
 * pauses and waits for user interaction before proceeding to the next agent.
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface HumanInTheLoop {
    String value() default "Awaiting user approval";
}
