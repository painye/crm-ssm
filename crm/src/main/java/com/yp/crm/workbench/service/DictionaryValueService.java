package com.yp.crm.workbench.service;
/**
 * @author pan
 * @date 2022/3/6 11:03
 */

import com.yp.crm.workbench.domain.DictionaryValue;

import java.util.List;

/**
 * @ClassName : com.yp.crm.workbench.service.DictionaryValueService
 * @Description : 类描述
 * @author pan
 * @date 2022/3/6 11:03
 */
public interface DictionaryValueService {
    List<DictionaryValue> queryDictionaryValueList(String type);
}
