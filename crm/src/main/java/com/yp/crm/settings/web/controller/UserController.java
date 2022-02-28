package com.yp.crm.settings.web.controller;
/**
 * @author pan
 * @date com.yp.crm.common.Constant.Constants.RETURN_OBJECT_CODE_FAIl22/2/28 11:14
 */

import com.yp.crm.common.Constant.Constants;
import com.yp.crm.common.domain.ReturnObject;
import com.yp.crm.common.utils.DateUtils;
import com.yp.crm.settings.domain.User;
import com.yp.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @ClassName : com.yp.crm.settings.web.controller.UserController
 * @Description : 用来转发setting中user文件下的转发
 * @author pan
 * @date com.yp.crm.common.Constant.Constants.RETURN_OBJECT_CODE_FAIl22/2/28 11:14
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
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, HttpSession session){
        System.out.println("进行登录");
        Map<String , Object> map =new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
        User user = userService.queryUserByLoginActAndLoginPwd(map);
        Date nowTime = new Date();
        final String nowStr = DateUtils.formateDateTime(nowTime);
        ReturnObject retObject = new ReturnObject();
        if(user == null){
            retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            retObject.setMessage("账户密码错误");
        }else if(nowStr.compareTo(user.getExpiretime()) < 0){
            //登陆失败，该账号已过期
            retObject.setMessage("该账号已过期");
            retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
        }else if(Constants.RETURN_OBJECT_CODE_FAIl.equals(user.getLockstate())){
            //登陆失败，账号已被锁定
            retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            retObject.setMessage("账号已被锁定");
        }else if(!user.getAllowips().contains(httpServletRequest.getRemoteAddr())){
            //登陆失败，Ip不被允许
            retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            retObject.setMessage("Ip不被允许");
        }else{
            //登陆成功
            retObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            session.setAttribute(Constants.SESSION_USER, user);

            if("true".equals(isRemPwd)){
                //用户勾选了十天内记住密码，我们需要向response中加入cookie

                Cookie c1 = new Cookie("loginAct", loginAct);
                c1.setMaxAge(10*24*60*60);
                httpServletResponse.addCookie(c1);
                Cookie c2 = new Cookie("loginPwd", loginPwd);
                c2.setMaxAge(10*24*60*60);
                httpServletResponse.addCookie(c2);

            }else {
                //删除没有过期的cookie
                Cookie c1 = new Cookie("loginAct", "1");
                c1.setMaxAge(0);
                httpServletResponse.addCookie(c1);
                Cookie c2 = new Cookie("loginPwd", "1");
                c2.setMaxAge(0);
                httpServletResponse.addCookie(c2);
            }
        }
        return retObject;
    }


    @RequestMapping("logout.do")
    public String logout(HttpServletResponse response, HttpSession session){
        //1、清除cookie
        Cookie c1 = new Cookie("loginAct", "1");
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2 = new Cookie("loginPwd", "1");
        c2.setMaxAge(0);
        response.addCookie(c2);
        //2、销毁session
        session.invalidate();
        //3、转发到首页,利用重定向
        return "redirect:/";

    }
}
