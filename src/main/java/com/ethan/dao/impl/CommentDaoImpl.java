package com.ethan.dao.impl;

import com.ethan.dao.CommentDao;
import com.ethan.entity.AllEntity;
import com.ethan.entity.Comment;
import com.ethan.entity.Pagination;
import com.ethan.entity.Post;
import com.ethan.utils.StringUtil;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.SQLException;
import java.util.List;

public class CommentDaoImpl extends BaseDao implements CommentDao {
    @Override
    public List<AllEntity> allComment(Post post) throws SQLException {
        String sql = "select * from comment,post where comment.comment_pid = post.post_id ";
        if(post.getPost_id()>0){
            sql +=" and post.post_id='"+post.getPost_id()+"'";
            sql +=" order by comment_id desc";
        }
        else{
            sql +=" order by comment_id desc ";
            sql +=" limit 8";
        }
        List<AllEntity>allEntities = queryRunner.query(sql,new BeanListHandler<AllEntity>(AllEntity.class));
        return allEntities;
    }

    @Override
    public int addComment(Comment comment) throws SQLException {
        String sql = "insert into comment (comment_pid,comment_uid,comment_text,comment_time) values(?,?,?,?)";
        int code = 0 ;
        code = queryRunner.update(sql,comment.getComment_pid(),comment.getComment_uid(),comment.getComment_text(),comment.getComment_time());
        return code;
    }

    @Override
    public long allCommentCount() throws SQLException {
        String sql = "select count(*) from comment,post where comment.comment_pid = post.post_id ";
        long total = 0;
        total = queryRunner.query(sql ,new ScalarHandler<Long>());
        return total;
    }

    @Override
    public List<AllEntity> allCommentList(Pagination pagination) throws SQLException {
        String sql = "select * from comment,post where comment.comment_pid = post.post_id ";
        if(pagination.getCurPage() > 0 && pagination.getPageSize()>0){
            sql+=" limit "+(pagination.getCurPage() - 1) * pagination.getPageSize()+","+pagination.getPageSize();
        }
        List<AllEntity> allEntities = queryRunner.query(sql,new BeanListHandler<AllEntity>(AllEntity.class));
        return allEntities;
    }

    @Override
    public int delComment(Comment comment) throws SQLException {
        String sql = "delete from comment where comment_id = ?";
        int code = 0;
        code = queryRunner.execute(sql,comment.getComment_id());
        return code;
    }
}
