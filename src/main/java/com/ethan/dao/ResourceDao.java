package com.ethan.dao;

import java.sql.SQLException;
import java.util.List;
import com.ethan.entity.AllEntity;
import com.ethan.entity.Pagination;
import com.ethan.entity.Resource;
import com.ethan.entity.User;

public interface ResourceDao {

    public List<AllEntity> allResource(AllEntity allEntity, Pagination pagination) throws SQLException;

    public int addResource(Resource resource) throws SQLException;

    public List<AllEntity> allCollectByUserID(AllEntity allEntity, Pagination pagination) throws SQLException;

    public int delResource(Resource resource) throws SQLException;

    public long  resourceCount(AllEntity allEntity) throws SQLException;

    public long collectByIDCount(AllEntity allEntity) throws SQLException;

    public int setGoodResource(Resource resource,int good) throws SQLException;
}
