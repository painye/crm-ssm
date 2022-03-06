package com.yp.crm.workbench.web.controller;
/**
 * @author pan
 * @date 2022/3/6 9:54
 */

import com.yp.crm.common.Constant.Constants;
import com.yp.crm.common.domain.ReturnObject;
import com.yp.crm.common.utils.DateUtils;
import com.yp.crm.common.utils.UUIDUtils;
import com.yp.crm.settings.domain.User;
import com.yp.crm.settings.service.UserService;
import com.yp.crm.workbench.domain.Clue;
import com.yp.crm.workbench.domain.DictionaryValue;
import com.yp.crm.workbench.service.ClueService;
import com.yp.crm.workbench.service.DictionaryValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

/**
 * @ClassName : com.yp.crm.workbench.web.controller.ClueController
 * @Description : 类描述
 * @author pan
 * @date 2022/3/6 9:54
 */
@Controller
@RequestMapping("/workbench/clue")
public class ClueController {
    @Autowired
    private DictionaryValueService dictionaryValueService;

    @Autowired
    private ClueService clueService;

    @Autowired
    private UserService userService;

    @RequestMapping("/index.do")
    public ModelAndView index(){
        ModelAndView mv = new ModelAndView();
        List<User> users = userService.queryAllUser();
        List<DictionaryValue> appellations = dictionaryValueService.queryDictionaryValueList("appellation");
        List<DictionaryValue> clueStates = dictionaryValueService.queryDictionaryValueList("clueState");
        List<DictionaryValue> sources = dictionaryValueService.queryDictionaryValueList("source");
        mv.addObject("users",users);
        mv.addObject("appellations",appellations);
        mv.addObject("clueStates",clueStates);
        mv.addObject("sources",sources);
        mv.setViewName("workbench/clue/index");
        return mv;
    }


    @RequestMapping("/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session){
        User user=(User) session.getAttribute(Constants.SESSION_USER);
        clue.setId(UUIDUtils.getUUid());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtils.formateDateTime(new Date()));
        ReturnObject returnObject = new ReturnObject();
        try{
            int nums = clueService.addClue(clue);
            if(nums == 1){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                returnObject.setMessage("系统正忙，请稍后...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            returnObject.setMessage("系统正忙，请稍后...");
        }
        return returnObject;
    }
}
