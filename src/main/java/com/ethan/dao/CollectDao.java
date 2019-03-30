package com.ethan.dao;

import com.ethan.entity.Collect;

import java.sql.SQLException;

public interface CollectDao {
    public int addCollect(Collect collect) throws SQLException;

    public int delCollect(Collect collect) throws SQLException;
}
