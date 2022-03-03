package com.yp.crm.workbench.web.controller;
/**
 * @author pan
 * @date 2022/3/1 9:40
 */

import com.yp.crm.common.Constant.Constants;
import com.yp.crm.common.domain.ReturnObject;
import com.yp.crm.common.utils.DateUtils;
import com.yp.crm.common.utils.UUIDUtils;
import com.yp.crm.settings.domain.User;
import com.yp.crm.settings.service.UserService;
import com.yp.crm.workbench.domain.Activity;
import com.yp.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @ClassName : com.yp.crm.workbench.web.controller.ActivityController
 * @Description : 类描述
 * @author pan
 * @date 2022/3/1 9:40
 */

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {
    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @RequestMapping("index.do")
    public ModelAndView index(){
        ModelAndView mv = new ModelAndView();
        List<User> userList = userService.queryAllUser();
        mv.addObject("userList", userList);
        mv.setViewName("workbench/activity/index");
        return mv;
    }


    @ResponseBody
    @RequestMapping("createActivity.do")
    public ReturnObject createActivity(Activity activity, HttpSession session){
        //封装参数
        activity.setId(UUIDUtils.getUUid());
        activity.setCreatetime(DateUtils.formateDateTime(new Date()));
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activity.setCreateby(user.getId());
        System.out.println(activity.getStartdate()+" "+activity.getEnddate());
        //调用参数
        //返回响应
        ReturnObject retObject = new ReturnObject();
        try{
            int num = activityService.addActivity(activity);
            if(num == 1){
                //添加市场活动成功
                retObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                retObject.setMessage("插入失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            retObject.setMessage("插入失败");
        }
        return retObject;
    }

    @RequestMapping("/queryActivityByConditionForPage.do")
    @ResponseBody
    public Object queryActivityByConditionForPage(String name, String owner, String startDate, String endDate
                                                  ,Integer pageNo, Integer pageSize
                                                    ){
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        System.out.println(pageNo);
        map.put("beginNo", (pageNo-1)*pageSize);
        map.put("pageSize", pageSize);
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        int totalRows = activityService.queryActivityByConditionCounts(map);
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("activityList",activityList );
        retMap.put("totalRows",totalRows );
        return retMap;
    }

    @RequestMapping("deleteCheckedActivity.do")
    @ResponseBody
    public Object deleteCheckedActivity(String[] ids){
        for(String id : ids){
            System.out.println(id);
        }
        ReturnObject returnObject = new ReturnObject();
        try {
            int nums = activityService.deleteCheckedActivity(ids);
            if(nums> 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                returnObject.setMessage("系统正忙，请稍后重试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            returnObject.setMessage("系统正忙，请稍后重试");
        }
        return returnObject;
    }

    @RequestMapping("/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id){
        return activityService.queryActivityById(id);
    }

    @RequestMapping("editActivity.do")
    @ResponseBody
    public Object editActivity(Activity activity, HttpSession session){
        ReturnObject retObject = new ReturnObject();
        User user= (User) session.getAttribute(Constants.SESSION_USER);
        activity.setEditby(user.getId());
        activity.setEdittime(DateUtils.formateDateTime(new Date()));
        try{
            int nums = activityService.editActivityByCondition(activity);
            if(nums == 1){
                retObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                retObject.setMessage("系统正忙， 请稍后再试");
            }
        }catch (Exception e){
            e.printStackTrace();
            retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            retObject.setMessage("系统正忙， 请稍后再试");
        }
        return retObject;
    }

    @RequestMapping("/detail.do")
    public String detail(){
        return "workbench/activity/detail";
    }
}
