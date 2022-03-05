package com.yp.crm.workbench.service;

import com.yp.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * @author pan
 * @date 2022/3/4 22:00
 */
public interface ActivityRemarkService {
    List<ActivityRemark> queryActivityRemarkByActivityId(String id);

    int createActivityRemark(ActivityRemark activityRemark);

    int deleteActivityRemark(String id);

    int editActivityRemark(ActivityRemark activityRemark);

}
