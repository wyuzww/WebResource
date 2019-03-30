package com.ethan.dao;

import com.ethan.entity.Category;
import com.ethan.entity.Pagination;

import java.sql.SQLException;
import java.util.List;

public interface CategoryDao {
    public List<Category> allCategory(Category category) throws SQLException;

    public List<Category> allCategoryList(Category category,Pagination pagination) throws SQLException;

    public int addCategory(Category category)throws SQLException;

    public int delCategory(Category category) throws SQLException;

    public int updateCateGory(Category category) throws SQLException;

    public long categoryCount(Category category)throws SQLException;
}
