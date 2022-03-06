package com.yp.crm.workbench.service.impl;
/**
 * @author pan
 * @date 2022/3/6 11:04
 */

import com.yp.crm.workbench.domain.DictionaryValue;
import com.yp.crm.workbench.mapper.DictionaryValueMapper;
import com.yp.crm.workbench.service.DictionaryValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName : com.yp.crm.workbench.service.impl.DictionaryValueServiceImpl
 * @Description : 类描述
 * @author pan
 * @date 2022/3/6 11:04
 */

@Service("dictionaryServiceImpl")
public class DictionaryValueServiceImpl implements DictionaryValueService {
    @Autowired
    private DictionaryValueMapper dictionaryValueMapper;

    @Override
    public List<DictionaryValue> queryDictionaryValueList(String type) {
        return dictionaryValueMapper.selectDictionValueListByType(type);
    }
}
