package com.ethan.controller.user;

import com.alibaba.fastjson.JSON;
import com.ethan.dao.impl.RegisterDaoImpl;
import com.ethan.dao.impl.UserDaoImpl;
import com.ethan.entity.*;
import com.ethan.utils.ResponseUtil;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    RegisterDaoImpl registerDao = new RegisterDaoImpl();
    Map<String, Object> map = new HashMap<String, Object>();
    Pagination pagination = new Pagination();
    String result = null;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");
        // 接收客户端信息

        String flagText = request.getParameter("flagText");

        if (flagText != null && flagText.equals("allRegister")) {
            String page = request.getParameter("page");
            String rows = request.getParameter("rows");


            pagination.setCurPage(Long.valueOf(page));
            pagination.setPageSize(Long.valueOf(rows));

            List<Register> registers = null;
            long total = 0;

            try {
                registers = registerDao.allRegister(pagination);
                total = registerDao.registerCount();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            map.put("rows", registers);
            map.put("total", total);

        } else if (flagText != null && flagText.equals("update")) {
            String delIds = request.getParameter("delIds");

            List<String> register_ids = Arrays.asList(delIds.split(","));
            int delNums = 0;
            try {
                for(int i = 0;i<register_ids.size();i++) {
                    int code = 0;
                    Register register = new Register();
                    register.setRegister_id(register_ids.get(i));
                    code = registerDao.updateRegister(register);
                    if (code>0) {
                        delNums++;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (delNums > 0) {
                map.put("success", "true");
                map.put("msg", "审核成功！");
                map.put("delNums", delNums);
            } else {
                map.put("success", "false");
                map.put("msg", "审核失败，请重试！");
            }


        } else if (flagText != null && flagText.equals("addRegister")) {
            int code = 0;
            String registerFilePath = null;
            boolean isMultipart = ServletFileUpload.isMultipartContent(request);
            if (isMultipart) {
                // 创建工厂（这里用的是工厂模式）
                DiskFileItemFactory factory = new DiskFileItemFactory();
                //获取汽车零件清单与组装说明书（从ServletContext中得到上传来的数据）
                ServletContext servletContext = this.getServletConfig().getServletContext();
                File repository = (File) servletContext.getAttribute("javax.servlet.context.tempdir");
                //工厂把将要组装的汽车的参数录入工厂自己的系统，因为要根据这些参数开设一条生产线（上传来的文件的各种属性）
                factory.setRepository(repository);
                //此时工厂中已经有了汽车的组装工艺、颜色等属性参数（上传来的文件的大小、文件名等）
                //执行下面的这一行代码意味着根据组装工艺等开设了一条组装生产线
                ServletFileUpload upload = new ServletFileUpload(factory);
                //解析请求
                try {
                    //把零件送给生产线，出来的就是一辆组装好的汽车（把request转成FileItem的实例）
                    List<FileItem> items = upload.parseRequest(request);
                    Iterator<FileItem> iter = items.iterator();
                    while (iter.hasNext()) {
                        FileItem item = iter.next();
                        boolean isForm = item.isFormField();
                        if (isForm) {
                            String name = item.getFieldName();

                        } else {
                            if (item.getSize()>10) {
                                String name = item.getFieldName();
                                String itemName = new String(item.getName().getBytes("GBK"),"UTF-8");
                                String uploadFilePath = "";
                                String filePath = request.getServletContext().getRealPath("upload");
                                System.out.println(filePath);
                                if ("registerFile".equals(name)) {
                                    uploadFilePath = filePath+"/registerFile";
                                } else {

                                }
                                File file = new File(uploadFilePath,itemName);
                                registerFilePath = file.getPath();
                                System.out.println(registerFilePath);

                                if (!file.exists()) {
                                    try {
                                        file.createNewFile();
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                    }
                                }
                                FileOutputStream fos = new FileOutputStream(file);
                                //创建输入流
                                InputStream fis = (InputStream) item.getInputStream();
                                //从输入流获取字节数组
                                byte b[] = new byte[1];
                                //读取一个输入流的字节到b[0]中
                                int read = fis.read(b);
                                while (read != -1) {
                                    fos.write(b, 0, 1);
                                    read = fis.read(b);
                                }
                                fis.close();
                                fos.flush();
                                fos.close();
                                //打印List中的内容（每一个FileItem的实例代表一个文件，执行这行代码会打印该文件的一些基本属性，文件名，大小等）
                                System.out.println(item);
                            }
                        }
                    }
                    System.out.println("输出完成");

                } catch ( FileUploadException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
            try {
                code = registerDao.bulkImport(registerFilePath);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (code > 0) {
                map.put("success", "true");
                map.put("msg", "导入成功！");
            } else {
                map.put("success", "false");
                map.put("msg", "导入失败，请重试！");
            }
        } else{
            response.sendRedirect("../error");
        }

        result = JSON.toJSONString(map);
        map.clear();
        if (result != null) {
            try {
                ResponseUtil.write(response, result);
                result = null;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return;

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
