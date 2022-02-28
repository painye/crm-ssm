package com.yp.crm.settings.web.controller;
/**
 * @author pan
 * @date 2022/2/28 11:14
 */

import org.springframework.stereotype.Controller;

/**
 * @ClassName : com.yp.crm.settings.web.controller.UserController
 * @Description : 用来转发setting中user文件下的转发
 * @author pan
 * @date 2022/2/28 11:14
 */
@Controller
public class UserController {

    public String toLogin(){
        System.out.println("静茹登录页的转发");
        return "settings/qx/user/login";
    }
}
