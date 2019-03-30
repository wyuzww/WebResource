package com.ethan.entity;

import com.alibaba.fastjson.annotation.JSONField;

import java.util.Date;

public class Comment {

    private int comment_id;
    private int comment_pid;
    private String comment_uid;
    private String comment_text;
    @JSONField(format = "yyyy-MM-dd")
    private Date comment_time;

    public Comment() {
    }

    public Comment(int comment_id, int comment_pid, String comment_uid, String comment_text, Date comment_time) {
        this.comment_id = comment_id;
        this.comment_pid = comment_pid;
        this.comment_uid = comment_uid;
        this.comment_text = comment_text;
        this.comment_time = comment_time;
    }

    public int getComment_id() {
        return comment_id;
    }

    public void setComment_id(int comment_id) {
        this.comment_id = comment_id;
    }

    public int getComment_pid() {
        return comment_pid;
    }

    public void setComment_pid(int comment_pid) {
        this.comment_pid = comment_pid;
    }

    public String getComment_uid() {
        return comment_uid;
    }

    public void setComment_uid(String comment_uid) {
        this.comment_uid = comment_uid;
    }

    public String getComment_text() {
        return comment_text;
    }

    public void setComment_text(String comment_text) {
        this.comment_text = comment_text;
    }

    public Date getComment_time() {
        return comment_time;
    }

    public void setComment_time(Date comment_time) {
        this.comment_time = comment_time;
    }

    @Override
    public String toString() {
        return "Comment{" +
                "comment_id=" + comment_id +
                ", comment_pid=" + comment_pid +
                ", comment_uid='" + comment_uid + '\'' +
                ", comment_text='" + comment_text + '\'' +
                ", comment_time=" + comment_time +
                '}';
    }
}
