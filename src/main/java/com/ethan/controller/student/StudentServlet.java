package com.ethan.controller.student;

import com.alibaba.fastjson.JSON;
import com.ethan.dao.impl.RegisterDaoImpl;
import com.ethan.dao.impl.UserDaoImpl;
import com.ethan.entity.*;
import com.ethan.factory.Factory;
import com.ethan.service.impl.UserServiceImpl;
import com.ethan.utils.Md5Util;
import com.ethan.utils.ResponseUtil;
import com.ethan.utils.StringUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/student")
public class StudentServlet extends HttpServlet {
    UserDaoImpl userDao = new UserDaoImpl();
    RegisterDaoImpl registerDao = new RegisterDaoImpl();
    Map<String, Object> map = new HashMap<String, Object>();
    Student student = new Student();
    Pagination pagination = new Pagination();
    String result = null;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");
        // 接收客户端信息

        String flagText = request.getParameter("flagText");

        if (flagText != null && flagText.equals("allStudent")) {
            String page = request.getParameter("page");
            String rows = request.getParameter("rows");
            String user_id = request.getParameter("user_id");

            student.setStudent_id(user_id);
            pagination.setCurPage(Long.valueOf(page));
            pagination.setPageSize(Long.valueOf(rows));

            List<AllEntity> students = null;
            long total = 0;

            try {
                students = userDao.getAllStudent(student,pagination);
                total = userDao.studentCount(student);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            map.put("rows", students);
            map.put("total", total);

        } else if (flagText != null && flagText.equals("addStudent")) {
            String user_id = request.getParameter("user_id");
            String password = request.getParameter("user_password");
            String name = request.getParameter("student_name");
            String student_class = request.getParameter("student_class");

            Register register = new Register(user_id, password, name, student_class, "学生", 0);
            User user = new User();
            user.setUser_id(user_id);
            int code = 0;
            try {
                if (registerDao.checkUser(user)) {
                    map.put("success", "false");
                    map.put("msg", "添加失败，帐号已存在！");
                } else {
                    code = registerDao.userRegister(register);
                    if (code > 0) {
                        map.put("msg", "添加成功！");
                        map.put("success", "true");
                    } else {
                        map.put("msg", "添加失败，请重试！");
                        map.put("success", "false");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

        } else if (flagText != null && flagText.equals("delete")) {
            String delIds = request.getParameter("delIds");

            List<String> user_ids = Arrays.asList(delIds.split(","));
            int delNums = 0;

            try {
                for(int i = 0;i<user_ids.size();i++) {
                    int code = 0;
                    User user = new User();
                    user.setUser_id(user_ids.get(i));
                    code = userDao.delUser(user);
                    if (code>0) {
                        delNums++;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (delNums > 0) {
                map.put("success", "true");
                map.put("msg", "删除成功！");
                map.put("delNums", delNums);
            } else {
                map.put("success", "false");
                map.put("msg", "删除失败，请重试！");
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
