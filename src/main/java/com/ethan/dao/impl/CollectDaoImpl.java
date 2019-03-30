package com.ethan.dao.impl;

import com.ethan.dao.CollectDao;
import com.ethan.entity.Collect;

import java.sql.SQLException;

public class CollectDaoImpl  extends BaseDao implements CollectDao {
    @Override
    public int addCollect(Collect collect) throws SQLException {
        String sql ="insert into collect(collect_uid,collect_rid) values(?,?)";
        int code = 0;
        code = queryRunner.update(sql,collect.getCollect_uid(),collect.getCollect_rid());
        return code;
    }

    @Override
    public int delCollect(Collect collect) throws SQLException {
        String sql = "delete from collect where collect_uid=? and collect_rid=?";
        int code =0;
        code = queryRunner.execute(sql,collect.getCollect_uid(),collect.getCollect_rid());
        return code;
    }
}
