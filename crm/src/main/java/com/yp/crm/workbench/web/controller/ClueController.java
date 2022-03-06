package com.yp.crm.workbench.web.controller;
/**
 * @author pan
 * @date 2022/3/6 9:54
 */

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @ClassName : com.yp.crm.workbench.web.controller.ClueController
 * @Description : 类描述
 * @author pan
 * @date 2022/3/6 9:54
 */
@Controller
@RequestMapping("/workbench/clue")
public class ClueController {

    @RequestMapping("/index.do")
    public ModelAndView index(){
        ModelAndView mv = new ModelAndView();




        mv.setViewName("workbench/clue/index");
        return mv;
    }
}
