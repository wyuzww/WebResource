package com.ethan.controller.resource;

import com.alibaba.fastjson.JSON;
import com.ethan.dao.impl.RegisterDaoImpl;
import com.ethan.dao.impl.ResourceDaoImpl;
import com.ethan.dao.impl.UserDaoImpl;
import com.ethan.entity.*;
import com.ethan.utils.ResponseUtil;
import com.ethan.utils.StringUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/Resource")
public class ResourceServlet extends HttpServlet {
    ResourceDaoImpl resourceDao = new ResourceDaoImpl();
    Map<String, Object> map = new HashMap<String, Object>();
    Pagination pagination = new Pagination();
    String result = null;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");
        // 接收客户端信息

        String flagText = request.getParameter("flagText");

        if (flagText != null && flagText.equals("allResource")) {
            String page = request.getParameter("page");
            String rows = request.getParameter("rows");
            String resource_name = request.getParameter("resource_name");
            String resource_cid = request.getParameter("resource_cid");
            String user_level = request.getParameter("user_level");

            if (StringUtil.isEmpty(resource_cid)) {
                resource_cid = "-1";
            }

            AllEntity allEntity = new AllEntity();
            pagination.setCurPage(Long.valueOf(page));
            pagination.setPageSize(Long.valueOf(rows));

            allEntity.setResource_name(resource_name);
            allEntity.setResource_cid(Integer.parseInt(resource_cid));
            allEntity.setUser_level(user_level);

            List<AllEntity> resources = null;
            long total = 0;

            try {
                resources = resourceDao.allResource(allEntity,pagination);
                total = resourceDao.resourceCount(allEntity);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            map.put("rows", resources);
            map.put("total", total);

        } else if (flagText != null && flagText.equals("delete")) {
            String delIds = request.getParameter("delIds");

            List<String> resource_ids = Arrays.asList(delIds.split(","));
            int delNums = 0;

            try {
                for(int i = 0;i<resource_ids.size();i++) {
                    int code = 0;
                    Resource resource = new Resource();
                    resource.setResource_id(Integer.parseInt(resource_ids.get(i)));
                    code = resourceDao.delResource(resource);
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


        } else if (flagText != null && flagText.equals("update")) {
            String delIds = request.getParameter("delIds");

            List<String> resource_ids = Arrays.asList(delIds.split(","));
            int delNums = 0;

            try {
                for(int i = 0;i<resource_ids.size();i++) {
                    int code = 0;
                    Resource resource = new Resource();
                    resource.setResource_id(Integer.parseInt(resource_ids.get(i)));
                    code = resourceDao.setGoodResource(resource,1);
                    if (code>0) {
                        delNums++;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (delNums> 0) {
                map.put("delNums", delNums);
                map.put("success", "true");
                map.put("msg", "标优成功！");
            } else {
                map.put("success", "false");
                map.put("msg", "标优失败，请重试！");
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
