package com.yp.crm.workbench.web.controller;
/**
 * @author pan
 * @date 2022/3/1 9:40
 */

import com.yp.crm.settings.domain.User;
import com.yp.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

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

    @RequestMapping("index.do")
    public ModelAndView index(){
        ModelAndView mv = new ModelAndView();
        List<User> userList = userService.queryAllUser();
        mv.addObject("userList", userList);
        mv.setViewName("workbench/activity/index");
        return mv;
    }
}
