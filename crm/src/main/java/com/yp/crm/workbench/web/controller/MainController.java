package com.yp.crm.workbench.web.controller;
/**
 * @author pan
 * @date 2022/2/28 22:53
 */

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @ClassName : com.yp.crm.workbench.web.controller.MainController
 * @Description : 类描述
 * @author pan
 * @date 2022/2/28 22:53
 */

@Controller
@RequestMapping("workbench/main")
public class MainController {

    @RequestMapping("/index.do")
    public String index(){
        return "/workbench/main/index";
    }
}
