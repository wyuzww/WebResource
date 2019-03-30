package com.ethan.dao.impl;

import com.ethan.dao.FollowDao;
import com.ethan.entity.AllEntity;
import com.ethan.entity.Follow;
import com.ethan.entity.Pagination;
import com.ethan.entity.User;
import com.ethan.utils.StringUtil;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FollowDaoImpl extends BaseDao implements FollowDao {
    @Override
    public int addFollow(Follow follow) throws SQLException {
        String sql = "insert into follow (follow_uid,followed_uid) values(?,?)";
        int code = 0;
        code = queryRunner.update(sql,follow.getFollow_uid(),follow.getFollowed_uid());
        return code;
    }

    @Override
    public int delFollow(Follow follow) throws SQLException {
        String sql = "delete from follow where follow_uid=? and followed_uid=?";
        int code = 0;
        code = queryRunner.execute(sql,follow.getFollow_uid(),follow.getFollowed_uid());
        return code;
    }

    @Override
    public List<AllEntity> findFollow(User user,AllEntity allEntity, Pagination pagination) throws SQLException {
        List<AllEntity> allEntities = new ArrayList<>();
        String sql = "select user.user_id from user,follow where user.user_id=follow.followed_uid and follow.follow_uid=?";

        if (StringUtil.isNotEmpty(allEntity.getUser_id())) {
            sql +=" and follow.followed_uid like '%"+allEntity.getUser_id()+"%'";
        }

        if(pagination.getCurPage() > 0 && pagination.getPageSize()>0){
            sql+=" limit "+(pagination.getCurPage() - 1) * pagination.getPageSize()+","+pagination.getPageSize();
        }

        List<User> users = queryRunner.query(sql,new BeanListHandler<User>(User.class),user.getUser_id());
        UserDaoImpl userDao = new UserDaoImpl();
        for(int i = 0; i<users.size();i++){
            AllEntity allUser = userDao.getUser(users.get(i));
            allEntities.add(allUser);
        }
        return allEntities;
    }

    @Override
    public long followCount(User user,AllEntity allEntity) throws SQLException {
        String sql = "select count(*) from user,follow where user.user_id=follow.followed_uid and follow.follow_uid=?";

        if (StringUtil.isNotEmpty(allEntity.getUser_id())) {
            sql +=" and follow.followed_uid like '%"+allEntity.getUser_id()+"%'";
        }

        long total = 0;
        total = queryRunner.query(sql ,new ScalarHandler<Long>(),user.getUser_id());
        return total;
    }


}
