package com.yp.crm.web.controller;
/**
 * @author pan
 * @date 2022/2/28 11:02
 */

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @ClassName : com.yp.crm.web.controller.IndexController
 * @Description : 用来处理用户首页的转发
 * @author pan
 * @date 2022/2/28 11:02
 */

@Controller
public class IndexController {

    @RequestMapping("/")
    public String toIndex(){
        System.out.println("进入欢迎页");
        return "index";
    }
}
