<%@ page import="com.ethan.entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.jws.soap.SOAPBinding" %>
<%@ page import="com.ethan.entity.Student" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.ethan.utils.DateUtil" %>
<%@ page import="com.ethan.entity.Teacher" %>
<%@ page import="com.ethan.entity.AllEntity" %>
<%@ page import="com.ethan.utils.StringUtil" %>
<%@ page import="com.ethan.dao.impl.UserDaoImpl" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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

%>
<%
    String flag = request.getParameter("flag");
    if (StringUtil.isNotEmpty(flag) && flag.equals("update")) {

        String uid = request.getParameter("uid");

        if (StringUtil.isEmpty(uid)) {
            response.sendRedirect(basePath + "user/login");
        } else {

            String user_password_old = request.getParameter("user_password_old");
            String user_password_new = request.getParameter("user_password_new");
            String user_password_confirm = request.getParameter("user_password_confirm");


            if (user_password_confirm.equals(user_password_new)) {

                User user = new User(uid,user_password_old,null);

                int code = 0;

                try {
                    code = userDao.updatePassword(user,user_password_new);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                if (code>0) {
                    request.setAttribute("isSuccess",true);
                } else {
                    request.setAttribute("isSuccess",false);
                }
            } else {
                request.setAttribute("error", "新密码不一致！");
                request.setAttribute("isSuccess", false);
            }
        }
    }
%>


<html>
<head>
    <title>校园资源共享平台</title>
    <base href="<%=basePath%>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 引入 Bootstrap -->
    <link href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
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
                            <li title="个人中心"><a href="user/main?uid=${currentUser.user_id}"><span class="glyphicon glyphicon-user"></span>${currentUser.user_id}</a>
                            </li>
                            <li title="退出"><a href="exit"><span class="glyphicon glyphicon-log-in"></span>退出</a></li>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <ul class="nav navbar-nav navbar-right">
                            <li title="注册"><a href="user/register"><span class="glyphicon glyphicon-user"></span> 注册</a></li>
                            <li title="登录"><a href="user/login"><span class="glyphicon glyphicon-log-in"></span> 登录</a></li>
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
                    <a class="list-group-item active" title="修改密码" href="user/update_pwd?uid=${currentUser.user_id}">修改密码</a>
                </li>
                <li style="display:block">
                    <a class="list-group-item" title="我的资源" href="user/user_resource?uid=${currentUser.user_id}">我的资源</a>
                </li>
                <li style="display:block">
                    <a class="list-group-item" title="我的帖子" href="user/user_post?uid=${currentUser.user_id}">我的帖子</a>
                </li>
                <li style="display:block">
                    <a class="list-group-item" title="我的关注" href="user/user_follow?uid=${currentUser.user_id}">我的关注</a>
                </li>
                <li style="display:block">
                    <a class="list-group-item" title="我的收藏" href="user/user_collect?uid=${currentUser.user_id}">我的收藏</a>
                </li>
            </ul>
        </div>

        <div class="col-md-10">

            <div>
                <h3>修改密码</h3>
            </div>

            <div class="panel panel-default ">
                <div class="container">
                    <div style="margin: 20px">

                        <form class="col-md-9 form-horizontal" role="form" action="user/update_pwd" method="post">
                            <c:choose>
                                <c:when test="${not empty isSuccess and isSuccess==true}">
                                    <div class="alert alert-dismissable alert-success">
                                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×
                                        </button>
                                        <h4>
                                            提示!
                                        </h4> <strong>修改成功!请重新登录！</strong>
                                    </div>
                                </c:when>
                                <c:when test="${not empty isSuccess and isSuccess==false}">
                                    <div class="alert alert-dismissable alert-danger">
                                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×
                                        </button>
                                        <h4>
                                            提示!
                                        </h4> <strong>修改失败!${error}</strong>
                                    </div>
                                </c:when>
                            </c:choose>
                            <input type="text" hidden name="flag" value="update"/>
                            <input type="text" hidden name="uid" value="${currentUser.user_id}"/>
                            <div class="form-group">
                                <label for="user_password_old" class="col-sm-2 control-label">旧密码</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" name="user_password_old" id="user_password_old" required/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="user_password_new" class="col-sm-2 control-label">新密码</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" name="user_password_new" id="user_password_new" required/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="user_password_confirm" class="col-sm-2 control-label">确认密码</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" name="user_password_confirm" id="user_password_confirm" required/>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-10">
                                    <button type="submit" class="btn btn-default">保存</button>
                                    <button type="reset" class="btn btn-danger">重置</button>
                                </div>
                            </div>
                        </form>
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

</body>
</html>