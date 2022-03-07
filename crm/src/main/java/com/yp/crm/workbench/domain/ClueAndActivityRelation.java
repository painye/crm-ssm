package com.yp.crm.workbench.domain;
/**
 * @author pan
 * @date 2022/3/7 20:36
 */

/**
 * @ClassName : com.yp.crm.workbench.domain.ClueAndActivityRelation
 * @Description : 类描述
 * @author pan
 * @date 2022/3/7 20:36
 */
public class ClueAndActivityRelation {
    private String id;
    private String activityId;
    private String clueId;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    @Override
    public String toString() {
        return "ClueAndActivityRelation{" +
                "id='" + id + '\'' +
                ", activityId='" + activityId + '\'' +
                ", clueId='" + clueId + '\'' +
                '}';
    }

    public String getClueId() {
        return clueId;
    }

    public void setClueId(String clueId) {
        this.clueId = clueId;
    }
}
