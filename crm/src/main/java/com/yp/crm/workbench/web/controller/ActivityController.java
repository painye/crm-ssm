package com.yp.crm.workbench.web.controller;
/**
 * @author pan
 * @date 2022/3/1 9:40
 */

import com.yp.crm.common.Constant.Constants;
import com.yp.crm.common.domain.ReturnObject;
import com.yp.crm.common.utils.DateUtils;
import com.yp.crm.common.utils.UUIDUtils;
import com.yp.crm.settings.domain.User;
import com.yp.crm.settings.service.UserService;
import com.yp.crm.workbench.domain.Activity;
import com.yp.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.rmi.CORBA.Util;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;


/**
 * @ClassName : com.yp.crm.workbench.web.controller.ActivityController
 * @Description : 类描述
 * @author pan
 * @date 2022/3/1 9:40
 */

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {
    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @RequestMapping("/index.do")
    public ModelAndView index(){
        ModelAndView mv = new ModelAndView();
        List<User> userList = userService.queryAllUser();
        mv.addObject("userList", userList);
        mv.setViewName("workbench/activity/index");
        return mv;
    }


    @ResponseBody
    @RequestMapping("/createActivity.do")
    public ReturnObject createActivity(Activity activity, HttpSession session){
        //封装参数
        activity.setId(UUIDUtils.getUUid());
        activity.setCreatetime(DateUtils.formateDateTime(new Date()));
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activity.setCreateby(user.getId());
        System.out.println(activity.getStartdate()+" "+activity.getEnddate());
        //调用参数
        //返回响应
        ReturnObject retObject = new ReturnObject();
        try{
            int num = activityService.addActivity(activity);
            if(num == 1){
                //添加市场活动成功
                retObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                retObject.setMessage("插入失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            retObject.setMessage("插入失败");
        }
        return retObject;
    }

    @RequestMapping("/queryActivityByConditionForPage.do")
    @ResponseBody
    public Object queryActivityByConditionForPage(String name, String owner, String startDate, String endDate
                                                  ,Integer pageNo, Integer pageSize
                                                    ){
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        System.out.println(pageNo);
        map.put("beginNo", (pageNo-1)*pageSize);
        map.put("pageSize", pageSize);
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        int totalRows = activityService.queryActivityByConditionCounts(map);
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("activityList",activityList );
        retMap.put("totalRows",totalRows );
        return retMap;
    }

    @RequestMapping("/deleteCheckedActivity.do")
    @ResponseBody
    public Object deleteCheckedActivity(String[] ids){
        for(String id : ids){
            System.out.println(id);
        }
        ReturnObject returnObject = new ReturnObject();
        try {
            int nums = activityService.deleteCheckedActivity(ids);
            if(nums> 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                returnObject.setMessage("系统正忙，请稍后重试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            returnObject.setMessage("系统正忙，请稍后重试");
        }
        return returnObject;
    }

    @RequestMapping("/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id){
        return activityService.queryActivityById(id);
    }

    @RequestMapping("/editActivity.do")
    @ResponseBody
    public Object editActivity(Activity activity, HttpSession session){
        ReturnObject retObject = new ReturnObject();
        User user= (User) session.getAttribute(Constants.SESSION_USER);
        activity.setEditby(user.getId());
        activity.setEdittime(DateUtils.formateDateTime(new Date()));
        try{
            int nums = activityService.editActivityByCondition(activity);
            if(nums == 1){
                retObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                retObject.setMessage("系统正忙， 请稍后再试");
            }
        }catch (Exception e){
            e.printStackTrace();
            retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            retObject.setMessage("系统正忙， 请稍后再试");
        }
        return retObject;
    }

    @RequestMapping("/detail.do")
    public String detail(){
        return "workbench/activity/detail";
    }

    @RequestMapping("/download.do")
    public void download(HttpServletResponse response) throws IOException {
        //1、设置response的响应格式
        response.setContentType("application/octet-stream;charset=UTF-8");
        //2、获取响应的字节输出流
        OutputStream outputStream = response.getOutputStream();

        //设置响应头信息，当浏览器接受到后台发送过来的文件的时候不是直接打开该文件而是
        //以附件的形式直接下载
        response.addHeader("Content-Disposition", "attachment;filename=studentList.xls");

        //3、创建读取excel文件的字节输入流
        InputStream inputStream = new FileInputStream("C:\\Users\\dell\\Desktop\\user.xls");
        //4、将读入的字节写入到响应的字节输出流中去
        byte[] buff=new byte[256];
        int len = 0;
        while((len = inputStream.read(buff))!=-1){
            outputStream.write(buff,0, len);
        }

        //关闭各种流
        inputStream.close();
        outputStream.flush();
    }

    @RequestMapping("/exportAllActivity.do")
    public void exportAllActivity(HttpServletResponse response) throws IOException {
        System.out.println("--------------------------------------------------------");
        List<Activity> activityList = activityService.queryAllActivity();
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("ActivityList");
        HSSFRow row = sheet.createRow(0);
        //准备设置表头
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("活动名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        //存入所有市场活动的内容
        int i =1;
        for(Activity activity: activityList){
            row = sheet.createRow(i);
            cell = row.createCell(0);
            cell.setCellValue(activity.getId());
            cell = row.createCell(1);
            cell.setCellValue(activity.getOwner());
            cell = row.createCell(2);
            cell.setCellValue(activity.getName());
            cell = row.createCell(3);
            cell.setCellValue(activity.getStartdate());
            cell = row.createCell(4);
            cell.setCellValue(activity.getEnddate());
            cell = row.createCell(5);
            cell.setCellValue(activity.getCost());
            cell = row.createCell(6);
            cell.setCellValue(activity.getDescription());
            cell = row.createCell(7);
            cell.setCellValue(activity.getCreatetime());
            cell = row.createCell(8);
            cell.setCellValue(activity.getCreateby());
            cell = row.createCell(9);
            cell.setCellValue(activity.getEdittime());
            cell = row.createCell(10);
            cell.setCellValue(activity.getEditby());
            i++;
        }

//        OutputStream os = new FileOutputStream("C:\\Users\\dell\\Desktop\\activityList.xls");
//        wb.write(os);
//
//        os.flush();
//        wb.close();


        //将文件发到浏览器上
        //设置response的响应格式
        response.setContentType("application/octet-stream;charset=UTF-8");
        //获取字节数出流
        OutputStream out = response.getOutputStream();
        //设置响应头信息，当浏览器接受到后台发送过来的文件的时候不是直接打开该文件而是
        //以附件的形式直接下载
        response.addHeader("Content-Disposition", "attachment;filename=MyActivityList.xls");
//        InputStream is = new FileInputStream("C:\\Users\\dell\\Desktop\\activityList.xls");
//        byte[] buff = new byte[256];
//        int len = 0;
//        while((len = is.read(buff))!=-1){
//            out.write(buff, 0 ,len);
//        }
        wb.write(out);
        wb.close();
        out.flush();
    }


    @RequestMapping("/queryCheckedActivityById.do")
    public void queryCheckedActivityById(String[] id, HttpServletResponse response) throws IOException {
        //1、收集要选中的内容
        List<Activity> activityList = activityService.queryCheckedActivityById(id);

        //2、将内容写到HSSFWorkbook中
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("CheckedActivityList");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("活动名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        //存入所有市场活动的内容
        int i =1;
        for(Activity activity: activityList){
            row = sheet.createRow(i);
            cell = row.createCell(0);
            cell.setCellValue(activity.getId());
            cell = row.createCell(1);
            cell.setCellValue(activity.getOwner());
            cell = row.createCell(2);
            cell.setCellValue(activity.getName());
            cell = row.createCell(3);
            cell.setCellValue(activity.getStartdate());
            cell = row.createCell(4);
            cell.setCellValue(activity.getEnddate());
            cell = row.createCell(5);
            cell.setCellValue(activity.getCost());
            cell = row.createCell(6);
            cell.setCellValue(activity.getDescription());
            cell = row.createCell(7);
            cell.setCellValue(activity.getCreatetime());
            cell = row.createCell(8);
            cell.setCellValue(activity.getCreateby());
            cell = row.createCell(9);
            cell.setCellValue(activity.getEdittime());
            cell = row.createCell(10);
            cell.setCellValue(activity.getEditby());
            i++;
        }

        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition", "attachment;filename=CheckedActivityList.xls");

        OutputStream out = response.getOutputStream();
        wb.write(out);

        wb.close();
        out.flush();
        return;
    }

    @RequestMapping("/upload.do")
    @ResponseBody
    //配置文件解析器
    public Object upload(String userName, MultipartFile myFile) throws IOException {
        System.out.println("userName="+userName);
        //把文件存入到指定的文件中
        File file = new File("C:\\Users\\dell\\Desktop\\upload.xls");
        myFile.transferTo(file);

        ReturnObject returnObject = new ReturnObject();
        returnObject.setMessage("上传成功");
        return returnObject;
    }


    @RequestMapping("/addActivityByList.do")
    @ResponseBody
    public Object addActivityByList(MultipartFile activityFile, HttpSession session) throws IOException {
//        File file = new File("C:\\Users\\dell\\Desktop\\",activityFile.getOriginalFilename());
//        activityFile.transferTo(file);
//
//        InputStream is = new FileInputStream("C:\\Users\\dell\\Desktop\\"+activityFile.getOriginalFilename());
        InputStream is = activityFile.getInputStream();
        HSSFWorkbook wb = new HSSFWorkbook(is);
        HSSFSheet sheet = wb.getSheetAt(0);
        List<Activity> activityList = new ArrayList<>();

        User user= (User) session.getAttribute(Constants.SESSION_USER);
        for(int i=1; i<=sheet.getLastRowNum(); i++){
            Activity activity = new Activity();
            HSSFRow row = sheet.getRow(i);

            activity.setId(UUIDUtils.getUUid());
            activity.setOwner(user.getId());
            HSSFCell cell=row.getCell(0);
            activity.setName(cell.getStringCellValue());
            cell = row.getCell(1);
            activity.setStartdate(cell.getStringCellValue());
            cell = row.getCell(2);
            activity.setEnddate(cell.getStringCellValue());
            cell = row.getCell(3);
            activity.setCost(cell.getStringCellValue());
            cell = row.getCell(4);
            activity.setDescription(cell.getStringCellValue());
            activity.setCreatetime(DateUtils.formateDateTime(new Date()));
            activity.setCreateby(user.getId());

            activityList.add(activity);
        }
        ReturnObject retObject = new ReturnObject();
        try{
            int nums = activityService.addActivityByList(activityList);
            if(nums>0){
                retObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                retObject.setMessage("共有"+nums+"记录成功存入");
            }else{
                retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
                retObject.setMessage("系统正忙，请稍后");
            }
        }catch (Exception e){
            e.printStackTrace();
            retObject.setCode(Constants.RETURN_OBJECT_CODE_FAIl);
            retObject.setMessage("系统正忙，请稍后");
        }
        return retObject;
    }


}
