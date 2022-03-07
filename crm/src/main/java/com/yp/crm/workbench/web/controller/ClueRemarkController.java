package com.yp.crm.workbench.web.controller;
/**
 * @author pan
 * @date 2022/3/7 12:58
 */

import com.yp.crm.common.Constant.Constants;
import com.yp.crm.common.domain.ReturnObject;
import com.yp.crm.common.utils.DateUtils;
import com.yp.crm.common.utils.UUIDUtils;
import com.yp.crm.settings.domain.User;
import com.yp.crm.workbench.domain.ClueRemark;
import com.yp.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @ClassName : com.yp.crm.workbench.web.controller.ClueRemarkController
 * @Description : 类描述
 * @author pan
 * @date 2022/3/7 12:58
 */

@Controller
@RequestMapping("/workbench/clue")
public class ClueRemarkController {
    @Autowired
    private ClueRemarkService clueRemarkService;

    @RequestMapping("/addClueRemark.do")
    @ResponseBody
    public Object addClueRemark(ClueRemark clueRemark, HttpSession session){
        //1、封装参数
        clueRemark.setId(UUIDUtils.getUUid());
        clueRemark.setEditFlag("0");
        User user=(User) session.getAttribute(Constants.SESSION_USER);
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateUtils.formateDateTime(new Date()));

        int nums = clueRemarkService.addClueRemark(clueRemark);
        ReturnObject returnObject = new ReturnObject();

        if(nums == 1){
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetObject(clueRemark);
        }else {
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            returnObject.setMessage(Constants.RETURN_OBJECT_MESSAGE);
        }
        return returnObject;
    }

}
