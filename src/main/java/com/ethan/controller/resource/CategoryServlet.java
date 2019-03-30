package com.ethan.controller.resource;

import com.alibaba.fastjson.JSON;
import com.ethan.dao.impl.CategoryDaoImpl;
import com.ethan.dao.impl.UserDaoImpl;
import com.ethan.entity.*;
import com.ethan.utils.ResponseUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/category")
public class CategoryServlet extends HttpServlet {
    CategoryDaoImpl categoryDao = new CategoryDaoImpl();
    Map<String, Object> map = new HashMap<String, Object>();
    Category category = new Category();
    Pagination pagination = new Pagination();
    String result = null;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");
        // 接收客户端信息

        String flagText = request.getParameter("flagText");

        if (flagText != null && flagText.equals("allCategory")) {
            String page = request.getParameter("page");
            String rows = request.getParameter("rows");
            String category_name = request.getParameter("category_name");

            category.setCategory_name(category_name);
            pagination.setCurPage(Long.valueOf(page));
            pagination.setPageSize(Long.valueOf(rows));

            List<Category> categories = null;
            long total = 0;

            try {
                categories = categoryDao.allCategoryList(category,pagination);
                total = categoryDao.categoryCount(category);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            map.put("rows", categories);
            map.put("total", total);

        } else if (flagText != null && flagText.equals("add")) {
            String category_name = request.getParameter("category_name");
            String category_desc = request.getParameter("category_desc");

            Category category = new Category(0,category_name,category_desc);
            int code = 0;

            try {
                code = categoryDao.addCategory(category);
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (code > 0) {
                map.put("success", "true");
                map.put("msg", "添加成功！");
            } else {
                map.put("success", "false");
                map.put("msg", "添加失败，请重试！");
            }

        }else if (flagText != null && flagText.equals("allCategoryList")) {
            List<Category> categories = null;


            try {
                categories = categoryDao.allCategory(null);
            } catch (SQLException e) {
                e.printStackTrace();
            }

            Category category = new Category(-1,"","");
            categories.add(0,category);

            result = JSON.toJSONString(categories);
            if (result != null) {
                try {
                    ResponseUtil.write(response, result);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            return;

        }else if (flagText != null && flagText.equals("update")) {
            String category_id = request.getParameter("category_id");
            String category_name = request.getParameter("category_name");
            String category_desc = request.getParameter("category_desc");

            Category category = new Category(Integer.parseInt(category_id),category_name,category_desc);
            int code = 0;

            try {
                code = categoryDao.updateCateGory(category);
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (code > 0) {
                map.put("success", "true");
                map.put("msg", "修改成功！");
            } else {
                map.put("success", "false");
                map.put("msg", "修改失败，请重试！");
            }

        } else if (flagText != null && flagText.equals("delete")) {
            String delIds = request.getParameter("delIds");

            List<String> category_ids = Arrays.asList(delIds.split(","));
            int delNums = 0;

            try {
                for(int i = 0;i<category_ids.size();i++) {
                    int code = 0;
                    Category category = new Category();
                    category.setCategory_id(Integer.parseInt(category_ids.get(i)));
                    code = categoryDao.delCategory(category);
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
