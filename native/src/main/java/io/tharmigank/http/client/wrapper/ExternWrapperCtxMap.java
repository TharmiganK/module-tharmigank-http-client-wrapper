package io.tharmigank.http.client.wrapper;

import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import org.ballerinalang.langlib.value.EnsureType;

/**
 * Utilities related to HTTP request context.
 */
public final class ExternWrapperCtxMap {

    private ExternWrapperCtxMap() {}

    public static Object getWithType(BObject wrapperCtx, BString key, BTypedesc targetType) {
        BMap members = wrapperCtx.getMapValue(StringUtils.fromString("ctxMap"));
        try {
            Object value = members.getOrThrow(key);
            Object convertedType = EnsureType.ensureType(value, targetType);
            if (convertedType instanceof BError) {
                return HttpUtil.createHttpError("type conversion failed for value of key: " + key.getValue(),
                                                HttpErrorType.CLIENT_ERROR,
                                                (BError) convertedType);
            }
            return convertedType;
        } catch (Exception exp) {
            return HttpUtil.createHttpError("no member found for key: " + key.getValue(),
                                            HttpErrorType.CLIENT_ERROR,
                                            exp instanceof BError ? (BError) exp : null);
        }
    }
}
