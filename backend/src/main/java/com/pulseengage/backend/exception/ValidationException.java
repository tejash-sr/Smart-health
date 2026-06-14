package com.pulseengage.backend.exception;

/** Thrown when a business-rule validation fails. Mapped to HTTP 400. */
public class ValidationException extends RuntimeException {
    public ValidationException(String message) {
        super(message);
    }
}
