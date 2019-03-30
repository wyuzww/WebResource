<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.jws.soap.SOAPBinding" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.ethan.utils.DateUtil" %>
<%@ page import="com.ethan.entity.*" %>
<%@ page import="com.ethan.utils.StringUtil" %>
<%@ page import="com.ethan.dao.impl.CollectDaoImpl" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.ethan.dao.impl.ResourceDaoImpl" %>
<%@ page import="com.ethan.dao.impl.CategoryDaoImpl" %>

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
    CollectDaoImpl collectDao = new CollectDaoImpl();
    ResourceDaoImpl resourceDao = new ResourceDaoImpl();
    CategoryDaoImpl categoryDao = new CategoryDaoImpl();
    List<AllEntity> allEntities = new ArrayList<>();
    List<Category> categories = new ArrayList<>();
    Pagination pagination = new Pagination();
    AllEntity allEntity = new AllEntity();
%>
<%
    String query = request.getParameter("query");
    String resource_cid = request.getParameter("resource_cid");
    String type = request.getParameter("type");
    String curPage = request.getParameter("page");
    String flag  = request.getParameter("flag");
    String uid  = request.getParameter("uid");

        System.out.println(uid);

    if (StringUtil.isEmpty(curPage)) {
        curPage = "1";
    }

    if (StringUtil.isNotEmpty(flag) && flag.equals("delete")) {

        String rid  = request.getParameter("rid");
        Collect collect = new Collect(uid,Integer.parseInt(rid));

        int code = 0;

        try {
            code = collectDao.delCollect(collect);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (code>0) {
            request.setAttribute("isSuccess",true);
        } else {
            request.setAttribute("isSuccess",false);
        }
    }

    if (StringUtil.isEmpty(resource_cid)) {
        resource_cid = "-1";
    }

    allEntity.setCollect_uid(uid);
    allEntity.setResource_name(query);
    allEntity.setResource_cid(Integer.parseInt(resource_cid));
    allEntity.setUser_level(type);
    pagination.setCurPage(Long.valueOf(curPage));
    pagination.setPageSize(8);

    try {
        pagination.setItems(resourceDao.collectByIDCount(allEntity));
        long a = pagination.getItems() % pagination.getPageSize();
        long b = pagination.getItems() / pagination.getPageSize();
        if (a == 0) {
            pagination.setPageNumber(b);
        } else {
            pagination.setPageNumber(b+1);
        }
        categories = categoryDao.allCategory(null);
        allEntities = resourceDao.allCollectByUserID(allEntity,pagination);


    } catch (SQLException e) {
        e.printStackTrace();
    }


    pageContext.setAttribute("categories", categories);
    pageContext.setAttribute("query", query);
    pageContext.setAttribute("resource_cid", resource_cid);
    pageContext.setAttribute("type", type);
    pageContext.setAttribute("allEntities", allEntities);
    pageContext.setAttribute("pagination", pagination);

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
                    <li title="论坛"><a href="forum">论坛</a></li>
                    <li title="个人中心" class="active"><a href="user/main?uid=${currentUser.user_id}">个人中心</a></li>
                </ul>
            </div>
        </div>
    </nav>
</header>
<section class="panel panel-default container">
    <div class="row">

        <div class="col-md-2">
            <ul class="clearfix">
                <h3>个人中心</h3>
                <li style="display:block">
                    <a class="list-group-item" title="我的信息" href="user/main?uid=${currentUser.user_id}">我的信息</a>
                </li>
                <li style="display:block">
                    <a class="list-group-item " title="修改密码" href="user/update_pwd?uid=${currentUser.user_id}">修改密码</a>
                </li>
                <li style="display:block">
                    <a class="list-group-item" title="我的资源"
                       href="user/user_resource?uid=${currentUser.user_id}">我的资源</a>
                </li>
                <li style="display:block">
                    <a class="list-group-item" title="我的帖子" href="user/user_post?uid=${currentUser.user_id}">我的帖子</a>
                </li>
                <li style="display:block">
                    <a class="list-group-item " title="我的关注" href="user/user_follow?uid=${currentUser.user_id}">我的关注</a>
                </li>
                <li style="display:block">
                    <a class="list-group-item active " title="我的收藏" href="user/user_collect?uid=${currentUser.user_id}">我的收藏</a>
                </li>
            </ul>
        </div>

        <div class="col-md-10">

            <div>
                <h3>我的收藏</h3>
            </div>

            <div class="panel panel-default ">
                <div class="container-fluid">
                    <div style="margin: 20px">
                        <form class=" form-inline" action="user/user_collect?uid=${currentUser.user_id}" method="GET"
                              id="form-search">
                            <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                            <input type="hidden" name="uid" id="uid"
                                   value="${currentUser.user_id}">
                            <input type="hidden" name="page" id="page"
                                   value="${empty pagination.curPage ? 1 : pagination.curPage }">
                            <input type="text" class="form-control" placeholder="关键词" name="query" id="query"
                                   value="${query}">
                            <span>&nbsp &nbsp </span>
                            <label class="form-inline">资源类别</label>
                            <select id="resource_cid" class="form-control" name="resource_cid">
                                <option value="-1">全部</option>
                                <c:forEach var="category_i" items="${categories}">
                                    <option value="${category_i.category_id}">${category_i.category_name}</option>
                                </c:forEach>
                            </select>
                            <span>&nbsp &nbsp </span>
                            <label class="form-inline">用户类别</label>
                            <select id="type" class="form-control " name="type">
                                <option value="">全部</option>
                                <option value="学生">学生</option>
                                <option value="教师">教师</option>
                            </select>
                            <span> &nbsp </span>
                            <a id="search_btn" class="btn btn-info">搜索</a>
                        </form>

                        <c:choose>
                            <c:when test="${not empty isSuccess and isSuccess==true}">
                                <div class="alert alert-dismissable alert-success">
                                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×
                                    </button>
                                    <h4>
                                        提示!
                                    </h4> <strong>取消收藏成功!</strong>
                                </div>
                            </c:when>
                            <c:when test="${not empty isSuccess and isSuccess==false}">
                                <div class="alert alert-dismissable alert-danger">
                                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×
                                    </button>
                                    <h4>
                                        提示!
                                    </h4> <strong>取消收藏失败!</strong>
                                </div>
                            </c:when>
                        </c:choose>

                        <div class="panel panel-default">
                            <ul class="list-group">
                                <c:forEach var="user_collect" items="${allEntities }">
                                    <a href="resource/resource_details?rid=${user_collect.resource_id}" title="${user_collect.resource_name}" class="list-group-item">
                                        <h4 class="list-group-item-heading">${user_collect.resource_name}
                                            <c:choose>
                                                <c:when test="${user_collect.user_level == '学生'}">
                                                    <sup style="border-radius: 5px;font-size: 1px;background-color: #c7ddef;color: blue">学生</sup>
                                                </c:when>
                                                <c:otherwise>
                                                    <sup style="border-radius: 5px;font-size: 1px;background-color: gray;color: yellow">教师</sup>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:choose>
                                                <c:when test="${user_collect.resource_good == 1}">
                                                    <sup style="border-radius: 5px;font-size: 1px;background-color: pink;color: red">优质</sup>
                                                </c:when>
                                            </c:choose>
                                            <div class="navbar-right" style="margin-right: 10px">
                                                <button title="取消收藏" class="btn btn-danger btn-sm" onclick="window.location='user/user_collect?flag=delete&uid=${currentUser.user_id}&rid=${user_collect.resource_id}';return false" >取消收藏
                                                </button>
                                            </div>
                                        </h4>
                                        <h6 class="text">${user_collect.resource_desc}</h6>
                                        <span class="muted"><i
                                                class="glyphicon glyphicon-user"></i>${user_collect.resource_uid}</span>
                                        <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                                        <span class="text">资源类别：${user_collect.category_name}</span>
                                        <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                                        <span class="text">资源等级：${user_collect.resource_level}</span>
                                        <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                                        <span class="muted"><i class="glyphicon glyphicon-time"></i><fmt:formatDate
                                                value="${user_collect.resource_time}" pattern="yyyy-MM-dd"/></span>
                                    </a>
                                </c:forEach>
                            </ul>
                        </div>
                        <%@ include file="pagination.jsp" %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>


<!-- jQuery (Bootstrap 的 JavaScript 插件需要引入 jQuery) -->
<script src="${pageContext.request.contextPath}/resources/jquery/jquery-3.2.1.min.js"></script>
<!-- 包括所有已编译的插件 -->
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js"></script>

<script>

    $("#search_btn").click(function () {
        $("#form-search").submit();
    });

    $(function () {
        $("#query").val("${query}");
        $("#resource_cid").val("${resource_cid}");
        $("#type").val("${type}");
    });

    function pageClick(page) {
        console.log(page);

        $("#page").val(page);
        $("#query").val('${query}');
        $("#resource_cid").val('${resource_cid}');
        $("#type").val('${type}');
        $("#form-search").submit();
    }

</script>
</body>
</html>
