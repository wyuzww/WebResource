package com.ethan.dao;

import com.ethan.entity.AllEntity;
import com.ethan.entity.Comment;
import com.ethan.entity.Pagination;
import com.ethan.entity.Post;

import java.sql.SQLException;
import java.util.List;

public interface CommentDao {
    public List<AllEntity> allComment(Post post) throws SQLException;

    public int addComment(Comment comment) throws SQLException;

    public long allCommentCount() throws SQLException;

    public List<AllEntity> allCommentList(Pagination pagination) throws SQLException;

    public int delComment(Comment comment) throws SQLException;
}
