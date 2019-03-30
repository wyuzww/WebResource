<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.jws.soap.SOAPBinding" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.ethan.utils.DateUtil" %>
<%@ page import="com.ethan.entity.*" %>
<%@ page import="com.ethan.utils.StringUtil" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="com.ethan.dao.impl.PostDaoImpl" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.ethan.dao.impl.CommentDaoImpl" %>

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
    PostDaoImpl postDao = new PostDaoImpl();
    CommentDaoImpl commentDao = new CommentDaoImpl();
    List<AllEntity> posts = new ArrayList<>();
    List<AllEntity> comments = new ArrayList<>();
    List<String> images = new ArrayList<>();
    Pagination pagination = new Pagination();
    AllEntity allEntity = new AllEntity();
    Post post = new Post();
%>
<%
    String flag = request.getParameter("flag");
    String pid = request.getParameter("pid");

    if (StringUtil.isNotEmpty(flag) && flag.equals("addComment")) {

        String uid = request.getParameter("uid");
        String comment_text = request.getParameter("comment_text");

        if (StringUtil.isEmpty(uid)) {
            response.sendRedirect(basePath + "user/login");
            return;
        }

        Comment comment = new Comment(0,Integer.parseInt(pid),uid,comment_text,new Date());

        int code = 0;
        try {
            code = commentDao.addComment(comment);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (code>0) {
            request.setAttribute("isSuccess",true);
        } else {
            request.setAttribute("isSuccess",false);
        }
    }

    allEntity.setPost_id(Integer.parseInt(pid));
    pagination.setCurPage(Long.valueOf("1"));
    pagination.setPageSize(1);
    post.setPost_id(Integer.parseInt(pid));

    try {
        posts = postDao.allPost(allEntity,pagination);
        comments = commentDao.allComment(post);
    } catch (SQLException e) {
        e.printStackTrace();
    }

    if (StringUtil.isNotEmpty(posts.get(0).getPost_image())) {
        images = Arrays.asList(posts.get(0).getPost_image().split(","));
    }




    pageContext.setAttribute("images",images);
    pageContext.setAttribute("comments", comments);
    pageContext.setAttribute("post", posts.get(0));

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
                    <li title="资源"><a href="resource">资源</a></li>
                    <li title="论坛" class="active"><a href="forum">论坛</a></li>
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
                        <a href="forum">论坛</a>
                    </li>
                    <li class="active">
                        ${post.post_title}
                    </li>
                </ul>
            </div>

            <c:choose>
                <c:when test="${not empty isSuccess and isSuccess==true}">
                    <div class="alert alert-dismissable alert-success">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×
                        </button>
                        <h4>
                            提示!
                        </h4> <strong>评论成功!</strong>
                    </div>
                </c:when>
                <c:when test="${not empty isSuccess and isSuccess==false}">
                    <div class="alert alert-dismissable alert-danger">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×
                        </button>
                        <h4>
                            提示!
                        </h4> <strong>评论失败!</strong>
                    </div>
                </c:when>
            </c:choose>

            <div class="panel panel-default">
                <ul class="list-group">
                    <li style="display:block" class="list-group-item">
                        <h3>${post.post_title}
                            <c:choose>
                                <c:when test="${post.user_level=='学生'}"><sup
                                        style="border-radius: 5px;font-size: 15px;background-color: #c7ddef;color: blue">学生</sup>
                                </c:when>
                                <c:otherwise>
                                    <sup
                                            style="border-radius: 5px;font-size: 15px;background-color: gray;color: yellow">教师</sup>
                                </c:otherwise>
                            </c:choose>
                        </h3>
                    </li>
                    <li style="display:block" class="list-group-item">
                        <h4>${post.post_text}</h4>
                        <c:forEach var="image" items="${images }">
                            <img style="width: 70%;height: auto" src="${image}">
                            <%--<img src="${pageContext.request.contextPath}/upload/images/IMG.jpg">--%>
                        </c:forEach>

                    </li>
                    <li style="display:block" class="list-group-item">
                        <div align="right">
                            <span class="muted "><i class="glyphicon glyphicon-user"></i>${post.post_uid}</span>
                            <span><a title="查看作者" href="user_info?user_id=${post.post_uid}" class="btn btn-success btn-sm">查看作者</a></span>
                            <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                            <span class="muted"><i class="glyphicon glyphicon-time "></i><fmt:formatDate
                                    value="${post.post_time}" pattern="yyyy-MM-dd"/></span>
                            <span>&nbsp &nbsp </span>
                        </div>
                    </li>
                </ul>
            </div>
            <div>
                <ul class="container-fluid">

                    <form class=" form-horizontal " role="form" action="post/post_details" method="post">

                        <input type="text" name="flag" hidden value="addComment"/>
                        <input type="text" name="uid" hidden value="${currentUser.user_id}"/>
                        <input type="text" name="pid" hidden value="${post.post_id}"/>
                        <div align="center" class="form-group">
                            <div>
                                <textarea required class="form-control" name="comment_text" id="comment_text" rows="3"
                                          style="resize: none;font-size: 20px" placeholder="在此处留下你的评论"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <div>
                                <button type="submit" style="margin-right: 10px" class="btn btn-info navbar-right"
                                        id="save_btn">提交评论
                                </button>
                            </div>
                        </div>
                    </form>
                </ul>
            </div>
            <div class="widget widget_hot">
                <h3>全部评论</h3>
                <ul>
                    <c:forEach var="comment" items="${comments }" varStatus="status">
                        <li style="display:block" class="row">
                            <h4 class="col-md-1">第${comments.size()+1-status.count}楼</h4>
                            <a class="list-group-item col-md-11" title="${comment.comment_text}">
                                <h5 class="list-group-item-heading">${comment.comment_text}</h5>
                                <span><p></p></span>
                                <span class="muted"><i
                                        class="glyphicon glyphicon-user"></i>${comment.comment_uid}</span>
                                <span>&nbsp &nbsp</span>
                                <span class="muted"><i
                                        class="glyphicon glyphicon-time"></i><fmt:formatDate value="${comment.comment_time}"
                                                                                             pattern="yyyy-MM-dd"/></span>
                            </a>
                        </li>
                    </c:forEach>
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
