package com.ethan.controller.post;

import com.alibaba.fastjson.JSON;
import com.ethan.dao.impl.CommentDaoImpl;
import com.ethan.dao.impl.RegisterDaoImpl;
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

@WebServlet("/comment")
public class CommentServlet extends HttpServlet {
    CommentDaoImpl commentDao = new CommentDaoImpl();
    Map<String, Object> map = new HashMap<String, Object>();
    Pagination pagination = new Pagination();
    String result = null;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");
        // 接收客户端信息

        String flagText = request.getParameter("flagText");

        if (flagText != null && flagText.equals("allComment")) {
            String page = request.getParameter("page");
            String rows = request.getParameter("rows");

            pagination.setCurPage(Long.valueOf(page));
            pagination.setPageSize(Long.valueOf(rows));

            List<AllEntity> comments = null;
            long total = 0;

            try {
                comments = commentDao.allCommentList(pagination);
                total = commentDao.allCommentCount();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            map.put("rows", comments);
            map.put("total", total);

        } else if (flagText != null && flagText.equals("delete")) {
            String delIds = request.getParameter("delIds");

            List<String> comment_ids = Arrays.asList(delIds.split(","));
            int delNums = 0;
            try {
                for(int i = 0;i<comment_ids.size();i++) {
                    int code = 0;
                    Comment comment = new Comment();
                    comment.setComment_id(Integer.parseInt(comment_ids.get(i)));
                    code = commentDao.delComment(comment);
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
