package com.ethan.dbc;

import com.mchange.v2.c3p0.ComboPooledDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class C3P0Util {
    //不需要传参，会找c3p0配置文件中<default-config>默认配置
    private static ComboPooledDataSource dataSource = new ComboPooledDataSource();

    /**
     * getDataSource 获取数据源
     * @return dataSource
     */
    public static DataSource getDataSource(){
        return dataSource;
    }

    /**
     * getConnection 获取连接
     * @return dataSource.getConnection
     */
    public static Connection getConnection(){
        try {
            return dataSource.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException();
        }
    }

    /**
     * 关闭连接
     * @param conn
     */
    public static void close(Connection conn){
        if(conn!=null){
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

}
