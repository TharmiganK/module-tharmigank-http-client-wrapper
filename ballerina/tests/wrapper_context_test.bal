import ballerina/http;
import ballerina/io;
import ballerina/test;

isolated function interceptFuncWithCtx(string path, string method, http:RequestMessage message,
        string? mediaType, map<string|string[]>? headers, WrapperContext ctx) returns ModifiedRequest|error {
    if headers !is () {
        if !headers.hasKey("X-Test") {
            if ctx.hasKey("X-Test") {
                string headerFromCtx = check ctx.getWithType("X-Test");
                headers["X-Test"] = headerFromCtx + " from ctx";
            } else {
                headers["X-Test"] = "System";
                ctx.set("X-Test", "System");
            }
        }
        return {
            message,
            headers,
            mediaType
        };
    }

    map<string|string[]> newHeaders = {};
    if ctx.hasKey("X-Test") {
        io:println("Header found in the ctx");
        string headerFromCtx = check ctx.getWithType("X-Test");
        newHeaders["X-Test"] = headerFromCtx + " from ctx";
    } else {
        io:println("Header not found in the ctx and setting the header from the system");
        newHeaders["X-Test"] = "System";
        ctx.set("X-Test", "System");
    }
    return {
        message,
        headers: newHeaders,
        mediaType
    };
}

@test:Config {}
function testCtxMapWithEmptyMap() returns error? {
    Client clientEp = check new ("http://localhost:9090", interceptFunc = interceptFuncWithCtx);
    Message msg = check clientEp->/get;
    test:assertEquals(msg.code, 200, "Status code should be 200");
    test:assertEquals(msg.message, "System", "Response message should be 'System'");

    msg = check clientEp->/get;
    test:assertEquals(msg.code, 200, "Status code should be 200");
    test:assertEquals(msg.message, "System from ctx", "Response message should be 'System from ctx'");

    msg = check clientEp->/get(headers = {"X-Test-123": "Custom"});
    test:assertEquals(msg.code, 200, "Status code should be 200");
    test:assertEquals(msg.message, "System from ctx", "Response message should be 'System from ctx'");

    msg = check clientEp->/get(headers = {"X-Test": "Custom"});
    test:assertEquals(msg.code, 200, "Status code should be 200");
    test:assertEquals(msg.message, "Custom", "Response message should be 'Custom'");
}

@test:Config {}
function testCtxMapWithNonEmptyMap() returns error? {
    Client clientEp = check new ("http://localhost:9090", interceptFunc = interceptFuncWithCtx, ctxMap = {"X-Test": "Custom"});
    Message msg = check clientEp->/get;
    test:assertEquals(msg.code, 200, "Status code should be 200");
    test:assertEquals(msg.message, "Custom from ctx", "Response message should be 'Custom from ctx'");

    msg = check clientEp->/get(headers = {"X-Test-123": "Custom"});
    test:assertEquals(msg.code, 200, "Status code should be 200");
    test:assertEquals(msg.message, "Custom from ctx", "Response message should be 'Custom from ctx'");

    msg = check clientEp->/get(headers = {"X-Test": "Custom"});
    test:assertEquals(msg.code, 200, "Status code should be 200");
    test:assertEquals(msg.message, "Custom", "Response message should be 'Custom'");
}
