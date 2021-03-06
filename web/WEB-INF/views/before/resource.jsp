<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.jws.soap.SOAPBinding" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.ethan.utils.DateUtil" %>
<%@ page import="com.ethan.entity.*" %>
<%@ page import="com.ethan.utils.StringUtil" %>
<%@ page import="com.ethan.dao.impl.ResourceDaoImpl" %>
<%@ page import="java.sql.SQLException" %>
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
    ResourceDaoImpl resourceDao = new ResourceDaoImpl();
    CategoryDaoImpl categoryDao = new CategoryDaoImpl();
    List<AllEntity> allEntities = new ArrayList<>();
    List<Category> categories = new ArrayList<>();
    Pagination pagination = new Pagination();
    AllEntity allEntity = new AllEntity();

%>
<%

    String resource_name = request.getParameter("resource_name");
    String resource_cid = request.getParameter("resource_cid");
    String type = request.getParameter("type");
    String curPage = request.getParameter("page");

    if (StringUtil.isEmpty(curPage)) {
        curPage = "1";
    }
    if (StringUtil.isEmpty(resource_cid)) {
        resource_cid = "-1";
    }

    allEntity.setResource_name(resource_name);

    allEntity.setResource_cid(Integer.parseInt(resource_cid));
    allEntity.setUser_level(type);
    pagination.setCurPage(Long.valueOf(curPage));
    pagination.setPageSize(8);

    try {
        pagination.setItems(resourceDao.resourceCount(allEntity));
        long a = pagination.getItems() % pagination.getPageSize();
        long b = pagination.getItems() / pagination.getPageSize();
        if (a == 0) {
            pagination.setPageNumber(b);
        } else {
            pagination.setPageNumber(b+1);
        }
        categories = categoryDao.allCategory(null);
        allEntities = resourceDao.allResource(allEntity,pagination);


    } catch (SQLException e) {
        e.printStackTrace();
    }



    pageContext.setAttribute("categories", categories);
    pageContext.setAttribute("resource_name", resource_name);
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
                    <li title="资源" class="active"><a href="resource">资源</a></li>
                    <li title="论坛"><a href="forum">论坛</a></li>
                    <li title="个人中心"><a href="user/main?uid=${currentUser.user_id}">个人中心</a></li>
                </ul>
            </div>
        </div>
    </nav>
</header>
<section class="panel panel-default container">
    <div class="row">

        <div class="col-md-3">
            <ul class="clearfix">
                <h3>资源中心</h3>
                <li style="display:block">
                    <a class="list-group-item active" title="全部资源" href="resource">全部资源</a>
                </li>
                <li style="display:block">
                    <a class="list-group-item" title="上传资源" href="user/upload?uid=${currentUser.user_id}">上传资源</a>
                </li>
            </ul>
        </div>

        <div class="col-md-9">

            <div>
                <h3>全部资源</h3>
            </div>

            <div class="panel panel-default">
                <div class="container-fluid ">
                    <div style="margin: 20px">

                        <form class=" form-inline" action="resource" method="GET" id="form-search">
                            <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                            <input type="hidden" name="page" id="page"
                                   value="${empty pagination.curPage ? 1 : pagination.curPage }">
                            <input type="text" class="form-control" placeholder="关键词" name="resource_name"
                                   id="resource_name" value="${resource_name}">
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

                        <div class="panel panel-default">
                            <ul class="list-group">
                                <c:forEach var="all_resource" items="${allEntities }">
                                    <a href="resource/resource_details?rid=${all_resource.resource_id}"
                                       title="${all_resource.resource_name}" class="list-group-item">
                                        <h4 class="list-group-item-heading">${all_resource.resource_name}
                                            <c:choose>
                                                <c:when test="${all_resource.user_level == '学生'}">
                                                    <sup style="border-radius: 5px;font-size: 1px;background-color: #c7ddef;color: blue">学生</sup>
                                                </c:when>
                                                <c:otherwise>
                                                    <sup style="border-radius: 5px;font-size: 1px;background-color: gray;color: yellow">教师</sup>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:choose>
                                                <c:when test="${all_resource.resource_good == 1}">
                                                    <sup style="border-radius: 5px;font-size: 1px;background-color: pink;color: red">优质</sup>
                                                </c:when>
                                            </c:choose>
                                        </h4>

                                        <h6 style="overflow: hidden;text-overflow: ellipsis;"
                                            class="text">${all_resource.resource_desc}</h6>
                                        <span class="muted"><i
                                                class="glyphicon glyphicon-user"></i>${all_resource.user_id}</span>
                                        <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                                        <span class="text">资源类别：${all_resource.category_name}</span>
                                        <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                                        <span class="text">资源等级：${all_resource.resource_level}</span>
                                        <span>&nbsp &nbsp &nbsp &nbsp &nbsp </span>
                                        <span class="muted"><i class="glyphicon glyphicon-time"></i><fmt:formatDate
                                                value="${all_resource.resource_time}" pattern="yyyy-MM-dd"/></span>
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
        $("#resource_name").val("${resource_name}");
        $("#resource_cid").val("${resource_cid}");
        $("#type").val("${type}");
    });

    function pageClick(page) {
        console.log(page);
        $("#page").val(page);
        $("#resource_name").val('${resource_name}');
        $("#resource_cid").val('${resource_cid}');
        $("#type").val('${type}');
        $("#form-search").submit();
    }

</script>
</body>
</html>
