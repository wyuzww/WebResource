<%--
  Created by IntelliJ IDEA.
  User: Ethan
  Date: 2018/12/3
  Time: 23:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session.invalidate();
    response.sendRedirect("user/login");
%>

<html>
<head>
    <title>校园资源共享平台</title>
</head>
<body>
退出登录
</body>
</html>
