package com.yp.crm.workbench.web.controller;
/**
 * @author pan
 * @date 2022/2/28 16:51
 */

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @ClassName : com.yp.crm.workbench.web.controller.WorkbenchIndexController
 * @Description : 类描述
 * @author pan
 * @date 2022/2/28 16:51
 */

@Controller
@RequestMapping("/workbench")
public class WorkbenchIndexController {

    @RequestMapping("/index.do")
    public String index(){
        return "workbench/index";
    }
}
