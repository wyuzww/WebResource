package com.ethan.entity;

import com.alibaba.fastjson.annotation.JSONField;

import java.util.Date;

public class Post {
    private int post_id;
    private String post_uid;
    private String post_title;
    private String post_text;
    private String post_image;
    @JSONField(format = "yyyy-MM-dd")
    private Date post_time;

    public Post() {
    }

    public Post(int post_id, String post_uid, String post_title, String post_text, String post_image, Date post_time) {
        this.post_id = post_id;
        this.post_uid = post_uid;
        this.post_title = post_title;
        this.post_text = post_text;
        this.post_image = post_image;
        this.post_time = post_time;
    }

    public int getPost_id() {
        return post_id;
    }

    public void setPost_id(int post_id) {
        this.post_id = post_id;
    }

    public String getPost_uid() {
        return post_uid;
    }

    public void setPost_uid(String post_uid) {
        this.post_uid = post_uid;
    }

    public String getPost_title() {
        return post_title;
    }

    public void setPost_title(String post_title) {
        this.post_title = post_title;
    }

    public String getPost_text() {
        return post_text;
    }

    public void setPost_text(String post_text) {
        this.post_text = post_text;
    }

    public String getPost_image() {
        return post_image;
    }

    public void setPost_image(String post_image) {
        this.post_image = post_image;
    }

    public Date getPost_time() {
        return post_time;
    }

    public void setPost_time(Date post_time) {
        this.post_time = post_time;
    }

    @Override
    public String toString() {
        return "Post{" +
                "post_id=" + post_id +
                ", post_uid='" + post_uid + '\'' +
                ", post_title='" + post_title + '\'' +
                ", post_text='" + post_text + '\'' +
                ", post_image='" + post_image + '\'' +
                ", post_time=" + post_time +
                '}';
    }
}
