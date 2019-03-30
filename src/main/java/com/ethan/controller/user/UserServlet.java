package com.ethan.controller.user;

import com.ethan.entity.User;
import com.ethan.factory.Factory;
import com.ethan.service.impl.UserServiceImpl;
import com.ethan.utils.StringUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/user")
//@WebServlet("/userLogin")
public class UserServlet extends HttpServlet {
    User user = Factory.getUser();
    UserServiceImpl userService = Factory.getUserServiceInstance();
    Map<String, Object> map = new HashMap<String, Object>();
    String result = null;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");
        // 接收客户端信息

        String flagText = request.getParameter("flagText");

        if (flagText != null && flagText.equals("login")) {

            String id = request.getParameter("user_id");
            String password = request.getParameter("user_password");

            System.out.println(id);
            System.out.println(password);

            if (StringUtil.isEmpty(id) || StringUtil.isEmpty(password)) {
                request.setAttribute("error", "用户名或密码为空！");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            user.setUser_id(id);
            user.setUser_password(password);

            System.out.println(user.toString());

            User currentUser = null;
            try {
                currentUser = userService.login(user);
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (currentUser == null) {
                request.setAttribute("error", "用户名或密码错误！");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            } else {
                // 获取Session
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", currentUser);
                System.out.println(currentUser.toString());
                // 客户端跳转
                if (currentUser.getUser_level().equals("管理员")|| currentUser.getUser_level().equals("超级管理员")) {
                    response.sendRedirect("admin/main");
                    return;
                }
                response.sendRedirect("main");
            }
        } else {
            response.sendRedirect("../error");
        }

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
