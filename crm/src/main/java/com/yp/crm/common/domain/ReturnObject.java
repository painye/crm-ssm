package com.yp.crm.common.domain;
/**
 * @author pan
 * @date 2022/2/28 16:11
 */

/**
 * @ClassName : com.yp.crm.common.domain.RetuenObject
 * @Description : 类描述
 * @author pan
 * @date 2022/2/28 16:11
 */
public class ReturnObject {

    private String code;
    private String message;
    private Object retObject;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getRetObject() {
        return retObject;
    }

    public void setRetObject(Object retObject) {
        this.retObject = retObject;
    }

    @Override
    public String toString() {
        return "ReturnObject{" +
                "code='" + code + '\'' +
                ", message='" + message + '\'' +
                ", retObject=" + retObject +
                '}';
    }
}
