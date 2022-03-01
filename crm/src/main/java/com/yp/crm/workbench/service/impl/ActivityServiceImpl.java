package com.yp.crm.workbench.service.impl;
/**
 * @author pan
 * @date 2022/3/1 11:31
 */

import com.yp.crm.workbench.domain.Activity;
import com.yp.crm.workbench.mapper.ActivityMapper;
import org.aspectj.apache.bcel.generic.RET;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @ClassName : com.yp.crm.workbench.service.impl.ActivityServiceImpl
 * @Description : 类描述
 * @author pan
 * @date 2022/3/1 11:31
 */

@Service("activityService")
public class ActivityServiceImpl {

    @Autowired
    private ActivityMapper activityMapper;

    public int addActivity(Activity activity){
        return activityMapper.insert(activity);
    }


}
