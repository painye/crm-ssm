package com.yp.crm.common.utils;
/**
 * @author pan
 * @date 2022/3/1 15:05
 */

import java.util.UUID;

/**
 * @ClassName : com.yp.crm.common.utils.UUIDUtils
 * @Description : 类描述
 * @author pan
 * @date 2022/3/1 15:05
 */
public class UUIDUtils {
    public static String getUUid(){
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
}
