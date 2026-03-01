package com.feihu.llm.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.feihu.llm.entity.User;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户Mapper接口
 * 
 * @author feihu1991
 * @version 1.0
 * @since 2026-03-01
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {
}
