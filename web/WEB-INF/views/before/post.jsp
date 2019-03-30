<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.jws.soap.SOAPBinding" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.ethan.utils.DateUtil" %>
<%@ page import="com.ethan.entity.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="java.io.File" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="com.ethan.dao.impl.PostDaoImpl" %>
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
    PostDaoImpl postDao = new PostDaoImpl();


%>
<%
    String uid = null;
    String post_title = null;
    String post_text = null;
    String post_images = null;
    List<String> images_url = new ArrayList<>();
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);

    if (isMultipart) {
        // 创建工厂（这里用的是工厂模式）
        DiskFileItemFactory factory = new DiskFileItemFactory();
        //获取汽车零件清单与组装说明书（从ServletContext中得到上传来的数据）
        ServletContext servletContext = this.getServletConfig().getServletContext();
        File repository = (File) servletContext.getAttribute("javax.servlet.context.tempdir");
        //工厂把将要组装的汽车的参数录入工厂自己的系统，因为要根据这些参数开设一条生产线（上传来的文件的各种属性）
        factory.setRepository(repository);
        //此时工厂中已经有了汽车的组装工艺、颜色等属性参数（上传来的文件的大小、文件名等）
        //执行下面的这一行代码意味着根据组装工艺等开设了一条组装生产线
        ServletFileUpload upload = new ServletFileUpload(factory);

        //解析请求
        try {
            //把零件送给生产线，出来的就是一辆组装好的汽车（把request转成FileItem的实例）
            List<FileItem> items = upload.parseRequest(request);
            Iterator<FileItem> iter = items.iterator();
            while (iter.hasNext()) {
                FileItem item = iter.next();
                boolean isForm = item.isFormField();
                if (isForm) {
                    String name = item.getFieldName();
                    if ("uid".equals(name)) {
                        uid = item.getString("utf-8");
                        System.out.println(uid);
                    }
                    if ("post_text".equals(name)) {
                        post_text = item.getString("utf-8");
                        System.out.println(post_text);
                    }
                    if ("post_title".equals(name)) {
                        post_title = item.getString("utf-8");
                        System.out.println(post_title);
                    }
                } else {
                    if (item.getSize()>10) {
                        String name = new String(item.getName().getBytes("GBK"),"UTF-8");
                        //创建文件输出流
                        String filePath = request.getServletContext().getRealPath("upload");
                        String uploadFilePath = filePath+"/images";
                        images_url.add("upload/images/"+name) ;
                        File file=new File(uploadFilePath,name);
                        System.out.println(images_url.toString());
                        if(!file.exists())
                        {
                            try {
                                file.createNewFile();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                        FileOutputStream fos=new FileOutputStream(file);
                        //创建输入流
                        InputStream fis=(InputStream) item.getInputStream();
                        //从输入流获取字节数组
                        byte b[]=new byte[1];
                        //读取一个输入流的字节到b[0]中
                        int read=fis.read(b);
                        while(read!=-1)
                        {
                            fos.write(b,0,1);
                            read=fis.read(b);
                        }
                        fis.close();
                        fos.flush();
                        fos.close();
                        //打印List中的内容（每一个FileItem的实例代表一个文件，执行这行代码会打印该文件的一些基本属性，文件名，大小等）
                        System.out.println(item);
                    }
                }
            }
            System.out.println("输出完成");
            if (!images_url.isEmpty()) {
                post_images = images_url.toString().substring(1,images_url.toString().length()-1);
            }
            System.out.println(post_images);

            Post post = new Post(0,uid,post_title,post_text,post_images,new Date());

            int code = 0;
            try {
                code = postDao.addPost(post);
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (code>0) {
                request.setAttribute("isSuccess",true);
            } else {
                request.setAttribute("isSuccess",false);
            }
        } catch (FileUploadException e) {
            // TODO Auto-generated catch block
            request.setAttribute("isSuccess",false);
            e.printStackTrace();
        }
    }
    else {
//        System.out.println("False");
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
                    <li title="资源" ><a href="resource">资源</a></li>
                    <li title="论坛" class="active"><a href="forum">论坛</a></li>
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
                <h3>论坛中心</h3>
                <li style="display:block">
                    <a class="list-group-item " title="全部资源" href="resource">全部帖子</a>
                </li>
                <li style="display:block">
                    <a class="list-group-item active" title="上传资源" href="user/post?uid=${currentUser.user_id}">我要发帖</a>
                </li>
            </ul>
        </div>

        <div class="col-md-9">

            <div>
                <h3>我要发帖</h3>
            </div>

            <div class="panel panel-default">
                <div class="container-fluid ">
                    <div style="margin: 20px">
                        <form class="form-horizontal" name="uploadForm" role="form" action="user/post" method="post" enctype="multipart/form-data">
                            <input type="text" hidden name="uid" value="${currentUser.user_id}"/>
                            <c:choose>
                                <c:when test="${not empty isSuccess and isSuccess==true}">
                                    <div class="alert alert-dismissable alert-success">
                                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                        <h4>
                                            提示!
                                        </h4> <strong>提交成功!</strong>
                                    </div>
                                </c:when>
                                <c:when test="${not empty isSuccess and isSuccess==false}">
                                    <div class="alert alert-dismissable alert-danger">
                                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                        <h4>
                                            提示!
                                        </h4> <strong>提交失败!</strong>
                                    </div>
                                </c:when>
                            </c:choose>
                            <div class="form-group">
                                <label for="post_title" class="col-sm-2 control-label">标题</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" name="post_title" id="post_title" required/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="post_text" class="col-sm-2 control-label">正文</label>
                                <div class="col-sm-8">
                                    <textarea class="form-control" name="post_text" id="post_text" rows="10" required style="resize: none"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="post_images" class="col-sm-2 control-label">选择图片</label>
                                <div class="col-sm-8">
                                    <input accept="image/*"  type="file" multiple id="post_images" name="post_images"  >
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-10">
                                    <button type="submit" class="btn btn-info">提交</button>
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
