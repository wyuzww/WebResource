package com.ethan.entity;

import com.alibaba.fastjson.annotation.JSONField;

import java.util.Date;

public class AllEntity {
    private int category_id;
    private String category_name;
    private String category_desc;

    private String collect_uid;
    private int collect_rid;


    private int comment_id;
    private int comment_pid;
    private String comment_uid;
    private String comment_text;
    @JSONField(format = "yyyy-MM-dd")
    private Date comment_time;

    private String follow_uid;
    private String followed_uid;


    private int post_id;
    private String post_uid;
    private String post_title;
    private String post_text;
    private String post_image;
    @JSONField(format = "yyyy-MM-dd")
    private Date post_time;


    private String register_id;
    private String register_password;
    private String register_name;
    private String register_class;
    private String register_level;
    private int register_check;


    private int resource_id;
    private int resource_cid;
    private String resource_uid;
    private String resource_name;
    private String resource_image;
    private String resource_url;
    private String resource_desc;
    private String resource_level;
    @JSONField(format = "yyyy-MM-dd")
    private Date resource_time;
    private int resource_good;


    private String student_id;
    private String student_name;
    private String student_sex;
    @JSONField(format = "yyyy-MM-dd")
    private Date student_birth;
    private String student_class;
    private String student_desc;



    private String teacher_id;
    private String teacher_name;
    private String teacher_sex;
    @JSONField(format = "yyyy-MM-dd")
    private Date teacher_birth;
    private String teacher_desc;

    private String user_id;
    private String user_password;
    private String user_level;


    public AllEntity() {
    }


    public AllEntity(int category_id, String category_name, String category_desc, String collect_uid, int collect_rid, int comment_id, int comment_pid, String comment_uid, String comment_text, Date comment_time, String follow_uid, String followed_uid, int post_id, String post_uid, String post_title, String post_text, String post_image, Date post_time, String register_id, String register_password, String register_name, String register_class, String register_level, int register_check, int resource_id, int resource_cid, String resource_uid, String resource_name, String resource_image, String resource_url, String resource_desc, String resource_level, Date resource_time, int resource_good, String student_id, String student_name, String student_sex, Date student_birth, String student_class, String student_desc, String teacher_id, String teacher_name, String teacher_sex, Date teacher_birth, String teacher_desc, String user_id, String user_password, String user_level) {
        this.category_id = category_id;
        this.category_name = category_name;
        this.category_desc = category_desc;
        this.collect_uid = collect_uid;
        this.collect_rid = collect_rid;
        this.comment_id = comment_id;
        this.comment_pid = comment_pid;
        this.comment_uid = comment_uid;
        this.comment_text = comment_text;
        this.comment_time = comment_time;
        this.follow_uid = follow_uid;
        this.followed_uid = followed_uid;
        this.post_id = post_id;
        this.post_uid = post_uid;
        this.post_title = post_title;
        this.post_text = post_text;
        this.post_image = post_image;
        this.post_time = post_time;
        this.register_id = register_id;
        this.register_password = register_password;
        this.register_name = register_name;
        this.register_class = register_class;
        this.register_level = register_level;
        this.register_check = register_check;
        this.resource_id = resource_id;
        this.resource_cid = resource_cid;
        this.resource_uid = resource_uid;
        this.resource_name = resource_name;
        this.resource_image = resource_image;
        this.resource_url = resource_url;
        this.resource_desc = resource_desc;
        this.resource_level = resource_level;
        this.resource_time = resource_time;
        this.resource_good = resource_good;
        this.student_id = student_id;
        this.student_name = student_name;
        this.student_sex = student_sex;
        this.student_birth = student_birth;
        this.student_class = student_class;
        this.student_desc = student_desc;
        this.teacher_id = teacher_id;
        this.teacher_name = teacher_name;
        this.teacher_sex = teacher_sex;
        this.teacher_birth = teacher_birth;
        this.teacher_desc = teacher_desc;
        this.user_id = user_id;
        this.user_password = user_password;
        this.user_level = user_level;
    }

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public String getCategory_name() {
        return category_name;
    }

    public void setCategory_name(String category_name) {
        this.category_name = category_name;
    }

    public String getCategory_desc() {
        return category_desc;
    }

    public void setCategory_desc(String category_desc) {
        this.category_desc = category_desc;
    }

    public String getCollect_uid() {
        return collect_uid;
    }

    public void setCollect_uid(String collect_uid) {
        this.collect_uid = collect_uid;
    }

    public int getCollect_rid() {
        return collect_rid;
    }

    public void setCollect_rid(int collect_rid) {
        this.collect_rid = collect_rid;
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

    public String getFollow_uid() {
        return follow_uid;
    }

    public void setFollow_uid(String follow_uid) {
        this.follow_uid = follow_uid;
    }

    public String getFollowed_uid() {
        return followed_uid;
    }

    public void setFollowed_uid(String followed_uid) {
        this.followed_uid = followed_uid;
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

    public String getRegister_id() {
        return register_id;
    }

    public void setRegister_id(String register_id) {
        this.register_id = register_id;
    }

    public String getRegister_password() {
        return register_password;
    }

    public void setRegister_password(String register_password) {
        this.register_password = register_password;
    }

    public String getRegister_name() {
        return register_name;
    }

    public void setRegister_name(String register_name) {
        this.register_name = register_name;
    }

    public String getRegister_class() {
        return register_class;
    }

    public void setRegister_class(String register_class) {
        this.register_class = register_class;
    }

    public String getRegister_level() {
        return register_level;
    }

    public void setRegister_level(String register_level) {
        this.register_level = register_level;
    }

    public int getRegister_check() {
        return register_check;
    }

    public void setRegister_check(int register_check) {
        this.register_check = register_check;
    }

    public int getResource_id() {
        return resource_id;
    }

    public void setResource_id(int resource_id) {
        this.resource_id = resource_id;
    }

    public int getResource_cid() {
        return resource_cid;
    }

    public void setResource_cid(int resource_cid) {
        this.resource_cid = resource_cid;
    }

    public String getResource_uid() {
        return resource_uid;
    }

    public void setResource_uid(String resource_uid) {
        this.resource_uid = resource_uid;
    }

    public String getResource_name() {
        return resource_name;
    }

    public void setResource_name(String resource_name) {
        this.resource_name = resource_name;
    }

    public String getResource_image() {
        return resource_image;
    }

    public void setResource_image(String resource_image) {
        this.resource_image = resource_image;
    }

    public String getResource_url() {
        return resource_url;
    }

    public void setResource_url(String resource_url) {
        this.resource_url = resource_url;
    }

    public String getResource_desc() {
        return resource_desc;
    }

    public void setResource_desc(String resource_desc) {
        this.resource_desc = resource_desc;
    }

    public String getResource_level() {
        return resource_level;
    }

    public void setResource_level(String resource_level) {
        this.resource_level = resource_level;
    }

    public Date getResource_time() {
        return resource_time;
    }

    public void setResource_time(Date resource_time) {
        this.resource_time = resource_time;
    }

    public int getResource_good() {
        return resource_good;
    }

    public void setResource_good(int resource_good) {
        this.resource_good = resource_good;
    }

    public String getStudent_id() {
        return student_id;
    }

    public void setStudent_id(String student_id) {
        this.student_id = student_id;
    }

    public String getStudent_name() {
        return student_name;
    }

    public void setStudent_name(String student_name) {
        this.student_name = student_name;
    }

    public String getStudent_sex() {
        return student_sex;
    }

    public void setStudent_sex(String student_sex) {
        this.student_sex = student_sex;
    }

    public Date getStudent_birth() {
        return student_birth;
    }

    public void setStudent_birth(Date student_birth) {
        this.student_birth = student_birth;
    }

    public String getStudent_class() {
        return student_class;
    }

    public void setStudent_class(String student_class) {
        this.student_class = student_class;
    }

    public String getStudent_desc() {
        return student_desc;
    }

    public void setStudent_desc(String student_desc) {
        this.student_desc = student_desc;
    }

    public String getTeacher_id() {
        return teacher_id;
    }

    public void setTeacher_id(String teacher_id) {
        this.teacher_id = teacher_id;
    }

    public String getTeacher_name() {
        return teacher_name;
    }

    public void setTeacher_name(String teacher_name) {
        this.teacher_name = teacher_name;
    }

    public String getTeacher_sex() {
        return teacher_sex;
    }

    public void setTeacher_sex(String teacher_sex) {
        this.teacher_sex = teacher_sex;
    }

    public Date getTeacher_birth() {
        return teacher_birth;
    }

    public void setTeacher_birth(Date teacher_birth) {
        this.teacher_birth = teacher_birth;
    }

    public String getTeacher_desc() {
        return teacher_desc;
    }

    public void setTeacher_desc(String teacher_desc) {
        this.teacher_desc = teacher_desc;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getUser_password() {
        return user_password;
    }

    public void setUser_password(String user_password) {
        this.user_password = user_password;
    }

    public String getUser_level() {
        return user_level;
    }

    public void setUser_level(String user_level) {
        this.user_level = user_level;
    }

    @Override
    public String toString() {
        return "AllEntity{" +
                "category_id=" + category_id +
                ", category_name='" + category_name + '\'' +
                ", category_desc='" + category_desc + '\'' +
                ", collect_uid='" + collect_uid + '\'' +
                ", collect_rid=" + collect_rid +
                ", comment_id=" + comment_id +
                ", comment_pid=" + comment_pid +
                ", comment_uid='" + comment_uid + '\'' +
                ", comment_text='" + comment_text + '\'' +
                ", comment_time=" + comment_time +
                ", follow_uid='" + follow_uid + '\'' +
                ", followed_uid='" + followed_uid + '\'' +
                ", post_id=" + post_id +
                ", post_uid='" + post_uid + '\'' +
                ", post_title='" + post_title + '\'' +
                ", post_text='" + post_text + '\'' +
                ", post_image='" + post_image + '\'' +
                ", post_time=" + post_time +
                ", register_id='" + register_id + '\'' +
                ", register_password='" + register_password + '\'' +
                ", register_name='" + register_name + '\'' +
                ", register_class='" + register_class + '\'' +
                ", register_level='" + register_level + '\'' +
                ", register_check=" + register_check +
                ", resource_id=" + resource_id +
                ", resource_cid=" + resource_cid +
                ", resource_uid='" + resource_uid + '\'' +
                ", resource_name='" + resource_name + '\'' +
                ", resource_image='" + resource_image + '\'' +
                ", resource_url='" + resource_url + '\'' +
                ", resource_desc='" + resource_desc + '\'' +
                ", resource_level='" + resource_level + '\'' +
                ", resource_time=" + resource_time +
                ", resource_good=" + resource_good +
                ", student_id='" + student_id + '\'' +
                ", student_name='" + student_name + '\'' +
                ", student_sex='" + student_sex + '\'' +
                ", student_birth=" + student_birth +
                ", student_class='" + student_class + '\'' +
                ", student_desc='" + student_desc + '\'' +
                ", teacher_id='" + teacher_id + '\'' +
                ", teacher_name='" + teacher_name + '\'' +
                ", teacher_sex='" + teacher_sex + '\'' +
                ", teacher_birth=" + teacher_birth +
                ", teacher_desc='" + teacher_desc + '\'' +
                ", user_id='" + user_id + '\'' +
                ", user_password='" + user_password + '\'' +
                ", user_level='" + user_level + '\'' +
                '}';
    }
}
