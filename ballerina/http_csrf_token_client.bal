import ballerina/constraint;
import ballerina/http;
import ballerina/jballerina.java;
import ballerina/mime;

type PayloadBindingClientError http:ClientError & http:PayloadBindingError;

type PayloadValidationClientError http:ClientError & http:PayloadValidationError;

public client isolated class CSRFTokenClient {
    *http:ClientObject;

    final http:Client httpClient;
    private string? csrfToken = ();
    private final boolean requireValidation;

    public isolated function init(string url, *http:ClientConfiguration config) returns ClientError? {
        self.httpClient = check new (url, config);
        self.requireValidation = config.validation;
        return;
    }

    isolated resource function post [http:PathParamType... path](http:RequestMessage message, map<string|string[]>? headers = (), string?
            mediaType = (), http:TargetType targetType = <>, *http:QueryParams params) returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction",
        name: "postResource"
    } external;

    remote isolated function post(string path, http:RequestMessage message, map<string|string[]>? headers = (),
            string? mediaType = (), http:TargetType targetType = <>)
            returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction"
    } external;

    private isolated function processPost(string path, http:RequestMessage message, http:TargetType targetType,
            string? mediaType, map<string|string[]>? headers) returns http:Response|anydata|ClientError {
        map<string|string[]> headersModified = headers ?: {};
        string? csrfToken = ();
        lock {
            csrfToken = self.csrfToken;
        }
        if csrfToken is string {
            headersModified["X-CSRF-TOKEN"] = csrfToken;
            return self.httpClient->post(path, message, headers, mediaType, targetType);
        }
        return error http:ClientError("CSRF token not found");
    }

    isolated resource function put [http:PathParamType... path](http:RequestMessage message, map<string|string[]>? headers = (), string?
            mediaType = (), http:TargetType targetType = <>, *http:QueryParams params) returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction",
        name: "putResource"
    } external;

    remote isolated function put(string path, http:RequestMessage message, map<string|string[]>? headers = (),
            string? mediaType = (), http:TargetType targetType = <>)
            returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction"
    } external;

    private isolated function processPut(string path, http:RequestMessage message, http:TargetType targetType,
            string? mediaType, map<string|string[]>? headers) returns http:Response|anydata|ClientError {
        return self.httpClient->put(path, message, headers, mediaType, targetType);
    }

    isolated resource function patch [http:PathParamType... path](http:RequestMessage message, map<string|string[]>? headers = (),
            string? mediaType = (), http:TargetType targetType = <>, *http:QueryParams params) returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction",
        name: "patchResource"
    } external;

    remote isolated function patch(string path, http:RequestMessage message, map<string|string[]>? headers = (),
            string? mediaType = (), http:TargetType targetType = <>)
            returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction"
    } external;

    private isolated function processPatch(string path, http:RequestMessage message, http:TargetType targetType,
            string? mediaType, map<string|string[]>? headers) returns http:Response|anydata|ClientError {
        return self.httpClient->patch(path, message, headers, mediaType, targetType);
    }

    isolated resource function delete [http:PathParamType... path](http:RequestMessage message = (), map<string|string[]>? headers = (),
            string? mediaType = (), http:TargetType targetType = <>, *http:QueryParams params) returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction",
        name: "deleteResource"
    } external;

    remote isolated function delete(string path, http:RequestMessage message = (),
            map<string|string[]>? headers = (), string? mediaType = (), http:TargetType targetType = <>)
            returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction"
    } external;

    private isolated function processDelete(string path, http:RequestMessage message, http:TargetType targetType,
            string? mediaType, map<string|string[]>? headers) returns http:Response|anydata|ClientError {
        return self.httpClient->delete(path, message, headers, mediaType, targetType);
    }

    isolated resource function head [http:PathParamType... path](map<string|string[]>? headers = (), *http:QueryParams params)
            returns http:Response|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction",
        name: "headResource"
    } external;

    remote isolated function head(string path, map<string|string[]>? headers = ()) returns http:Response|ClientError {
        return self.httpClient->head(path, headers);
    }

    isolated resource function get [http:PathParamType... path](map<string|string[]>? headers = (), http:TargetType targetType = <>,
            *http:QueryParams params) returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction",
        name: "getResource"
    } external;

    remote isolated function get(string path, map<string|string[]>? headers = (), http:TargetType targetType = <>)
            returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction"
    } external;

    private isolated function processGet(string path, map<string|string[]>? headers, http:TargetType targetType)
            returns http:Response|anydata|error {
        map<string|string[]> headersModified = headers ?: {};
        headersModified["X-CSRF-TOKEN"] = "fetch";
        http:Response response = check self.httpClient->get(path, headersModified);
        string|http:HeaderNotFoundError header = response.getHeader("X-CSRF-TOKEN");
        if header is string {
            lock {
                self.csrfToken = header;
            }
        }
        return processResponse(response, targetType, self.requireValidation);
    }

    isolated resource function options [http:PathParamType... path](map<string|string[]>? headers = (), http:TargetType targetType = <>,
            *http:QueryParams params) returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction",
        name: "optionsResource"
    } external;

    remote isolated function options(string path, map<string|string[]>? headers = (), http:TargetType targetType = <>)
            returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction"
    } external;

    private isolated function processOptions(string path, map<string|string[]>? headers, http:TargetType targetType)
            returns http:Response|anydata|ClientError {
        return self.httpClient->options(path, headers, targetType);
    }

    remote isolated function execute(string httpVerb, string path, http:RequestMessage message,
            map<string|string[]>? headers = (), string? mediaType = (), http:TargetType targetType = <>)
            returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction"
    } external;

    private isolated function processExecute(string httpVerb, string path, http:RequestMessage message,
            http:TargetType targetType, string? mediaType, map<string|string[]>? headers)
            returns http:Response|anydata|ClientError {
        return self.httpClient->execute(httpVerb, path, message, headers, mediaType, targetType);
    }

    remote isolated function forward(string path, http:Request request, http:TargetType targetType = <>)
            returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction"
    } external;

    private isolated function processForward(string path, http:Request request, http:TargetType targetType)
            returns http:Response|anydata|ClientError {
        return self.httpClient->forward(path, request, targetType);
    }

    remote isolated function submit(string httpVerb, string path, http:RequestMessage message) returns http:HttpFuture|ClientError {
        return self.httpClient->submit(httpVerb, path, message);
    }

    remote isolated function getResponse(http:HttpFuture httpFuture) returns http:Response|ClientError {
        return self.httpClient->getResponse(httpFuture);
    }

    remote isolated function hasPromise(http:HttpFuture httpFuture) returns boolean {
        return self.httpClient->hasPromise(httpFuture);
    }

    remote isolated function getNextPromise(http:HttpFuture httpFuture) returns http:PushPromise|ClientError {
        return self.httpClient->getNextPromise(httpFuture);
    }

    remote isolated function getPromisedResponse(http:PushPromise promise) returns http:Response|ClientError {
        return self.httpClient->getPromisedResponse(promise);
    }

    remote isolated function rejectPromise(http:PushPromise promise) {
        return self.httpClient->rejectPromise(promise);
    }

    public isolated function getCookieStore() returns http:CookieStore? {
        lock {
            return self.httpClient.getCookieStore();
        }
    }

    public isolated function circuitBreakerForceClose() {
        lock {
            self.httpClient.circuitBreakerForceClose();
        }
    }

    public isolated function circuitBreakerForceOpen() {
        lock {
            self.httpClient.circuitBreakerForceOpen();
        }
    }

    public isolated function getCircuitBreakerCurrentState() returns http:CircuitState {
        lock {
            return self.httpClient.getCircuitBreakerCurrentState();
        }
    }
}

isolated function processResponse(http:Response response, http:TargetType targetType, boolean requireValidation)
        returns http:Response|anydata|ClientError {
    if targetType is typedesc<http:Response> {
        return response;
    }
    int statusCode = response.statusCode;
    map<string[]> headers = getHeaders(response);
    anydata|error payload = getPayload(response);
    if 400 <= statusCode && statusCode <= 599 {
        string reasonPhrase = response.reasonPhrase;
        if payload is error {
            if payload is http:NoContentError {
                return createResponseError(statusCode, reasonPhrase, headers);
            }
            return error PayloadBindingClientError("http:ApplicationResponseError creation failed: " + statusCode.toString() +
                " response payload extraction failed", payload);
        } else {
            return createResponseError(statusCode, reasonPhrase, headers, payload);
        }
    }
    if payload is error {
        return error PayloadBindingClientError("payload binding failed", payload);
    }
    if targetType is typedesc<anydata> {
        do {
            if requireValidation {
                return check constraint:validate(payload, targetType);
            }
            return check payload.cloneWithType(targetType);
        } on fail error e {
            if e is constraint:ValidationError {
                return error PayloadValidationClientError("payload validation failed", e);
            }
            return error PayloadBindingClientError("payload binding failed", e);
        }
    } else {
        panic error http:GenericClientError("invalid payload target type");
    }
}

isolated function getHeaders(http:Response response) returns map<string[]> {
    map<string[]> headers = {};
    string[] headerKeys = response.getHeaderNames();
    foreach string key in headerKeys {
        string[]|http:HeaderNotFoundError values = response.getHeaders(key);
        if values is string[] {
            headers[key] = values;
        }
    }
    return headers;
}

isolated function getPayload(http:Response response) returns anydata|error {
    string|error contentTypeValue = response.getHeader(http:CONTENT_TYPE);
    if contentTypeValue is error {
        return response.getTextPayload();
    }
    var mediaType = mime:getMediaType(contentTypeValue.toLowerAscii());
    if mediaType is mime:InvalidContentTypeError {
        return response.getTextPayload();
    } else {
        match mediaType.primaryType {
            "application" => {
                match mediaType.subType {
                    "json" => {
                        return response.getJsonPayload();
                    }
                    "xml" => {
                        return response.getXmlPayload();
                    }
                    "octet-stream" => {
                        return response.getBinaryPayload();
                    }
                    _ => {
                        return response.getTextPayload();
                    }
                }
            }
            _ => {
                return response.getTextPayload();
            }
        }
    }
}

isolated function createResponseError(int statusCode, string reasonPhrase, map<string[]> headers, anydata body = ())
        returns http:ClientRequestError|http:RemoteServerError {
    if 400 <= statusCode && statusCode <= 499 {
        return error http:ClientRequestError(reasonPhrase, statusCode = statusCode, headers = headers, body = body);
    } else {
        return error http:RemoteServerError(reasonPhrase, statusCode = statusCode, headers = headers, body = body);
    }
}
