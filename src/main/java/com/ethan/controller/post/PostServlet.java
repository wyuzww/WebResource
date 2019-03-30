package com.ethan.controller.post;

import com.alibaba.fastjson.JSON;
import com.ethan.dao.impl.PostDaoImpl;
import com.ethan.dao.impl.ResourceDaoImpl;
import com.ethan.entity.AllEntity;
import com.ethan.entity.Pagination;
import com.ethan.entity.Post;
import com.ethan.entity.Resource;
import com.ethan.utils.ResponseUtil;
import com.ethan.utils.StringUtil;

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

@WebServlet("/post")
public class PostServlet extends HttpServlet {
    PostDaoImpl postDao = new PostDaoImpl();
    Map<String, Object> map = new HashMap<String, Object>();
    Pagination pagination = new Pagination();
    String result = null;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");
        // 接收客户端信息

        String flagText = request.getParameter("flagText");

        if (flagText != null && flagText.equals("allPost")) {
            String page = request.getParameter("page");
            String rows = request.getParameter("rows");
            String post_title = request.getParameter("post_title");
            String user_level = request.getParameter("user_level");

            System.out.println(post_title);

            AllEntity allEntity = new AllEntity();
            pagination.setCurPage(Long.valueOf(page));
            pagination.setPageSize(Long.valueOf(rows));

            allEntity.setPost_title(post_title);
            allEntity.setUser_level(user_level);

            List<AllEntity> posts = null;
            long total = 0;

            try {
                posts = postDao.allPost(allEntity,pagination);
                total = postDao.postCount(allEntity);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            map.put("rows", posts);
            map.put("total", total);

        } else if (flagText != null && flagText.equals("delete")) {
            String delIds = request.getParameter("delIds");

            List<String> post_ids = Arrays.asList(delIds.split(","));
            int delNums = 0;

            try {
                for(int i = 0;i<post_ids.size();i++) {
                    int code = 0;
                    Post post = new Post();
                    post.setPost_id(Integer.parseInt(post_ids.get(i)));
                    code = postDao.delPost(post);
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
        }else{
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
