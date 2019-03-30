<%@ page import="com.ethan.entity.User" %><%--
  Created by IntelliJ IDEA.
  User: Ethan
  Date: 2018/12/6
  Time: 10:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("utf-8");
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<%
    // 权限验证
    if(session.getAttribute("currentUser")==null){
        response.sendRedirect(basePath+"main");
        return;
    }
    User currentUser = (User) session.getAttribute("currentUser");
    if (!currentUser.getUser_level().equals("管理员")&& !currentUser.getUser_level().equals("超级管理员")) {
        request.getRequestDispatcher("WEB-INF/views/before/main.jsp").forward(request, response);
    }

%>
<html>
<head>
    <title>校园资源共享平台</title>
    <base href="<%=basePath%>">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/resources/jquery-easyui-1.6.10/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/default.css">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/resources/jquery-easyui-1.6.10/themes/icon.css">
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/resources/jquery-easyui-1.6.10/jquery.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/resources/jquery-easyui-1.6.10/jquery.easyui.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/resources/jquery-easyui-1.6.10/locale/easyui-lang-zh_CN.js"></script>
    <%--<script type="text/javascript" src="resources/js/default.js"></script>--%>
    <script type="text/javascript">
        var url;

        function deleteComment() {
            var selectedRows = $("#dg").datagrid('getSelections');
            if (selectedRows.length == 0) {
                $.messager.alert("系统提示", "请选择要删除的评论！");
                return;
            }
            var strIds = [];
            for (var i = 0; i < selectedRows.length; i++) {
                strIds.push(selectedRows[i].comment_id);
            }
            var ids = strIds.join(",");
            $.messager.confirm("系统提示", "您确认要删掉这<font color=red>" + selectedRows.length + "</font>条评论吗？", function (r) {
                if (r) {
                    $.post("comment", {delIds: ids, flagText: "delete"}, function (result) {
                        // var json = $.parseJSON(result);
                        if (result.success == "true") {
                            $.messager.alert("系统提示", "您已成功删除<font color=red>" + result.delNums + "</font>条评论！");
                            $("#dg").datagrid("reload");
                        } else {
                            $.messager.alert('系统提示', result.msg);
                        }
                    }, "json");
                }
            });
        }

    </script>
</head>
<body>
<table id="dg" title="管理评论信息" class="easyui-datagrid" fitColumns="true"
       pagination="true" url="comment?flagText=allComment" fit="true" toolbar="#tb" .>
    <thead>
    <tr>
        <th field="cb" checkbox="true"></th>
        <th field="comment_id" width="50" align="center">评论编号</th>
        <th field="post_title" width="50" align="center">帖子标题</th>
        <th field="comment_text" width="100" align="center">评论内容</th>
        <th field="comment_uid" width="50" align="center">作者</th>
        <th field="comment_time" width="50" align="center">评论时间</th>

    </tr>
    </thead>
</table>

<div id="tb" align="center">
    <div>
        <a href="javascript:deleteComment()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
    </div>
    <div>
</div>
</div>
</body>
</html>
