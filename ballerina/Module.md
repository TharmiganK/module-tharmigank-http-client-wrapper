## Overview

This module provides a wrapper client to execute a common function before sending a request to the HTTP endpoint.

## The intercept function

The common function should match the following signature:

```ballerina
public type InterceptFunction isolated function (string path, string method, http:RequestMessage message,
        string? mediaType, map<string|string[]>? headers, WrapperContext ctx) returns ModifiedRequest;
```

Example:
```ballerina
wrapper:InterceptFunction interceptFunc = isolated function(string path, string method, http:RequestMessage message,
        string? mediaType, map<string|string[]>? headers, wrapper:WrapperContext ctx) returns wrapper:ModifiedRequest {
        
    return {
        message,
        headers,
        mediaType
    };
};
    
wrapper:Client clientEp = check new ("http://localhost:9090", interceptFunc = interceptFunc);
```

## The wrapper context map

Additionally, a context map can be passed to the wrapper client to store some data that can be accessed from the intercept function. The context map should be a map of `anydata` values.

Example:
```ballerina
map<anydata> initCtxMap = {
    "key1": 3,
    "key2": "value2"
};

wrapper:Client clientEp = check new ("http://localhost:9090", interceptFunc = interceptFunc, ctxMap = initCtxMap);
```

The context map can be accessed from the intercept function as `WrapperCtxMap` object. The `WrapperCtxMap` object provides the following functions to access and modify the context map:

| Function                                                           | Description                                                  |
|--------------------------------------------------------------------|--------------------------------------------------------------|
| `function keys() returns string[]`                                 | Get the keys of the context map                              |
| `function hasKey(string key) returns boolean`                      | Check if the context map has the given key                   |
| `function get(string key) returns anydata`                         | Get the value of the given key                               |
| `function getWithType(string key, typedesc target) returns target` | Get the value of the given key and cast it to the given type |
| `function set(string key, anydata value)`                          | Set the value of the given key                               |

## Usage

The following example demonstrates how to use the wrapper client to add a common function to add some custom header.

```ballerina
wrapper:InterceptFunction interceptFunc = isolated function(string path, string method, http:RequestMessage message,
        string? mediaType, map<string|string[]>? headers, wrapper:WrapperContext ctx) returns wrapper:ModifiedRequest {
    
    // Print the content of the ctxMap
    foreach string key in ctx.keys() {
        // getWithType is also available on ctxMap: 
        // string _ = check ctx.getWithType("key2");
        io:println("Key: " + key + ", Value: " + ctx.get(key).toString());
    }
    
    // Add a custom header
    map<string|string[]> modifiedHeaders = {"X-Test": "test"};
    if headers is map<string|string[]> {
        foreach [string, string|string[]] entry in headers.entries() {
            modifiedHeaders[entry[0]] = entry[1];
        }
    }
    
    // Return the modified request
    return {
        message,
        headers: modifiedHeaders,
        mediaType
    };
};

map<anydata> initCtxMap = {
    "key1": 3,
    "key2": "value2"
};

wrapper:Client clientEp = check new ("http://localhost:9090", interceptFunc = interceptFunc, ctxMap = initCtxMap);
```
