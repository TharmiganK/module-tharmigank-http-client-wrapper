package io.tharmigank.http.client.wrapper;

import io.ballerina.runtime.api.creators.ErrorCreator;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;

import static io.ballerina.runtime.api.utils.StringUtils.fromString;

public class HttpUtil {

    public static BError createHttpError(String message, HttpErrorType errorType, BError cause) {
        return createHttpError(errorType, message, cause, null);
    }

    public static BError createHttpError(HttpErrorType errorType, String message, BError cause,
                                         BMap<BString, Object> detail) {
        return ErrorCreator.createError(ModuleUtils.getPackage(), errorType.getErrorName(), fromString(message),
                                        cause, detail);
    }

    private HttpUtil() {
    }
}
