import ballerina/http;
import ballerina/jballerina.java;

public type ModifiedRequest record {|
    http:RequestMessage message;
    map<string|string[]>? headers;
    string? mediaType;
|};

public type InterceptFunction isolated function (string path, string method, http:RequestMessage message,
        string? mediaType, map<string|string[]>? headers, WrapperCtxMap ctxMap) returns ModifiedRequest;

isolated function defaultIntercept(string path, string method, http:RequestMessage message, string? mediaType,
        map<string|string[]>? headers, WrapperCtxMap ctxMap) returns ModifiedRequest {
    return {message: message, headers: headers, mediaType: mediaType};
}

public isolated class WrapperCtxMap {
    private final map<anydata> ctxMap;

    public isolated function init(map<anydata> ctxMap) {
        self.ctxMap = ctxMap.clone();
    }

    public isolated function keys() returns string[] {
        lock {
            return self.ctxMap.keys().clone();
        }
    }

    public isolated function hasKey(string key) returns boolean {
        lock {
            return self.ctxMap.hasKey(key);
        }
    }

    public isolated function get(string key) returns anydata {
        lock {
            return self.ctxMap[key].clone();
        }
    }

    public function getWithType(string key, typedesc<anydata> targetType = <>) returns targetType = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.ExternWrapperCtxMap"
    } external;
}

public client isolated class Client {
    *http:ClientObject;

    final http:Client httpClient;
    final InterceptFunction interceptFunc;
    final WrapperCtxMap ctxMap;

    public isolated function init(string url, InterceptFunction? interceptFunc = (), map<anydata> ctxMap = {}, *http:ClientConfiguration config) returns ClientError? {
        self.httpClient = check new (url, config);
        self.interceptFunc = interceptFunc ?: defaultIntercept;
        self.ctxMap = new (ctxMap);
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
        ModifiedRequest interceptResult = self.interceptFunc(path, "POST", message, mediaType, headers, self.ctxMap);
        return self.httpClient->post(path, interceptResult.message, interceptResult.headers, interceptResult.mediaType, targetType);
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
        ModifiedRequest interceptResult = self.interceptFunc(path, "PUT", message, mediaType, headers, self.ctxMap);
        return self.httpClient->put(path, interceptResult.message, interceptResult.headers, interceptResult.mediaType, targetType);
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
        ModifiedRequest interceptResult = self.interceptFunc(path, "PATCH", message, mediaType, headers, self.ctxMap);
        return self.httpClient->patch(path, interceptResult.message, interceptResult.headers, interceptResult.mediaType, targetType);
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
        ModifiedRequest interceptResult = self.interceptFunc(path, "DELETE", message, mediaType, headers, self.ctxMap);
        return self.httpClient->delete(path, interceptResult.message, interceptResult.headers, interceptResult.mediaType, targetType);
    }

    isolated resource function head [http:PathParamType... path](map<string|string[]>? headers = (), *http:QueryParams params)
            returns http:Response|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction",
        name: "headResource"
    } external;

    remote isolated function head(string path, map<string|string[]>? headers = ()) returns http:Response|ClientError {
        ModifiedRequest interceptResult = self.interceptFunc(path, "HEAD", (), (), headers, self.ctxMap);
        return self.httpClient->head(path, interceptResult.headers);
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
            returns http:Response|anydata|ClientError {
        ModifiedRequest interceptResult = self.interceptFunc(path, "GET", (), (), headers, self.ctxMap);
        return self.httpClient->get(path, interceptResult.headers, targetType);
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
        ModifiedRequest interceptResult = self.interceptFunc(path, "OPTIONS", (), (), headers, self.ctxMap);
        return self.httpClient->options(path, interceptResult.headers, targetType);
    }

    remote isolated function execute(string httpVerb, string path, http:RequestMessage message,
            map<string|string[]>? headers = (), string? mediaType = (), http:TargetType targetType = <>)
            returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction"
    } external;

    private isolated function processExecute(string httpVerb, string path, http:RequestMessage message,
            http:TargetType targetType, string? mediaType, map<string|string[]>? headers)
            returns http:Response|anydata|ClientError {
        ModifiedRequest interceptResult = self.interceptFunc(path, httpVerb, message, mediaType, headers, self.ctxMap);
        return self.httpClient->execute(httpVerb, path, interceptResult.message, interceptResult.headers, interceptResult.mediaType, targetType);
    }

    remote isolated function forward(string path, http:Request request, http:TargetType targetType = <>)
            returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction"
    } external;

    private isolated function processForward(string path, http:Request request, http:TargetType targetType)
            returns http:Response|anydata|ClientError {
        http:RequestMessage interceptResult = self.interceptFunc(path, request.method, request, (), (), self.ctxMap).message;
        if interceptResult is http:Request {
            return self.httpClient->forward(path, interceptResult, targetType);
        }
        return self.httpClient->forward(path, request, targetType);
    }

    remote isolated function submit(string httpVerb, string path, http:RequestMessage message) returns http:HttpFuture|ClientError {
        ModifiedRequest interceptResult = self.interceptFunc(path, httpVerb, message, (), (), self.ctxMap);
        return self.httpClient->submit(httpVerb, path, interceptResult.message);
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
