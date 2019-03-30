package com.ethan.entity;

public class Collect {

    private String collect_uid;
    private int collect_rid;

    public Collect() {
    }

    public Collect(String collect_uid, int collect_rid) {
        this.collect_uid = collect_uid;
        this.collect_rid = collect_rid;
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

    @Override
    public String toString() {
        return "Collect{" +
                "collect_uid='" + collect_uid + '\'' +
                ", collect_rid=" + collect_rid +
                '}';
    }
}
