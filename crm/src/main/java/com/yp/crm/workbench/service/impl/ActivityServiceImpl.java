package com.yp.crm.workbench.service.impl;
/**
 * @author pan
 * @date 2022/3/1 11:31
 */

import com.yp.crm.workbench.domain.Activity;
import com.yp.crm.workbench.mapper.ActivityMapper;
import com.yp.crm.workbench.service.ActivityService;
import org.aspectj.apache.bcel.generic.RET;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @ClassName : com.yp.crm.workbench.service.impl.ActivityServiceImpl
 * @Description : 类描述
 * @author pan
 * @date 2022/3/1 11:31
 */

@Service("activityService")
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public int addActivity(Activity activity){
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityByConditionForPage(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int queryActivityByConditionCounts(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionCounts(map);
    }

    @Override
    public int deleteCheckedActivity(String[] ids) {
        return activityMapper.deleteCheckedActivity(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int editActivityByCondition(Activity activity) {
        return activityMapper.updateActivityByCondition(activity);
    }

    @Override
    public List<Activity> queryAllActivity() {
        return activityMapper.selectAllActivity();
    }
}
