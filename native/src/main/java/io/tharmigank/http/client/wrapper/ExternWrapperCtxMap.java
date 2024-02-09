/*
 *  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
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
