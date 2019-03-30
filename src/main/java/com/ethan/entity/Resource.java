package com.ethan.entity;

import com.alibaba.fastjson.annotation.JSONField;

import java.util.Date;

public class Resource {

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

    public Resource() {
    }

    public Resource(int resource_id, int resource_cid, String resource_uid, String resource_name, String resource_image, String resource_url, String resource_desc, String resource_level, Date resource_time, int resource_good) {
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

    @Override
    public String toString() {
        return "Resource{" +
                "resource_id=" + resource_id +
                ", resource_cid=" + resource_cid +
                ", resource_uid='" + resource_uid + '\'' +
                ", resource_name='" + resource_name + '\'' +
                ", resource_image='" + resource_image + '\'' +
                ", resource_url='" + resource_url + '\'' +
                ", resource_desc='" + resource_desc + '\'' +
                ", resource_level='" + resource_level + '\'' +
                ", resource_time=" + resource_time +
                ", resource_good=" + resource_good +
                '}';
    }
}
