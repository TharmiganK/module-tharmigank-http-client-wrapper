import ballerina/jballerina.java;

public isolated class WrapperContext {
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

    public isolated function set(string key, anydata value) {
        lock {
            self.ctxMap[key] = value.clone();
        }
    }

    public isolated function getWithType(string key, typedesc<anydata> targetType = <>) returns targetType|error = @java:Method {
        'class: "io.tharmigank.http.client.wrapper.ExternWrapperCtxMap"
    } external;
}
