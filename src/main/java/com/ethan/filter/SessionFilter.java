package com.ethan.filter;

import com.ethan.entity.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class SessionFilter implements Filter {
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;


        String url = request.getRequestURI();

//        if (url.endsWith("login")) {
//            chain.doFilter(request, response);
//            return;
//        }

        if (request.getServletPath().toString().equals("/user") || request.getServletPath().toString().equals("/user/login")|| request.getServletPath().toString().equals("/user/register")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = request.getSession(); //判断session是否过期
        if ((User) session.getAttribute("currentUser") == null) {
//            String errors = "您还没有登录，或者session已过期。请先登陆!";
            //跳转至登录页面
            response.sendRedirect(new MyHttpServletRequestWrapper(request,url).getRequestURI());
            return;
        } else {
            chain.doFilter(request, response);
            return;
        }
    }

    public void init(FilterConfig config) throws ServletException {

    }



    /**
     * 重新封装request包装类
     *
     * @author Administrator
     */
    class MyHttpServletRequestWrapper extends HttpServletRequestWrapper {
        private String url;

        public MyHttpServletRequestWrapper(HttpServletRequest request, String url) {
            super(request);
            this.url = url;
        }

        @Override
        public String getRequestURI() {//servlet根据这个获得路径
//            System.out.println("getRequestURI执行");
            String path = getScheme()+"://"+getServerName()+":"+getServerPort()+getContextPath();
            return path+"/user/login";

        }

    }
}