package com.yp.crm.workbench.web.controller;
/**
 * @author pan
 * @date 2022/3/5 14:19
 */

import com.yp.crm.common.Constant.Constants;
import com.yp.crm.common.domain.ReturnObject;
import com.yp.crm.common.utils.DateUtils;
import com.yp.crm.common.utils.UUIDUtils;
import com.yp.crm.settings.domain.User;
import com.yp.crm.workbench.domain.ActivityRemark;
import com.yp.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @ClassName : com.yp.crm.workbench.web.controller.ActivityRemarkController
 * @Description : 类描述
 * @author pan
 * @date 2022/3/5 14:19
 */

@RequestMapping("/workbench/activity/")
@Controller
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("createActivityRemark.do")
    @ResponseBody
    private Object createActivityRemark(ActivityRemark activityRemark, HttpSession session){
        activityRemark.setId(UUIDUtils.getUUid());
        activityRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        User user= (User) session.getAttribute(Constants.SESSION_USER);
        activityRemark.setCreateBy(user.getId());
        activityRemark.setEditFlag("0");

        ReturnObject returnObject = new ReturnObject();
        try{
            int nums = activityRemarkService.createActivityRemark(activityRemark);
            if(nums == 1){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                activityRemark.setCreateBy(user.getName());
                returnObject.setRetObject(activityRemark);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                returnObject.setMessage("系统正忙，请稍后再试。。。");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            returnObject.setMessage("系统正忙，请稍后再试。。。");
        }
        return returnObject;
    }

    @RequestMapping("deleteActivityRemark.do")
    @ResponseBody
    public Object deleteActivityRemark(String id){
        ReturnObject  returnObject = new ReturnObject();
        try {
            int nums = activityRemarkService.deleteActivityRemark(id);
            if(nums == 1){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                returnObject.setMessage("系统正忙,请稍后...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            returnObject.setMessage("系统正忙,请稍后...");
        }
        return  returnObject;
    }

    @RequestMapping("editActivityRemark.do")
    @ResponseBody
    public Object editActivityRemark(ActivityRemark activityRemark, HttpSession httpSession){
        ReturnObject returnObject=new ReturnObject();
        activityRemark.setEditFlag("1");
        activityRemark.setEditTime(DateUtils.formateDateTime(new Date()));
        User user = (User) httpSession.getAttribute(Constants.SESSION_USER);
        activityRemark.setEditBy(user.getId());

        try{
            int nums = activityRemarkService.editActivityRemark(activityRemark);
            if(nums ==1){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetObject(activityRemark);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                returnObject.setMessage("系统正忙，请稍后....");
            }
        }catch(Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            returnObject.setMessage("系统正忙，请稍后....");
        }
        return returnObject;
    }
}
