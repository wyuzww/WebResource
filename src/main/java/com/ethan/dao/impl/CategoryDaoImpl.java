package com.ethan.dao.impl;

import com.ethan.dao.CategoryDao;
import com.ethan.entity.Category;
import com.ethan.entity.Pagination;
import com.ethan.utils.StringUtil;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.SQLException;
import java.util.List;

public class CategoryDaoImpl extends BaseDao implements CategoryDao {
    @Override
    public List<Category> allCategory(Category category) throws SQLException {
        String sql = "select * from category where 1=1";
        List<Category> categories = queryRunner.query(sql,new BeanListHandler<Category>(Category.class));
        return categories;
    }

    @Override
    public List<Category> allCategoryList( Category category,Pagination pagination) throws SQLException {
        String sql = "select * from category where 1=1";
        if (StringUtil.isNotEmpty(category.getCategory_name())) {
            sql +=" and category_name like '%"+category.getCategory_name()+"%' ";
        }
        if(pagination.getCurPage() > 0 && pagination.getPageSize()>0){
            sql+=" limit "+(pagination.getCurPage() - 1) * pagination.getPageSize()+","+pagination.getPageSize();
        }
        List<Category> categories = queryRunner.query(sql,new BeanListHandler<Category>(Category.class));
        return categories;
    }

    @Override
    public int addCategory(Category category) throws SQLException {
        String sql = "insert into category (category_name,category_desc) values(?,?)";
        int code = 0;
        code = queryRunner.update(sql,category.getCategory_name(),category.getCategory_desc());
        return code;
    }

    @Override
    public int delCategory(Category category) throws SQLException {
        String sql = "delete from category where category_id=?";
        int code = 0;
        code =queryRunner.execute(sql,category.getCategory_id());
        return code;
    }

    @Override
    public int updateCateGory(Category category) throws SQLException {
        String sql = "update category set category_name=?,category_desc=? where category_id=?";
        int code = 0;
        code = queryRunner.update(sql,category.getCategory_name(),category.getCategory_desc(),category.getCategory_id());
        return code;
    }

    @Override
    public long categoryCount(Category category) throws SQLException {
        String sql = "select count(*) from category where 1=1";
        if (StringUtil.isNotEmpty(category.getCategory_name())) {
            sql +=" and category_name like '%"+category.getCategory_name()+"%' ";
        }
        long total = 0;
        total = queryRunner.query(sql ,new ScalarHandler<Long>());
        return total;
    }

}
