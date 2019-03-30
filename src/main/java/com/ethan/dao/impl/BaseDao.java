package com.ethan.dao.impl;


import com.ethan.factory.Factory;
import org.apache.commons.dbutils.QueryRunner;

public class BaseDao {
    QueryRunner queryRunner;

    BaseDao() {
        queryRunner = Factory.getQueryRunnerInstance();
    }
}
