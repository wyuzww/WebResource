package com.ethan.service.impl;

import com.ethan.dao.UserDao;
import com.ethan.entity.User;
import com.ethan.factory.Factory;
import com.ethan.service.UserService;

import java.sql.SQLException;

public class UserServiceImpl implements UserService {
    UserDao userDao = Factory.getUserDaoInstance();

    @Override
    public User login(User user) throws SQLException {
        User userResult = null;
        userResult = userDao.login(user);
        return userResult;
    }


}
