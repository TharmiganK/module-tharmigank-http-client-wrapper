import ballerina/http;
import ballerina/jballerina.java;

public type ModifiedRequest record {|
    http:RequestMessage message;
    map<string|string[]>? headers;
    string? mediaType;
|};

public type InterceptFunction isolated function (string path, string method, http:RequestMessage message,
        string? mediaType, map<string|string[]>? headers, WrapperContext ctx) returns ModifiedRequest|error;

isolated function defaultIntercept(string path, string method, http:RequestMessage message, string? mediaType,
        map<string|string[]>? headers, WrapperContext ctx) returns ModifiedRequest|error {
    return {message: message, headers: headers, mediaType: mediaType};
}

public client isolated class Client {
    *http:ClientObject;

    final http:Client httpClient;
    final InterceptFunction interceptFunc;
    final WrapperContext ctx;

    public isolated function init(string url, InterceptFunction? interceptFunc = (), map<anydata> ctxMap = {}, *http:ClientConfiguration config) returns ClientError? {
        self.httpClient = check new (url, config);
        self.interceptFunc = interceptFunc ?: defaultIntercept;
        self.ctx = new (ctxMap);
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
        do {
            ModifiedRequest interceptResult = check self.interceptFunc(path, "POST", message, mediaType, headers, self.ctx);
            return self.httpClient->post(path, interceptResult.message, interceptResult.headers, interceptResult.mediaType, targetType);
        } on fail error err {
            if err is ClientError {
                return err;
            }
            return error ClientError("Error occurred while intercepting the request", err);
        }
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
        do {
            ModifiedRequest interceptResult = check self.interceptFunc(path, "PUT", message, mediaType, headers, self.ctx);
            return self.httpClient->put(path, interceptResult.message, interceptResult.headers, interceptResult.mediaType, targetType);
        } on fail error err {
            if err is ClientError {
                return err;
            }
            return error ClientError("Error occurred while intercepting the request", err);
        }
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
        do {
            ModifiedRequest interceptResult = check self.interceptFunc(path, "PATCH", message, mediaType, headers, self.ctx);
            return self.httpClient->patch(path, interceptResult.message, interceptResult.headers, interceptResult.mediaType, targetType);
        } on fail error err {
            if err is ClientError {
                return err;
            }
            return error ClientError("Error occurred while intercepting the request", err);
        }
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
        do {
            ModifiedRequest interceptResult = check self.interceptFunc(path, "DELETE", message, mediaType, headers, self.ctx);
            return self.httpClient->delete(path, interceptResult.message, interceptResult.headers, interceptResult.mediaType, targetType);
        } on fail error err {
            if err is ClientError {
                return err;
            }
            return error ClientError("Error occurred while intercepting the request", err);

        }
    }

    isolated resource function head [http:PathParamType... path](map<string|string[]>? headers = (), *http:QueryParams params)
            returns http:Response|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction",
        name: "headResource"
    } external;

    remote isolated function head(string path, map<string|string[]>? headers = ()) returns http:Response|ClientError {
        do {
            ModifiedRequest interceptResult = check self.interceptFunc(path, "HEAD", (), (), headers, self.ctx);
            return self.httpClient->head(path, interceptResult.headers);
        } on fail error err {
            if err is ClientError {
                return err;
            }
            return error ClientError("Error occurred while intercepting the request", err);
        }
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
        do {
            ModifiedRequest interceptResult = check self.interceptFunc(path, "GET", (), (), headers, self.ctx);
            return self.httpClient->get(path, interceptResult.headers, targetType);
        } on fail error err {
            if err is ClientError {
                return err;
            }
            return error ClientError("Error occurred while intercepting the request", err);
        }
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
        do {
            ModifiedRequest interceptResult = check self.interceptFunc(path, "OPTIONS", (), (), headers, self.ctx);
            return self.httpClient->options(path, interceptResult.headers, targetType);
        } on fail error err {
            if err is ClientError {
                return err;
            }
            return error ClientError("Error occurred while intercepting the request", err);
        }
    }

    remote isolated function execute(string httpVerb, string path, http:RequestMessage message,
            map<string|string[]>? headers = (), string? mediaType = (), http:TargetType targetType = <>)
            returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction"
    } external;

    private isolated function processExecute(string httpVerb, string path, http:RequestMessage message,
            http:TargetType targetType, string? mediaType, map<string|string[]>? headers)
            returns http:Response|anydata|ClientError {
        do {
            ModifiedRequest interceptResult = check self.interceptFunc(path, httpVerb, message, mediaType, headers, self.ctx);
            return self.httpClient->execute(httpVerb, path, interceptResult.message, interceptResult.headers, interceptResult.mediaType, targetType);
        } on fail error err {
            if err is ClientError {
                return err;
            }
            return error ClientError("Error occurred while intercepting the request", err);
        }
    }

    remote isolated function forward(string path, http:Request request, http:TargetType targetType = <>)
            returns targetType|ClientError = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.HttpClientAction"
    } external;

    private isolated function processForward(string path, http:Request request, http:TargetType targetType)
            returns http:Response|anydata|ClientError {
        do {
            ModifiedRequest interceptResult = check self.interceptFunc(path, request.method, request, (), (), self.ctx);
            http:RequestMessage interceptMsg =  interceptResult.message;
            if interceptMsg is http:Request {
                return self.httpClient->forward(path, interceptMsg, targetType);
            }
            return self.httpClient->forward(path, request, targetType);
        } on fail error err {
            if err is ClientError {
                return err;
            }
            return error ClientError("Error occurred while intercepting the request", err);
        }
    }

    remote isolated function submit(string httpVerb, string path, http:RequestMessage message) returns http:HttpFuture|ClientError {
        do {
            ModifiedRequest interceptResult = check self.interceptFunc(path, httpVerb, message, (), (), self.ctx);
            return self.httpClient->submit(httpVerb, path, interceptResult.message);
        } on fail error err {
            if err is ClientError {
                return err;
            }
            return error ClientError("Error occurred while intercepting the request", err);
        }
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
