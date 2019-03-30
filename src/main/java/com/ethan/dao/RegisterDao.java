package com.ethan.dao;

import com.ethan.entity.Pagination;
import com.ethan.entity.Register;
import com.ethan.entity.User;

import java.sql.SQLException;
import java.util.List;

public interface RegisterDao {
    public int userRegister(Register register) throws SQLException;

    public boolean checkUser(User user) throws SQLException;

    public List<Register> allRegister(Pagination pagination) throws SQLException;

    public long registerCount() throws SQLException;

    public int updateRegister(Register register) throws SQLException;

    public int bulkImport(String filePath) throws SQLException;
}
