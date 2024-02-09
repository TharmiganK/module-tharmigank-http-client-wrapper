import ballerina/http;
import ballerina/test;

type Message record {|
    string message;
    int code;
|};

service on new http:Listener(9090) {

    resource function 'default [string... path](@http:Header string? X\-Test = ()) returns Message {
        return {
            message: X\-Test ?: "Hello, World!",
            code: 200
        };
    }
}

isolated function interceptFunc(string path, string method, http:RequestMessage message,
        string? mediaType, map<string|string[]>? headers, WrapperCtxMap ctxMap) returns ModifiedRequest {
    map<string|string[]> modifiedHeaders = {"X-Test": "test"};
    if headers is map<string|string[]> {
        foreach [string, string|string[]] entry in headers.entries() {
            modifiedHeaders[entry[0]] = entry[1];
        }
    }
    return {
        message,
        headers: modifiedHeaders,
        mediaType
    };
}

@test:Config {}
function testGet() {
    do {
        Client clientEp = check new ("http://localhost:9090");
        Message msg = check clientEp->get("/get");
        test:assertEquals(msg.code, 200, "Status code should be 200");
        test:assertEquals(msg.message, "Hello, World!", "Response message should be 'Hello, World!'");
    } on fail error e {
        test:assertFail("Error occurred: " + e.message());
    }
}

@test:Config {}
function testGetWithInterceptor() {
    do {
        Client clientEp = check new ("http://localhost:9090", interceptFunc = interceptFunc);
        Message msg = check clientEp->get("/get", headers = {"Sample-Header": "Sample-Value"});
        test:assertEquals(msg.code, 200, "Status code should be 200");
        test:assertEquals(msg.message, "test", "Response message should be 'test'");
    } on fail error e {
        test:assertFail("Error occurred: " + e.message());
    }
}

@test:Config {}
function testGetWithInterceptorWithoutHeaders() {
    do {
        Client clientEp = check new ("http://localhost:9090", interceptFunc = interceptFunc);
        Message msg = check clientEp->get("/get");
        test:assertEquals(msg.code, 200, "Status code should be 200");
        test:assertEquals(msg.message, "test", "Response message should be 'test'");
    } on fail error e {
        test:assertFail("Error occurred: " + e.message());
    }
}
