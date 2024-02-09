package io.tharmigank.http.client.wrapper;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.Module;

public class ModuleUtils {

    private static Module module;

    private ModuleUtils() {}

    public static void setModule(Environment env) {
        module = env.getCurrentModule();
    }
    
    public static Module getPackage() {
        return module;
    }
}
