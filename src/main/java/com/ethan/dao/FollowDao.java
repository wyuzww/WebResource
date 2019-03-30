package com.ethan.dao;

import com.ethan.entity.AllEntity;
import com.ethan.entity.Follow;
import com.ethan.entity.Pagination;
import com.ethan.entity.User;

import java.sql.SQLException;
import java.util.List;

public interface FollowDao {
    public int addFollow(Follow follow) throws SQLException;

    public int delFollow(Follow follow) throws SQLException;

    public List<AllEntity> findFollow(User user,AllEntity allEntity, Pagination pagination) throws SQLException;

    public long followCount(User user,AllEntity allEntity) throws SQLException;
}
