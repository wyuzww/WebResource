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
    AllEntity allEntity = new AllEntity();
%>
<%
    String uid  =request.getParameter("uid");
    String flag = request.getParameter("flag");

    if (StringUtil.isNotEmpty(flag) && flag.equals("update")) {
        if (StringUtil.isEmpty(uid)) {
            response.sendRedirect(basePath + "user/login");
        } else {

            String name = request.getParameter("user_name");
            String sex = request.getParameter("user_sex");
            String classes = request.getParameter("user_class");
            String birth = request.getParameter("user_birth");
            String desc = request.getParameter("user_desc");
            String level = request.getParameter("user_level");

            if (level.equals("学生")){

                Student student = new Student(uid,name,sex,DateUtil.formatString(birth,"yyyy-MM-dd"),classes,desc);
                int code = 0;
                try {
                    code = userDao.updateStudent(student);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                if (code>0) {
                    request.setAttribute("isSuccess", true);
                } else {
                    request.setAttribute("isSuccess", false);
                }

            } else if (level.equals("教师")){
                Teacher teacher = new Teacher(uid,name,sex,DateUtil.formatString(birth,"yyyy-MM-dd"),desc);
                int code = 0;
                try {
                    code = userDao.updateTeacher(teacher);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                if (code>0) {
                    request.setAttribute("isSuccess", true);
                } else {
                    request.setAttribute("isSuccess", false);
                }
            } else {
                request.setAttribute("isSuccess", false);
            }
        }
    }
    User user = new User();
    user.setUser_id(uid);

    try {
        allEntity = userDao.getUser(user);
    } catch (SQLException e) {
        e.printStackTrace();
    }
    String user_id = "";
    String user_name = "";
    String user_sex = "";
    String user_class = "";
    Date user_birth = null;
    String user_desc = "";
    if (allEntity.getUser_level().equals("学生")){
        user_id = allEntity.getUser_id();
        user_name = allEntity.getStudent_name();
        user_sex = allEntity.getStudent_sex();
        user_class = allEntity.getStudent_class();
        user_birth = allEntity.getStudent_birth();
        user_desc = allEntity.getStudent_desc();
    } else if (allEntity.getUser_level().equals("教师")) {
        user_id = allEntity.getUser_id();
        user_name = allEntity.getTeacher_name();
        user_sex = allEntity.getTeacher_sex();
        user_birth = allEntity.getTeacher_birth();
        user_desc = allEntity.getTeacher_desc();
    } else {
        response.sendRedirect("error");
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
                    <li title="首页" ><a href="#">首页</a></li>
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
                    <a class="list-group-item active" title="我的信息" href="user/main?uid=${currentUser.user_id}">我的信息</a>
                </li>
                <li style="display:block">
                    <a class="list-group-item" title="修改密码" href="user/update_pwd?uid=${currentUser.user_id}">修改密码</a>
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
                <c:choose>
                    <c:when test="${currentUser.user_level == '学生'}">
                        <h3>我的信息<sup style="border-radius: 5px;font-size: 15px;background-color: #c7ddef;color: blue">${currentUser.user_level}</sup></h3>
                    </c:when>
                    <c:otherwise>
                        <h3>我的信息<sup style="border-radius: 5px;font-size: 15px;background-color: gray;color: yellow">${currentUser.user_level}</sup></h3>

                    </c:otherwise>
                </c:choose>
            </div>

            <div class="panel panel-default ">
                <div class="container">

                    <div style="margin: 20px">

                        <form id="form" class="col-md-9 form-horizontal" role="form" action="user/main?uid=${currentUser.user_id}" method="post">
                            <c:choose>
                                <c:when test="${not empty isSuccess and isSuccess==true}">
                                    <div class="alert alert-dismissable alert-success">
                                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×
                                        </button>
                                        <h4>
                                            提示!
                                        </h4> <strong>修改成功!</strong>
                                    </div>
                                </c:when>
                                <c:when test="${not empty isSuccess and isSuccess==false}">
                                    <div class="alert alert-dismissable alert-danger">
                                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×
                                        </button>
                                        <h4>
                                            提示!
                                        </h4> <strong>修改失败!</strong>
                                    </div>
                                </c:when>
                            </c:choose>
                            <input type="hidden" name="uid" id="uid"
                                   value="${currentUser.user_id}">
                            <input type="text" id="flag" hidden name="flag" value="update"/>
                            <input type="text" name="user_level" hidden value="${currentUser.user_level}"/>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">帐号</label>
                                <div class="col-sm-4">
                                    <input type="text" readonly class="form-control" name="user_id" id="user_id" value="<%=user_id%>"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">姓名</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" name="user_name" id="user_name" readonly value="<%=user_name%>"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">性别</label>
                                <div class="col-sm-4">
                                    <select  class="form-control" name="user_sex" id="user_sex" disabled  >
                                        <option value="男">男</option>
                                        <option value="女">女</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="user_class_div">
                                <label class="col-sm-2 control-label">班级</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" name="user_class" id="user_class" readonly value="<%=user_class%>"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">生日</label>
                                <div class="col-sm-4">
                                    <input  class="form-control" name="user_birth" id="user_birth" readonly disabled value="<fmt:formatDate value="<%=user_birth%>" pattern="yyyy-MM-dd"/>"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">个人说明</label>
                                <div class="col-sm-4">
                                    <textarea class="form-control" name="user_desc" id="user_desc" rows="4" readonly style="resize: none"><%=user_desc%></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-10">
                                    <button type="button" class="btn btn-default" id="update_btn">编辑</button>
                                    <button type="submit" class="btn btn-default" id="save_btn">保存</button>
                                    <button type="button" class="btn btn-default" id="cancel_btn">取消</button>
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
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap-datetimepicker.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap-datetimepicker.zh-CN.js"></script>

<script>
    $("#update_btn").click(function () {
        $("#save_btn").show();
        $("#update_btn").hide();
        $("#cancel_btn").show();
        $("#user_name").attr("readonly",false);
        $("#user_sex").attr("disabled",false);
        $("#user_birth").attr("disabled",false);
        $("#user_class").attr("readonly",false);
        $("#user_desc").attr("readonly",false);
    });

    $("#cancel_btn").click(function () {
        $("#flag").val('');
        $("#save_btn").click();
    });

    $("#user_birth").datetimepicker({
        pickDate:true,
        minView:"month",
        language:"zh-CN",
        format:"yyyy-mm-dd",

    });

    $(function () {
        $("#save_btn").hide();
        $("#update_btn").show();
        $("#cancel_btn").hide();
        $("#user_sex").val("<%=user_sex%>");
        if (${currentUser.user_level == "教师"}) {
            $("#user_class_div").hide();
        }
    });

</script>
</body>
</html>
