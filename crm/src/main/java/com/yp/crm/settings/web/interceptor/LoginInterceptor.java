package com.yp.crm.settings.web.interceptor;
/**
 * @author pan
 * @date 2022/2/28 21:48
 */

import com.yp.crm.common.Constant.Constants;
import com.yp.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @ClassName : com.yp.crm.settings.web.interceptor.LoginInterceptor
 * @Description : 类描述
 * @author pan
 * @date 2022/2/28 21:48
 */
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        //1、获取session中的user对象，
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        if(user == null){
            //说明此时用户还未登陆，从session中拿不到user；
            response.sendRedirect(request.getContextPath());
            System.out.println("已拦截");
            return false;
        }
        return true;
    }
}
