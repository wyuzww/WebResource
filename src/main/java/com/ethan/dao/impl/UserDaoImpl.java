package com.ethan.dao.impl;

import com.ethan.dao.UserDao;
import com.ethan.entity.*;
import com.ethan.utils.StringUtil;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDaoImpl extends BaseDao implements UserDao {


    @Override
    public User login(User user) throws SQLException {
        String sql = "select * from user where user_id=? and user_password=?";
        User userResult = queryRunner.query(sql, new BeanHandler<User>(User.class), user.getUser_id(), user.getUser_password());
        return userResult;
    }

    @Override
    public AllEntity getUser(User user) throws SQLException {
        String sql1="select * from user where user_id='"+user.getUser_id()+"'";
        String sql=null ;
        AllEntity allEntity = null;
        User user1 = queryRunner.query(sql1,new BeanHandler<User>(User.class));
        if(user1 != null && user1.getUser_level().equals("学生")){
            sql = "select * from user, student where user_id=student_id and  student_id='"+user.getUser_id()+"'";
        }
        else if(user1 != null && user1.getUser_level().equals("教师")){
            sql = "select * from user,teacher where user_id=teacher_id and teacher_id='"+user.getUser_id()+"'";
        }else{
            sql="select * from user where user_id='"+user.getUser_id()+"'";
        }
        allEntity = queryRunner.query(sql,new BeanHandler<AllEntity>(AllEntity.class));
        return allEntity;
    }

    @Override
    public int updatePassword(User user, String new_Password) throws SQLException {
        String sql = "update user set user_password=? where user_id=? and user_password=?";
        int code = 0;
        code = queryRunner.update(sql,new_Password,user.getUser_id(),user.getUser_password());
        return code;
    }

    @Override
    public int updateStudent(Student student) throws SQLException {
        String sql = "update student set student_name=?,student_sex=?,student_birth=?,student_class=?,student_desc=? where student_id=?";
        int code =0;
        code = queryRunner.update(sql,student.getStudent_name(),student.getStudent_sex(),student.getStudent_birth(),student.getStudent_class(),student.getStudent_desc(),student.getStudent_id());
        return code;
    }

    @Override
    public int updateTeacher(Teacher teacher) throws SQLException {
        String sql = "update teacher set teacher_name=?,teacher_sex=?,teacher_birth=?,teacher_desc=? where teacher_id=?";
        int code = 0;
        code = queryRunner.update(sql,teacher.getTeacher_name(),teacher.getTeacher_sex(),teacher.getTeacher_birth(),teacher.getTeacher_desc(),teacher.getTeacher_id());
        return code;
    }

    @Override
    public List<AllEntity> findUser(User user, Pagination pagination) throws SQLException {
        String sql1="select * from user where 1=1 ";
        String sql=null ;
        AllEntity allEntity = null;
        List<AllEntity> allEntities = new ArrayList<>();
        if (StringUtil.isNotEmpty(user.getUser_id())) {
            sql1 +=" and user_id like '%"+user.getUser_id()+"%' ";
        }
        if(pagination.getCurPage() > 0 && pagination.getPageSize()>0){
            sql1+=" limit "+(pagination.getCurPage() - 1) * pagination.getPageSize()+","+pagination.getPageSize();
        }
        List<User> users = queryRunner.query(sql1,new BeanListHandler<User>(User.class));

        for (int i=0;i<users.size();i++) {
            if(users.get(i).getUser_level().equals("学生")){
                sql = "select * from user, student where user_id=student_id and  student_id='"+users.get(i).getUser_id()+"'";
            }else if(users.get(i).getUser_level().equals("教师")){
                sql = "select * from user,teacher where user_id=teacher_id and teacher_id='"+users.get(i).getUser_id()+"'";
            } else {
                continue;
            }
            allEntity = queryRunner.query(sql,new BeanHandler<AllEntity>(AllEntity.class));
            allEntities.add(allEntity);
        }
        return allEntities;
    }

    @Override
    public long findUserCount(User user) throws SQLException {
        String sql = "select count(*) from user where 1=1 ";

        if (StringUtil.isNotEmpty(user.getUser_id())) {
            sql +=" and user_id like '%"+user.getUser_id()+"%' ";
        }

        long total = 0;
        total = queryRunner.query(sql ,new ScalarHandler<Long>());
        return total;
    }

    @Override
    public int addUser(Register register) throws SQLException {
        String sql = "insert into user(user_id,user_password,user_level) values(?,?,?)";
        int code = 0;
        code = queryRunner.update(sql,register.getRegister_id(),register.getRegister_password(),register.getRegister_level());
        return code;
    }

    @Override
    public int addStudent(Register register) throws SQLException {
        String sql = "insert into student (student_id,student_name,student_sex,student_birth,student_class,student_desc) values(?,?,?,?,?,?)";
        int code = 0;
        code = queryRunner.update(sql,register.getRegister_id(),register.getRegister_name(),null,null,register.getRegister_class(),null);
        return code;
    }

    @Override
    public int addTeacher(Register register) throws SQLException {
        String sql = "insert into teacher (teacher_id,teacher_name,teacher_sex,teacher_birth,teacher_desc) values (?,?,?,?,?)";
        int code = 0;
        code = queryRunner.update(sql,register.getRegister_id(),register.getRegister_name(),null,null,null);
        return code;
    }

    @Override
    public int delUser(User user) throws SQLException {
        String sql = "delete from user where user_id =?";
        int code =queryRunner.execute(sql,user.getUser_id());
        return code;
    }

    @Override
    public List<AllEntity> getAllTeacher(Teacher teacher,Pagination pagination) throws SQLException {
        String sql = "select * from teacher,user where teacher_id = user_id ";
        if (StringUtil.isNotEmpty(teacher.getTeacher_id())) {
            sql +=" and teacher_id like '%"+teacher.getTeacher_id()+"%' ";
        }
        if(pagination.getCurPage() > 0 && pagination.getPageSize()>0){
            sql+=" limit "+(pagination.getCurPage() - 1) * pagination.getPageSize()+","+pagination.getPageSize();
        }
        List<AllEntity> teachers = queryRunner.query(sql,new BeanListHandler<AllEntity>(AllEntity.class));

        return teachers;
    }

    @Override
    public long teacherCount(Teacher teacher) throws SQLException {
        String sql = "select count(*) from teacher,user where teacher_id = user_id ";
        if (StringUtil.isNotEmpty(teacher.getTeacher_id())) {
            sql +=" and teacher_id like '%"+teacher.getTeacher_id()+"%' ";
        }
        long total = 0;
        total = queryRunner.query(sql ,new ScalarHandler<Long>());
        return total;
    }

    @Override
    public List<AllEntity> getAllStudent(Student student,Pagination pagination) throws SQLException {
        String sql = "select * from student, user where student_id = user_id ";

        if (StringUtil.isNotEmpty(student.getStudent_id())) {
            sql +=" and student_id like '%"+student.getStudent_id()+"%' ";
        }

        if(pagination.getCurPage() > 0 && pagination.getPageSize()>0){
            sql+=" limit "+(pagination.getCurPage() - 1) * pagination.getPageSize()+","+pagination.getPageSize();
        }
        List<AllEntity> students= queryRunner.query(sql,new BeanListHandler<AllEntity>(AllEntity.class));

        return students;
    }

    @Override
    public long studentCount(Student student) throws SQLException {
        String sql = "select count(*) from student , user where student_id = user_id ";
        if (StringUtil.isNotEmpty(student.getStudent_id())) {
            sql +=" and student_id like '%"+student.getStudent_id()+"%' ";
        }
        long total = 0;
        total = queryRunner.query(sql ,new ScalarHandler<Long>());
        return total;
    }

}
