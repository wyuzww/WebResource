package com.ethan.dao;

import com.ethan.entity.AllEntity;
import com.ethan.entity.Pagination;
import com.ethan.entity.Post;

import java.sql.SQLException;
import java.util.List;

public interface PostDao {

    public List<AllEntity> allPost(AllEntity allEntity, Pagination pagination) throws SQLException;

    public int addPost(Post post) throws SQLException;

    public int delPost(Post post) throws SQLException;

    public long postCount(AllEntity allEntity) throws SQLException;
}
