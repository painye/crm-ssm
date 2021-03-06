package com.yp.crm.workbench.mapper;

import com.yp.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Tue Mar 01 11:27:39 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Tue Mar 01 11:27:39 CST 2022
     */
    int insertActivity(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Tue Mar 01 11:27:39 CST 2022
     */
    int insertSelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Tue Mar 01 11:27:39 CST 2022
     */
    Activity selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Tue Mar 01 11:27:39 CST 2022
     */
    int updateActivityByCondition(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Tue Mar 01 11:27:39 CST 2022
     */
    int updateActivity(Activity record);

    List<Activity> selectActivityByConditionForPage(Map<String, Object> map);

    int selectActivityByConditionCounts(Map<String, Object> map);

    int deleteCheckedActivity(String[] ids);

    Activity selectActivityById(String id);

    List<Activity> selectAllActivity();

    List<Activity> selectCheckedActivityById(String[] ids);

    /**
     * 将活动实体的集合全部插入到数据库中
     * @param activityList
     * @return
     */
    int insertActivityByList(List<Activity> activityList);

    /**
     * 根据市场活动id查询活动的详细信息
     * @param id
     * @return
     */
    Activity selectActivityForDetailById(String id);

    /**
     * 根据线索id查出与其关联的所有市场活动
     * @param cluId
     * @return
     */
    List<Activity> selectActivityByClueId(String cluId);

    /**
     * 实现根据名称模糊查询市场火哦的那个，并排除已于当前线索关联过的火哦的那个
     * @param map
     * @return
     */
    List<Activity> selectActivityByActivityNameAndClueId(Map<String, Object> map);

    /**
     * 查询所有id所属的市场活动
     * @param ids
     * @return
     */
    List<Activity> selectActivityListByIds(String[] ids);
}