package com.yp.crm.workbench.service;

import com.yp.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * @author pan
 * @date 2022/3/1 11:30
 */
public interface ActivityService {
    public int addActivity(Activity activity);

    List<Activity> queryActivityByConditionForPage(Map<String, Object> map);

    int queryActivityByConditionCounts(Map<String, Object> map);

    int deleteCheckedActivity(String[] ids);

    Activity queryActivityById(String id);

    int editActivityByCondition(Activity activity);

    List<Activity> queryAllActivity();

    List<Activity> queryCheckedActivityById(String[] ids);

    int addActivityByList(List<Activity> activityList);

    Activity queryActivityForDetailById(String id);
}
