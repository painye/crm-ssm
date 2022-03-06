package com.yp.crm.workbench.web.controller;
/**
 * @author pan
 * @date 2022/3/6 9:54
 */

import com.sun.xml.internal.bind.v2.runtime.reflect.opt.Const;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @RequestMapping("/queryClueByConditionForPage.do")
    @ResponseBody
    public Object queryClueByConditionForPage(String fullname, String company, String source, String owner,
                                              Integer pageNo, Integer pageSize,String state){
        Map<String, Object> map =new HashMap<>();
        map.put("fullname", fullname);
        map.put("company",company );
        map.put("source",source );
        map.put("owner", owner);
        map.put("state", state);
        map.put("pageNo", (pageNo-1)*pageSize);
        map.put("pageSize", pageSize);
        Map<String, Object> retMap = new HashMap<>();

        List<Clue> clueList = clueService.queryClueByConditionForPage(map);
        int totalRows = clueService.queryClueCountByCondition(map);
        retMap.put("clueList", clueList);
        retMap.put("totalRows", totalRows);
        return retMap;
    }


    @RequestMapping("/deleteClue.do")
    @ResponseBody
    public Object deleteClue(String id){
        ReturnObject returnObject=new ReturnObject();
        try{
            int nums = clueService.deleteClueById(id);
            if(nums == 1){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                returnObject.setMessage(Constants.RETURN_OBJECT_MESSAGE);
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            returnObject.setMessage(Constants.RETURN_OBJECT_MESSAGE);
        }
        return returnObject;
    }

    @RequestMapping("/editClue.do")
    @ResponseBody
    public Object editClue(Clue clue, HttpSession session){
        ReturnObject returnObject=new ReturnObject();
        User user=(User) session.getAttribute(Constants.SESSION_USER);
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formateDateTime(new Date()));
        int nums = clueService.editClue(clue);
        if(nums ==1){
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }else {
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            returnObject.setMessage(Constants.RETURN_OBJECT_MESSAGE);
        }
        return returnObject;
    }

    @RequestMapping("/queryClue.do")
    @ResponseBody
    public Object queryClue(String id){
        ReturnObject returnObject = new ReturnObject();
        try{
            Clue clue=clueService.queryClue(id);
            if(clue!=null){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetObject(clue);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                returnObject.setMessage(Constants.RETURN_OBJECT_MESSAGE);
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            returnObject.setMessage(Constants.RETURN_OBJECT_MESSAGE);
        }
        return returnObject;
    }

}
