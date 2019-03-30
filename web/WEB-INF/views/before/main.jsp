<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.jws.soap.SOAPBinding" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.ethan.dao.impl.ResourceDaoImpl" %>
<%@ page import="com.ethan.entity.*" %>
<%@ page import="com.ethan.dao.impl.PostDaoImpl" %>
<%@ page import="com.ethan.dao.impl.CommentDaoImpl" %>
<%@ page import="java.sql.SQLException" %><%--
  Created by IntelliJ IDEA.
  User: Ethan
  Date: 2018/12/28
  Time: 12:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    request.setCharacterEncoding("utf-8");
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<%
    ResourceDaoImpl resourceDao = new ResourceDaoImpl();
    PostDaoImpl postDao = new PostDaoImpl();
    CommentDaoImpl commentDao = new CommentDaoImpl();
    Pagination pagination = new Pagination();

    List<AllEntity> resources = new ArrayList<>();
    List<AllEntity> posts = new ArrayList<>();
    List<AllEntity> comments = new ArrayList<>();

    AllEntity allEntity = new AllEntity();
    Post post = new Post();
%>
<%

    pagination.setCurPage(Long.valueOf("1"));
    pagination.setPageSize(8);

    try {
        resources = resourceDao.allResource(allEntity,pagination);
        posts = postDao.allPost(allEntity,pagination);
        comments = commentDao.allComment(post);
    } catch (SQLException e) {
        e.printStackTrace();
    }

    pageContext.setAttribute("heat_resources", resources);
    pageContext.setAttribute("heat_posts", posts);
    pageContext.setAttribute("new_comments", comments);
%>


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
                    <li title="首页" class="active"><a href="#">首页</a></li>
                    <li title="资源"><a href="resource">资源</a></li>
                    <li title="论坛"><a href="forum">论坛</a></li>
                    <li title="个人中心"><a href="user/main?uid=${currentUser.user_id}">个人中心</a></li>
                </ul>
            </div>
        </div>
    </nav>
</header>
<section class="panel panel-default container">


    <div class="row" style="margin: 5px">

        <div class="col-md-8">

            <div class="panel panel-default">

                <div class="panel-heading">
                    <h2><a href="resource" class="panel-info">推荐资源</a></h2>
                </div>
                <ul class="list-group">
                    <c:forEach var="heat_resource" items="${heat_resources }">

                        <a href="resource/resource_details?rid=${heat_resource.resource_id}"
                           title="${heat_resource.user_level}" class="list-group-item">
                            <h4 class="list-group-item-heading">${heat_resource.resource_name}
                                <c:choose>
                                    <c:when test="${heat_resource.user_level == '学生'}">
                                        <sup style="border-radius: 5px;font-size: 1px;background-color: #c7ddef;color: blue">学生</sup>
                                    </c:when>
                                    <c:otherwise>
                                        <sup style="border-radius: 5px;font-size: 1px;background-color: gray;color: yellow">教师</sup>
                                    </c:otherwise>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${heat_resource.resource_good == 1}">
                                        <sup style="border-radius: 5px;font-size: 1px;background-color: pink;color: red">优质</sup>
                                    </c:when>
                                </c:choose>
                            </h4>
                            <h6 class="text"
                                style="overflow: hidden;text-overflow: ellipsis">${heat_resource.resource_desc}</h6>
                            <span class="muted"><i class="glyphicon glyphicon-user"></i>${heat_resource.resource_uid}</span>
                            <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                            <span class="text">资源类别：${heat_resource.category_name}</span>
                            <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                            <span class="text">资源等级：${heat_resource.resource_level}</span>
                            <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                            <span class="muted"><i class="glyphicon glyphicon-time"></i><fmt:formatDate
                                    value="${heat_resource.resource_time}" pattern="yyyy-MM-dd"/></span>
                        </a>
                    </c:forEach>
                    <a href="resource" class="see-more list-group-item">查看更多...</a>
                </ul>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2><a href="forum" class="panel-info">热门帖子</a></h2>
                </div>
                <ul class="list-group">
                    <c:forEach var="heat_post" items="${heat_posts }">
                        <a href="post/post_details?pid=${heat_post.post_id}" title="${heat_post.post_title}"
                           class="list-group-item">
                            <h4 class="list-group-item-heading">${heat_post.post_title}
                                <c:choose>
                                    <c:when test="${heat_post.user_level == '学生'}">
                                        <sup style="border-radius: 5px;font-size: 1px;background-color: #c7ddef;color: blue">学生</sup>
                                    </c:when>
                                    <c:otherwise>
                                        <sup style="border-radius: 5px;font-size: 1px;background-color: gray;color: yellow">教师</sup>
                                    </c:otherwise>
                                </c:choose>
                            </h4>
                            <h6 class="text" style="overflow: hidden;text-overflow: ellipsis">${heat_post.post_text}</h6>
                            <span class="muted"><i
                                    class="glyphicon glyphicon-user"></i>${heat_post.post_uid}</span>
                            <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                            <span class="muted"><i class="glyphicon glyphicon-time"></i><fmt:formatDate
                                    value="${heat_post.post_time}" pattern="yyyy-MM-dd"/></span>
                        </a>
                    </c:forEach>
                    <a href="forum" class="see-more list-group-item">查看更多...</a>
                </ul>
            </div>

        </div>


        <aside class="sidebar col-md-4">
            <div class="fixed">
                <div class="widget widget_search">
                    <form class="navbar-form" action="find_user" method="get">
                        <div class="input-group">
                            <input type="text" name="keyword" class="form-control" size="35" placeholder="请输入关键字"
                                   maxlength="15" required
                                   autocomplete="off">
                            <span class="input-group-btn">
									<button class="btn btn-default btn-search" id="search" type="submit">搜索</button>
								</span>
                        </div>
                    </form>
                </div>
            </div>

            <div class="widget widget_hot">
                <h3>最新评论</h3>
                <ul>
                    <c:forEach var="new_comment" items="${new_comments }">
                        <li style="display:block">
                            <a class="list-group-item" title="${new_comment.post_title}" href="post/post_details?pid=${new_comment.comment_pid}">
                                <h5 class="list-group-item-heading">${new_comment.post_title}</h5>
                                <span class="text" style="overflow: hidden;text-overflow: ellipsis">${new_comment.comment_text}</span>
                                <span><p></p></span>
                                    <%--<span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>--%>
                                <span class="muted"><i
                                        class="glyphicon glyphicon-user"></i>${new_comment.comment_uid}</span>
                                <span>&nbsp &nbsp</span>
                                <span class="muted"><i
                                        class="glyphicon glyphicon-time"></i><fmt:formatDate value="${new_comment.comment_time}"
                                                                                             pattern="yyyy-MM-dd"/></span>
                            </a>
                        </li>
                    </c:forEach>
                    <a href="forum" class="see-more list-group-item">查看更多...</a>
                </ul>
            </div>
        </aside>
    </div>
</section>


<!-- jQuery (Bootstrap 的 JavaScript 插件需要引入 jQuery) -->
<script src="${pageContext.request.contextPath}/resources/jquery/jquery-3.2.1.min.js"></script>
<!-- 包括所有已编译的插件 -->
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
