package com.ethan.dao.impl;

import com.ethan.dao.PostDao;
import com.ethan.entity.AllEntity;
import com.ethan.entity.Pagination;
import com.ethan.entity.Post;
import com.ethan.utils.StringUtil;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.SQLException;
import java.util.List;

public class PostDaoImpl  extends BaseDao implements PostDao {
    @Override
    public List<AllEntity> allPost(AllEntity allEntity, Pagination pagination) throws SQLException {
        String sql ="select * from user,post where user.user_id=post.post_uid";
        if (StringUtil.isNotEmpty(allEntity.getPost_title())) {
            sql +=" and post.post_title like '%"+allEntity.getPost_title()+"%'";
        }
        if(StringUtil.isNotEmpty(allEntity.getUser_level())){
            sql +=" and user.user_level ='"+allEntity.getUser_level()+"'";
        }
        if(allEntity.getPost_id()>0){
            sql +=" and post.post_id ="+allEntity.getPost_id()+"";
        }
        if (StringUtil.isNotEmpty(allEntity.getPost_uid())){
            sql +=" and post.post_uid = '"+allEntity.getPost_uid()+"'";
        }
        sql +=" order by post.post_id desc";




        if(pagination.getCurPage() > 0 && pagination.getPageSize()>0){
            sql+=" limit "+(pagination.getCurPage() - 1) * pagination.getPageSize()+","+pagination.getPageSize();
        }
        List<AllEntity> allEntities = queryRunner.query(sql,new BeanListHandler<AllEntity>(AllEntity.class));
        return allEntities;
    }

    @Override
    public int addPost(Post post) throws SQLException {
        String sql = "insert into post (post_uid,post_title,post_text,post_image,post_time) values(?,?,?,?,?)";
        int code = 0;
        code = queryRunner.update(sql,post.getPost_uid(),post.getPost_title(),post.getPost_text(),post.getPost_image(),post.getPost_time());
        return code;
    }

    @Override
    public int delPost(Post post) throws SQLException {
        String sql = "delete from post where post_id = ?";
        if(StringUtil.isNotEmpty(post.getPost_uid())){
            sql +=" and post_uid ='"+post.getPost_uid()+"'";
        }
        int code = 0;
        code = queryRunner.execute(sql,post.getPost_id());
        return code;
    }

    @Override
    public long postCount(AllEntity allEntity) throws SQLException {
        String sql ="select count(*) from user,post where user.user_id=post.post_uid";
        if(StringUtil.isNotEmpty(allEntity.getPost_title())){
            sql +=" and post.post_title like '%"+allEntity.getPost_title()+"'";
        }
        if(StringUtil.isNotEmpty(allEntity.getUser_level())){
            sql +=" and user.user_level ='"+allEntity.getUser_level()+"'";
        }
        if(allEntity.getPost_id()>0){
            sql +=" and post.post_id ="+allEntity.getPost_id()+"";
        }
        if (StringUtil.isNotEmpty(allEntity.getPost_uid())){
            sql +=" and post.post_uid = '"+allEntity.getPost_uid()+"'";
        }
        sql +=" order by post.post_id desc";

        long total = 0;
        total = queryRunner.query(sql ,new ScalarHandler<Long>());
        return total;
    }
}
