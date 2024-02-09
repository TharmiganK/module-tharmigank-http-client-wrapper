package io.tharmigank.http.client.wrapper;

public enum HttpErrorType {
    CLIENT_ERROR("ClientError");

    private final String errorName;

    HttpErrorType(String errorName) {
        this.errorName = errorName;
    }

    public String getErrorName() {
        return errorName;
    }
}
