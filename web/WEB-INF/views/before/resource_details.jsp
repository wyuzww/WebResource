<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.jws.soap.SOAPBinding" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.ethan.utils.DateUtil" %>
<%@ page import="com.ethan.entity.*" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="com.ethan.utils.StringUtil" %>
<%@ page import="com.ethan.dao.impl.ResourceDaoImpl" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.ethan.dao.impl.CommentDaoImpl" %>
<%@ page import="com.ethan.dao.impl.CollectDaoImpl" %>

<%--
  Created by IntelliJ IDEA.
  User: Ethan
  Date: 2018/12/28
  Time: 12:43
  To change this template use File | Settings | File Templates.
--%>
<%
    request.setCharacterEncoding("utf-8");
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<%
    ResourceDaoImpl resourceDao = new ResourceDaoImpl();
    CollectDaoImpl collectDao = new CollectDaoImpl();
    Pagination pagination = new Pagination();
    AllEntity allEntity = new AllEntity();
    List<String> images = new ArrayList<>();
%>
<%

    String rid = request.getParameter("rid");
    String flag = request.getParameter("flag");
    if (StringUtil.isNotEmpty(flag) && flag.equals("collect")) {
        String uid = request.getParameter("uid");
        if (StringUtil.isEmpty(uid)) {
            response.sendRedirect(basePath + "user/login");
        } else {
            Collect collect = new Collect(uid,Integer.parseInt(rid));
            int code = 0;

            try {
                code = collectDao.addCollect(collect);
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (code>0) {
                request.setAttribute("isSuccess",true);
            } else {
                request.setAttribute("isSuccess",false);
            }
        }


    }

    allEntity.setResource_id(Integer.parseInt(rid));
    try {
        allEntity = resourceDao.allResource(allEntity,pagination).get(0);
    } catch (SQLException e) {
        e.printStackTrace();
    }

    if (StringUtil.isNotEmpty(allEntity.getResource_image())) {
        images = Arrays.asList(allEntity.getResource_image().split(","));
    }



    pageContext.setAttribute("images", images);
    pageContext.setAttribute("resource", allEntity);


%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <title>校园资源共享平台</title>
    <base href="<%=basePath%>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 引入 Bootstrap -->
    <link href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">

</head>


<body>
<header>
    <nav class="navbar navbar-default " role="navigation">
        <div class="navbar container-fluid navbar-default  navbar-fixed-top">
            <div class="navbar-header">
                <h4 class="logo navbar-text "><a href="#" title="校园资源共享平台">校园资源共享平台</a></h4>
            </div>

            <div id="login-info">
                <c:choose>
                    <c:when test="${not empty sessionScope.get('currentUser')}">
                        <ul class="nav navbar-nav navbar-right">
                            <li title="个人中心"><a href="user/main?uid=${currentUser.user_id}"><span
                                    class="glyphicon glyphicon-user"></span>${currentUser.user_id}</a>
                            </li>
                            <li title="退出"><a href="exit"><span class="glyphicon glyphicon-log-in"></span>退出</a></li>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <ul class="nav navbar-nav navbar-right">
                            <li title="注册"><a href="user/register"><span class="glyphicon glyphicon-user"></span> 注册</a>
                            </li>
                            <li title="登录"><a href="user/login"><span class="glyphicon glyphicon-log-in"></span> 登录</a>
                            </li>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>


            <div class="navbar-collapse collapse" style="text-align: center">
                <ul class="nav navbar-nav nav-pills" style="display: inline-block;float: none">
                    <li title="首页"><a href="#">首页</a></li>
                    <li title="资源" class="active"><a href="resource">资源</a></li>
                    <li title="论坛" ><a href="forum">论坛</a></li>
                    <li title="个人中心"><a href="user/main?uid=${currentUser.user_id}">个人中心</a></li>
                </ul>
            </div>
        </div>
    </nav>
</header>
<section class="container">
    <%--panel panel-default--%>
    <div class="row">

        <div class="col-md-1"></div>

        <div class="col-md-10">
            <div>
                <ul class="breadcrumb">
                    <li>
                        <a href="resource">资源</a>
                    </li>
                    <li class="active">
                        ${resource.resource_name}
                    </li>
                </ul>
            </div>

            <div class="panel panel-default">
                <c:choose>
                    <c:when test="${not empty isSuccess and isSuccess==true}">
                        <div class="alert alert-dismissable alert-success">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×
                            </button>
                            <h4>
                                提示!
                            </h4> <strong>收藏成功!</strong>
                        </div>
                    </c:when>
                    <c:when test="${not empty isSuccess and isSuccess==false}">
                        <div class="alert alert-dismissable alert-danger">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×
                            </button>
                            <h4>
                                提示!
                            </h4> <strong>已经收藏过了!</strong>
                        </div>
                    </c:when>
                </c:choose>

                <ul class="list-group">
                    <li style="display:block" class="list-group-item">
                        <h3>${resource.resource_name}
                            <c:choose>
                                <c:when test="${resource.user_level=='学生'}">
                                    <sup style="border-radius: 5px;font-size: 15px;background-color: #c7ddef;color: blue">学生</sup>
                                </c:when>
                                <c:otherwise>
                                    <sup style="border-radius: 5px;font-size: 15px;background-color: gray;color: yellow">教师</sup>
                                </c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${resource.resource_good == 1}">
                                    <sup style="border-radius: 5px;font-size: 15px;background-color: pink;color: red">优质</sup>
                                </c:when>
                            </c:choose>
                            <span><a style="margin-right: 10px" title="收藏资源"
                                     href="resource/resource_details?flag=collect&uid=${currentUser.user_id}&rid=${resource.resource_id}"
                                     class="btn btn-danger btn-sm navbar-right">收藏资源</a></span>
                        </h3>

                    </li>
                    <li style="display:block" class="list-group-item">
                        <h4>${resource.resource_desc}</h4>

                        <c:forEach var="image" items="${images }">
                            <img style="width: 70%;height: auto" src="${image}">
                        </c:forEach>

                    </li>
                    <li style="display:block" class="list-group-item">

                        <div align="right">
                            <span><a class="btn btn-info btn-sm navbar-left"
                                     href="${resource.resource_url}">下载资源</a></span>
                            <span class="text">资源类别：${resource.category_name}</span>
                            <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                            <span class="text">资源等级：${resource.resource_level}</span>
                            <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                            <span class="muted "><i class="glyphicon glyphicon-user"></i>${resource.resource_uid}</span>
                            <span><a title="查看作者" href="user_info?user_id=${resource.resource_uid}" class="btn btn-success btn-sm">查看作者</a></span>
                            <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                            <span class="muted"><i class="glyphicon glyphicon-time "></i><fmt:formatDate
                                    value="${resource.resource_time}" pattern="yyyy-MM-dd"/></span>
                            <span>&nbsp &nbsp </span>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    </div>
</section>


<!-- jQuery (Bootstrap 的 JavaScript 插件需要引入 jQuery) -->
<script src="${pageContext.request.contextPath}/resources/jquery/jquery-3.2.1.min.js"></script>
<!-- 包括所有已编译的插件 -->
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js"></script>

</body>
</html>
