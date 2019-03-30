package com.ethan.dao.impl;

import com.ethan.dao.ResourceDao;
import com.ethan.entity.AllEntity;
import com.ethan.entity.Pagination;
import com.ethan.entity.Resource;
import com.ethan.entity.User;
import com.ethan.utils.StringUtil;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.SQLException;
import java.util.List;

public class ResourceDaoImpl extends BaseDao implements ResourceDao {
    @Override
    public List<AllEntity> allResource(AllEntity allEntity, Pagination pagination) throws SQLException {
        String sql = "select * from user,resource,category where user.user_id=resource.resource_uid and resource.resource_cid=category.category_id ";
        if (StringUtil.isNotEmpty(allEntity.getResource_name())) {
            sql +=" and resource.resource_name like '%"+allEntity.getResource_name()+"%'";
        }
        if(allEntity.getResource_cid()>0){
            sql +=" and resource.resource_cid ='"+allEntity.getResource_cid()+"'";
        }
        if (StringUtil.isNotEmpty(allEntity.getUser_level())) {
            sql+=" and user.user_level='"+allEntity.getUser_level()+"'";
        }
        if(allEntity.getResource_id()>0){
            sql +=" and resource.resource_id ="+allEntity.getResource_id()+"";
        }
        if(StringUtil.isNotEmpty(allEntity.getResource_uid())){
            sql+=" and resource.resource_uid='"+allEntity.getResource_uid()+"'";
        }
        sql +=" order by resource.resource_id desc";
        if(pagination.getCurPage() > 0 && pagination.getPageSize()>0){
            sql+=" limit "+(pagination.getCurPage() - 1) * pagination.getPageSize()+","+pagination.getPageSize();
        }
        List<AllEntity> allEntities = queryRunner.query(sql,new BeanListHandler<AllEntity>(AllEntity.class));
        return allEntities;
    }

    @Override
    public int addResource(Resource resource) throws SQLException {
        String sql = "insert into resource (resource_cid ,resource_uid,resource_name, resource_image,resource_url,resource_desc,resource_level,resource_time,resource_good) values(?,?,?,?,?,?,?,?,?)";
        int code = 0;
        code= queryRunner.update(sql,resource.getResource_cid(),resource.getResource_uid(),resource.getResource_name(),resource.getResource_image(),resource.getResource_url(),resource.getResource_desc(),resource.getResource_level(),resource.getResource_time(),resource.getResource_good());
        return code;
    }

    @Override
    public List<AllEntity> allCollectByUserID(AllEntity allEntity, Pagination pagination) throws SQLException {
        String sql ="select * from user,resource,collect,category where user.user_id=resource.resource_uid and resource.resource_cid=category.category_id and collect.collect_rid = resource.resource_id";
        if (StringUtil.isNotEmpty(allEntity.getResource_name())) {
            sql +=" and resource.resource_name like '%"+allEntity.getResource_name()+"%'";
        }
        if(allEntity.getResource_cid()>0){
            sql +=" and resource.resource_cid ='"+allEntity.getResource_cid()+"'";
        }
        if (StringUtil.isNotEmpty(allEntity.getUser_level())) {
            sql+=" and user.user_level='"+allEntity.getUser_level()+"'";
        }
        if(StringUtil.isNotEmpty(allEntity.getCollect_uid())){
            sql += " and collect.collect_uid='"+allEntity.getCollect_uid()+"'";
        }

        if(pagination.getCurPage() > 0 && pagination.getPageSize()>0){
            sql+=" limit "+(pagination.getCurPage() - 1) * pagination.getPageSize()+","+pagination.getPageSize();
        }
        List<AllEntity> allEntities = queryRunner.query(sql,new BeanListHandler<AllEntity>(AllEntity.class));
        return allEntities;

    }

    @Override
    public int delResource(Resource resource) throws SQLException {
        String sql = "delete from resource where resource_id='"+resource.getResource_id()+"'";
        if(StringUtil.isNotEmpty(resource.getResource_uid())){
            sql +=" and resource_uid='"+resource.getResource_uid()+"'";
        }
        int code = 0;
        code = queryRunner.execute(sql);
        return code;
    }

    @Override
    public long resourceCount(AllEntity allEntity) throws SQLException {
        String sql = "select count(*) from user,resource,category where user.user_id=resource.resource_uid and resource.resource_cid=category.category_id ";
        if (StringUtil.isNotEmpty(allEntity.getResource_name())) {
            sql +=" and resource.resource_name like '%"+allEntity.getResource_name()+"%'";
        }
        if(allEntity.getResource_cid()>0){
            sql +=" and resource.resource_cid ='"+allEntity.getResource_cid()+"'";
        }
        if (StringUtil.isNotEmpty(allEntity.getUser_level())) {
            sql+=" and user.user_level='"+allEntity.getUser_level()+"'";
        }
        if(StringUtil.isNotEmpty(allEntity.getResource_uid())){
            sql+=" and resource.resource_uid='"+allEntity.getResource_uid()+"'";
        }
        long total = 0;
        total = queryRunner.query(sql ,new ScalarHandler<Long>());
        return total;
    }

    @Override
    public long collectByIDCount(AllEntity allEntity) throws SQLException {
        String sql ="select count(*) from user,resource,collect,category where user.user_id=resource.resource_uid and resource.resource_cid=category.category_id and collect.collect_rid = resource.resource_id";
        if (StringUtil.isNotEmpty(allEntity.getResource_name())) {
            sql +=" and resource.resource_name like '%"+allEntity.getResource_name()+"%'";
        }
        if(allEntity.getResource_cid()>0){
            sql +=" and resource.resource_cid = "+allEntity.getResource_cid()+"";
        }
        if (StringUtil.isNotEmpty(allEntity.getUser_level())) {
            sql+=" and user.user_level='"+allEntity.getUser_level()+"'";
        }
        if(StringUtil.isNotEmpty(allEntity.getCollect_uid())){
            sql += " and collect.collect_uid='"+allEntity.getCollect_uid()+"'";
        }
        long  total = 0;
        total = queryRunner.query(sql ,new ScalarHandler<Long>());
        return total;
    }

    @Override
    public int setGoodResource(Resource resource,int good) throws SQLException {
        String sql = "update resource set resource_good=? where resource_id=?";
        int code = 0;
        code = queryRunner.update(sql,good,resource.getResource_id());
        return code;
    }


}
