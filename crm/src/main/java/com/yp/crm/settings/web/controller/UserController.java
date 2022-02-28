package com.yp.crm.settings.web.controller;
/**
 * @author pan
 * @date 2022/2/28 11:14
 */

import com.yp.crm.common.domain.ReturnObject;
import com.yp.crm.settings.domain.User;
import com.yp.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @ClassName : com.yp.crm.settings.web.controller.UserController
 * @Description : 用来转发setting中user文件下的转发
 * @author pan
 * @date 2022/2/28 11:14
 */
@Controller
@RequestMapping("/settings/qx/user")
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/toLogin.do")
    public String toLogin(){
        System.out.println("进入登录页的转发");
        return "settings/qx/user/login";
    }


    @RequestMapping("/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest httpServletRequest){
        Map<String , Object> map =new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
        User user = userService.queryUserByLoginActAndLoginPwd(map);
        SimpleDateFormat sdf = new SimpleDateFormat("YY-MM-DD HH:mm:ss");
        Date nowTime = new Date();
        String nowStr = sdf.format(nowTime);
        System.out.println(nowStr);
        ReturnObject retObject = new ReturnObject();
        if(user == null){
            retObject.setCode("0");
            retObject.setMessage("账户密码错误");
        }else if(nowStr.compareTo(user.getExpiretime())<0){
            //登陆失败，该账号已过期
            retObject.setMessage("该账号已过期");
            retObject.setCode("0");
        }else if("0".equals(user.getLockstate())){
            //登陆失败，账号已被锁定
            retObject.setCode("0");
            retObject.setMessage("账号已被锁定");
        }else if(!user.getAllowips().contains(httpServletRequest.getRemoteAddr())){
            //登陆失败，Ip不被允许
            retObject.setCode("0");
            retObject.setMessage("Ip不被允许");
        }else{
            retObject.setCode("1");
        }
        System.out.println(user+" "+retObject);
        return retObject;
    }
}
