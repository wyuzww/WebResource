<%@ page import="com.ethan.entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.jws.soap.SOAPBinding" %>
<%@ page import="com.ethan.dao.impl.ResourceDaoImpl" %>
<%@ page import="com.ethan.dao.impl.RegisterDaoImpl" %>
<%@ page import="com.ethan.entity.Register" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.ethan.utils.StringUtil" %>
<%@ page import="com.ethan.dao.impl.UserDaoImpl" %><%--
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
    RegisterDaoImpl registerDao = new RegisterDaoImpl();
%>
<%

    String flagText = request.getParameter("flagText");

    if (StringUtil.isNotEmpty(flagText) && flagText.equals("register")) {
        String uid = request.getParameter("user_id");
        String user_password = request.getParameter("user_password");
        String user_password_confirm = request.getParameter("user_password_confirm");
        String user_level = request.getParameter("user_level");
        String student_class = request.getParameter("student_class");
        Register register = new Register(uid, user_password, null, student_class, user_level, 0);

        if (user_password.equals(user_password_confirm)) {
            int code = 0;
            User user = new User();
            user.setUser_id(uid);

            try {
                if (registerDao.checkUser(user)) {
                    request.setAttribute("error", "帐号已存在！");
                    request.setAttribute("isSuccess", false);
                    pageContext.setAttribute("user_id",uid);
                    pageContext.setAttribute("user_password",user_password);
                    pageContext.setAttribute("user_password_confirm",user_password_confirm);
                    pageContext.setAttribute("user_level",user_level);
                    pageContext.setAttribute("student_class",student_class);
                } else {
                    code = registerDao.userRegister(register);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (code > 0) {
                request.setAttribute("isSuccess", true);
            } else {
                request.setAttribute("isSuccess", false);
            }
        } else {
            pageContext.setAttribute("user_id",uid);
            pageContext.setAttribute("user_password",user_password);
            pageContext.setAttribute("user_password_confirm",user_password_confirm);
            pageContext.setAttribute("user_level",user_level);
            pageContext.setAttribute("student_class",student_class);
            request.setAttribute("error", "两次密码不一致！");
            request.setAttribute("isSuccess", false);
        }

    }

%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

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
                    <li title="个人中心"><a href="user/main?uid=${currentUser.user_id}">个人中心</a></li>
                </ul>
            </div>
        </div>
    </nav>
</header>
<section class=" container">
    <div class="panel panel-default" style="margin: 50px">
        <div class="row clearfix">
            <div class="col-md-12" style="text-align: center"><h2>用户注册</h2></div>
            <div class="col-md-12 column" style="margin: 20px">


                <div class="col-md-3"></div>

                <form class="col-md-9 form-horizontal" role="form" action="user/register" method="post">
                    <div class="form-group">
                        <c:choose>
                            <c:when test="${not empty isSuccess and isSuccess==true}">
                                <div class="alert alert-dismissable alert-success col-sm-7">
                                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×
                                    </button>
                                    <h4>
                                        提示!
                                    </h4> <strong>提交成功!等待管理员审核！</strong>
                                </div>
                            </c:when>
                            <c:when test="${not empty isSuccess and isSuccess==false}">
                                <div class="alert alert-dismissable alert-danger col-sm-7">
                                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×
                                    </button>
                                    <h4>
                                        提示!
                                    </h4> <strong>提交失败!${error}</strong>
                                </div>
                            </c:when>
                        </c:choose>
                    </div>
                    <input hidden name="flagText" value="register"/>
                    <div class="form-group">
                        <label for="user_id" class="col-sm-2 control-label">User</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" name="user_id" id="user_id" required value="${user_id}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="user_password" class="col-sm-2 control-label">Password</label>
                        <div class="col-sm-4">
                            <input type="password" class="form-control" name="user_password" id="user_password" value="${user_password}"
                                   required/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="user_password_confirm" class="col-sm-2 control-label">ConfirmPassword</label>
                        <div class="col-sm-4">
                            <input type="password" class="form-control" name="user_password_confirm" value="${user_password_confirm}"
                                   id="user_password_confirm" required/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="user_level" class="col-sm-2 control-label">UserLevel</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="user_level" id="user_level" required>
                                <option value="学生">学生</option>
                                <option value="教师">教师</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="student_class_form">
                        <label for="student_class" class="col-sm-2 control-label">StudentClass</label>
                        <div class="col-sm-4">
                            <input type="text" class="form-control" name="student_class" id="student_class" required value="${student_class}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-10">
                            <button type="submit" class="btn btn-default">注册</button>
                            <button type="reset" class="btn btn-danger">重置</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- jQuery (Bootstrap 的 JavaScript 插件需要引入 jQuery) -->
<script src="${pageContext.request.contextPath}/resources/jquery/jquery-3.2.1.min.js"></script>
<!-- 包括所有已编译的插件 -->
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js"></script>

<script>
    $(function () {
        if (${not empty user_level})  {
            $("#user_level").val('${user_level}');
        }

        if ($('#user_level').val() == "学生") {
            $('#student_class_form').show();
        } else {
            $('#student_class_form').hide();
            $('#student_class').attr("required", false);
        }
    });
    $("#user_level").change(function () {
        if ($('#user_level').val() == "学生") {
            $('#student_class_form').show();
        } else {
            $('#student_class_form').hide();
            $('#student_class').attr("required", false);
        }
    });

</script>


</body>
</html>
