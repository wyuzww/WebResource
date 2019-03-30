<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.jws.soap.SOAPBinding" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.ethan.utils.DateUtil" %>
<%@ page import="com.ethan.entity.*" %>
<%@ page import="com.ethan.utils.StringUtil" %>
<%@ page import="com.ethan.dao.impl.PostDaoImpl" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.ethan.dao.impl.UserDaoImpl" %>

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
    UserDaoImpl userDao = new UserDaoImpl();
    List<AllEntity> allEntities = new ArrayList<>();
    Pagination pagination = new Pagination();
    User user = new User();

%>
<%
    String keyword = request.getParameter("keyword");
    String curPage = request.getParameter("page");


    if (StringUtil.isEmpty(curPage)) {
        curPage = "1";
    }

    user.setUser_id(keyword);
    pagination.setCurPage(Long.valueOf(curPage));
    pagination.setPageSize(8);

    try {
        pagination.setItems(userDao.findUserCount(user));
        long a = pagination.getItems() % pagination.getPageSize();
        long b = pagination.getItems() / pagination.getPageSize();
        if (a == 0) {
            pagination.setPageNumber(b);
        } else {
            pagination.setPageNumber(b + 1);
        }
        allEntities = userDao.findUser(user, pagination);
    } catch (SQLException e) {
        e.printStackTrace();
    }

    pageContext.setAttribute("keyword", keyword);
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
    <link href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap-datetimepicker.min.css"
          rel="stylesheet">
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
                    <li title="个人中心"><a href="user/main?uid=${currentUser.user_id}">个人中心</a></li>
                </ul>
            </div>
        </div>
    </nav>
</header>
<section class="panel panel-default container">
    <div>
        <ul class="breadcrumb">
            <li class="active">
                其他操作
            </li>
            <li>
                查找用户
            </li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-1"></div>

        <div class="col-md-10">

            <div class="panel panel-default ">
                <div class="container-fluid">
                    <div style="margin: 20px">
                        <form id="form-search" class="navbar-form" action="find_user" method="get" >
                            <input type="hidden" name="page" id="page"
                                   value="${empty pagination.curPage ? 1 : pagination.curPage }">
                            <div class="input-group">
                                <input id="keyword" type="text" name="keyword" class="form-control" size="35" placeholder="请输入关键字"
                                       maxlength="15" required value="${keyword}"
                                       autocomplete="off">
                                <span class="input-group-btn">
									<button class="btn btn-default btn-search" id="search_btn" type="submit">搜索</button>
								</span>
                            </div>
                        </form>
                        <div class="panel panel-default">
                            <ul class="list-group">
                                <c:forEach var="find_user" items="${allEntities }">
                                    <a href="user_info?user_id=${find_user.user_id}" title="${find_user.user_id}"
                                       class="list-group-item">
                                        <h4>${find_user.user_id}
                                            <c:choose>
                                                <c:when test="${find_user.user_level == '学生'}">
                                                    <sup style="border-radius: 5px;font-size: 1px;background-color: #c7ddef;color: blue">学生</sup>
                                                    <c:choose>
                                                        <c:when test="${find_user.student_desc == ''}">
                                                            <span style="margin-left: 30px;margin-right: 20px;font-size: small;text-align: center">这个人很懒！什么也没留下！</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="margin-left: 30px;margin-right: 20px;font-size: small;text-align: center">${find_user.student_desc}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <sup style="border-radius: 5px;font-size: 1px;background-color: gray;color: yellow">教师</sup>
                                                    <c:choose>
                                                        <c:when test="${find_user.teacher_desc == ''}">
                                                            <span style="margin-left: 30px;margin-right: 20px;font-size: small;text-align: center">这个人很懒！什么也没留下！</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="margin-left: 30px;margin-right: 20px;font-size: small;text-align: center">${find_user.teacher_desc}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </h4>
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
        $("#keyword").val("${keyword}");
    });

    function pageClick(page) {
        console.log(page);

        $("#page").val(page);
        $("#keyword").val('${keyword}');
        $("#form-search").submit();
    }

</script>
</body>
</html>
