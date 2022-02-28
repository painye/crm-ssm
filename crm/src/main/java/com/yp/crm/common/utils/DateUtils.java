package com.yp.crm.common.utils;
/**
 * @author pan
 * @date 2022/2/28 17:57
 */

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @ClassName : com.yp.crm.common.utils.DateUtils
 * @Description : 类描述
 * @author pan
 * @date 2022/2/28 17:57
 */
public class DateUtils {

    public static String formateDateTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("YY-MM-DD HH:mm:ss");
        String dateStr=sdf.format(date);
        return  dateStr;
    }
}
