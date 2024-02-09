import ballerina/jballerina.java;
import ballerina/http;

type ClientError http:ClientError;

function init() {
    setModule();
}

function setModule() = @java:Method {
    'class: "io.tharmigank.http.client.wrapper.ModuleUtils"
} external;
