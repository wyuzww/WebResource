package com.ethan.dao.impl;

import com.ethan.dao.RegisterDao;
import com.ethan.entity.Pagination;
import com.ethan.entity.Register;
import com.ethan.entity.User;
import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;

public class RegisterDaoImpl extends BaseDao implements RegisterDao {
    @Override
    public int userRegister(Register register) throws SQLException {
        String sql = "insert into register (register_id,register_password,register_name,register_class,register_level,register_check) values(?,?,?,?,?,?)";
        int code =0;
        code = queryRunner.update(sql,register.getRegister_id(),register.getRegister_password(),register.getRegister_name(),register.getRegister_class(),register.getRegister_level(),register.getRegister_check());
        return code;
    }

    @Override
    public boolean checkUser(User user) throws SQLException {
        User code =null;
        Register register=null;
        String sql1 = "select * from user where user_id = ?";
        String sql2 = "select * from register where register_id = ?";

        code = queryRunner.query(sql1,new BeanHandler<User>(User.class),user.getUser_id());
        register = queryRunner.query(sql2,new BeanHandler<Register>(Register.class),user.getUser_id());


        if (code == null && register == null) {
            return false;
        }
        return true;
    }


    @Override
    public List<Register> allRegister(Pagination pagination) throws SQLException {
        String sql = "select * from register where register_check = 0";
        if(pagination.getCurPage() > 0 && pagination.getPageSize()>0){
            sql+=" limit "+(pagination.getCurPage() - 1) * pagination.getPageSize()+","+pagination.getPageSize();
        }
        List<Register>registers = queryRunner.query(sql,new BeanListHandler<Register>(Register.class));
        return registers;
    }

    @Override
    public long registerCount() throws SQLException {
        String sql = "select count(*) from register where register_check = 0";
        long total = 0;
        total = queryRunner.query(sql ,new ScalarHandler<Long>());
        return total;
    }

    @Override
    public int updateRegister(Register register) throws SQLException {//审核通过后根据register_level自动插入到相应的表中（user、student||teacher）

        String sql = "update register set register_check=1 where register_id = ?";
        int code = 0;
        code = queryRunner.update(sql,register.getRegister_id());
        if(code!=0) {
            Register register1 =null;
            String sql1 = "select * from register where register_id =?";
            register1 = queryRunner.query(sql1,new BeanHandler<Register>(Register.class),register.getRegister_id());
            UserDaoImpl userDao = new UserDaoImpl();
            userDao.addUser(register1);
            if(register1.getRegister_level().equals("学生")){
                int code1= userDao.addStudent(register1);
                if (code1 != 0) {
                    System.out.println("插入学生成功！");
                    return code1;
                }else{
                    System.out.println("插入学生失败！");
                    return code1;
                }
            }
            else if(register1.getRegister_level().equals("教师")){
                int code2= userDao.addTeacher(register1);
                if (code2 != 0) {
                    System.out.println("插入教师成功！");
                    return code2;
                }else{
                    System.out.println("插入教师失败！");
                    return code2;
                }
            }
            else {

            }
        }
        return code;
    }

    @Override
    public int bulkImport(String filePath) throws SQLException {//批量导入用户数据到register表中（需要审核）
        Register register = new Register();
        int i=0;
        Sheet sheet;
        Workbook book;
        Cell cell1,cell2,cell3,cell4,cell5;
        try {
            book= Workbook.getWorkbook(new File(filePath));
            sheet=book.getSheet(0);
            int col  =sheet.getColumns();
            int row = sheet.getRows();
            i=0;
            if(col>0&&row>0) {
                while (i<row) {
                    //获取每一行的单元格
                    if (!sheet.getCell(0, i).getContents().equals("")) {
                        cell1 = sheet.getCell(0, i);//（列，行）帐号
                        cell2 = sheet.getCell(1, i);//密码
                        cell3 = sheet.getCell(2, i);//姓名
                        cell4 = sheet.getCell(3, i);//班级
                        cell5 = sheet.getCell(4, i);//权限
                        if (cell1.getContents().equals(""))//如果读取的数据为空
                        {
                            break;
                        }
                        register.setRegister_id(cell1.getContents());
                        register.setRegister_password(cell2.getContents());
                        register.setRegister_name(cell3.getContents());
                        register.setRegister_class(cell4.getContents());
                        register.setRegister_level(cell5.getContents());
                        register.setRegister_check(0);
                        RegisterDaoImpl registerDao = new RegisterDaoImpl();
                        User user = new User();
                        user.setUser_id(cell1.getContents());
                        if (!registerDao.checkUser(user)) {
                            registerDao.userRegister(register);
                            System.out.println(register);
                        }else {
                            System.out.println("已存在:"+cell1.getContents());
                        }
                        i++;
                    }
                }
            }
            book.close();
        }
        catch(Exception e)  {
            e.printStackTrace();
        }
        return i;
    }
}
