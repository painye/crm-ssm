package com.yp.crm.workbench.service.impl;
/**
 * @author pan
 * @date 2022/3/4 22:01
 */

import com.yp.crm.workbench.domain.ActivityRemark;
import com.yp.crm.workbench.mapper.ActivityRemarkMapper;
import com.yp.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName : com.yp.crm.workbench.service.impl.ActivityRemarkServiceImpl
 * @Description : 类描述
 * @author pan
 * @date 2022/3/4 22:01
 */

@Service("activityRemarkService")
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    @Override
    public List<ActivityRemark> queryActivityRemarkByActivityId(String id) {
        return activityRemarkMapper.selectActivityRemarkByActivityId(id);
    }

    @Override
    public int createActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insertActivityRemark(activityRemark);
    }
}
