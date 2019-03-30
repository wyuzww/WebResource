package com.ethan.dao;

import com.ethan.entity.*;

import java.sql.SQLException;
import java.util.List;

/**
 * Created by zhangwenyu on 2018/12/14.
 */
public interface UserDao {
    public User login(User user) throws SQLException;

    public AllEntity getUser(User user) throws SQLException;

    public int updatePassword(User user, String new_Password) throws SQLException;

    public int updateStudent(Student student) throws SQLException;

    public int updateTeacher(Teacher teacher) throws SQLException;

    public List<AllEntity> findUser(User user, Pagination pagination) throws SQLException;

    public long findUserCount(User user) throws SQLException;

    public int addUser(Register register) throws SQLException;

    public int addStudent(Register register) throws SQLException;

    public int addTeacher(Register register) throws SQLException;

    public int delUser(User user) throws SQLException;

    public List<AllEntity> getAllTeacher(Teacher teacher,Pagination pagination) throws SQLException;

    public long teacherCount(Teacher teacher) throws SQLException;

    public List<AllEntity> getAllStudent(Student student,Pagination pagination) throws SQLException;

    public long studentCount(Student student) throws SQLException;
}
