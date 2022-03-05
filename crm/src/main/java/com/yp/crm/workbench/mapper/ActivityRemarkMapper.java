package com.yp.crm.workbench.mapper;

import com.yp.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Fri Mar 04 21:38:44 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Fri Mar 04 21:38:44 CST 2022
     */
    int insert(ActivityRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Fri Mar 04 21:38:44 CST 2022
     */
    int insertSelective(ActivityRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Fri Mar 04 21:38:44 CST 2022
     */
    ActivityRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Fri Mar 04 21:38:44 CST 2022
     */
    int updateByPrimaryKeySelective(ActivityRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Fri Mar 04 21:38:44 CST 2022
     */
    int updateByPrimaryKey(ActivityRemark record);

    /**
     * 根据activityID 来查找符合条件的remark
     * @param id
     * @return
     */
    List<ActivityRemark> selectActivityRemarkByActivityId(String id);

    /**
     * 创建一个市场活动记录
     * @param activityRemark
     * @return
     */
    int insertActivityRemark(ActivityRemark activityRemark);

    /**
     * 删除市场活动的记录
     * @param id
     * @return
     */
    int deleteActivityRemark(String id);

    /**
     * 修改备注的内容
     * @param activityRemark
     * @return
     */
    int updateActivityRemark(ActivityRemark activityRemark);
}