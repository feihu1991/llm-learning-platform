package com.feihu.llm.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.feihu.llm.entity.User;

/**
 * 用户Service接口
 * 
 * @author feihu1991
 * @version 1.0
 * @since 2026-03-01
 */
public interface UserService extends IService<User> {

    /**
     * 根据用户名查询用户
     * 
     * @param username 用户名
     * @return 用户对象
     */
    User findByUsername(String username);

    /**
     * 根据邮箱查询用户
     * 
     * @param email 邮箱
     * @return 用户对象
     */
    User findByEmail(String email);

    /**
     * 根据手机号查询用户
     * 
     * @param phone 手机号
     * @return 用户对象
     */
    User findByPhone(String phone);

    /**
     * 注册用户
     * 
     * @param user 用户对象
     * @return 是否成功
     */
    boolean register(User user);

    /**
     * 更新用户信息
     * 
     * @param user 用户对象
     * @return 是否成功
     */
    boolean updateUserInfo(User user);

    /**
     * 更新用户密码
     * 
     * @param userId 用户ID
     * @param oldPassword 旧密码
     * @param newPassword 新密码
     * @return 是否成功
     */
    boolean updatePassword(Long userId, String oldPassword, String newPassword);

    /**
     * 更新用户状态
     * 
     * @param userId 用户ID
     * @param status 状态
     * @return 是否成功
     */
    boolean updateStatus(Long userId, Integer status);

    /**
     * 更新用户角色
     * 
     * @param userId 用户ID
     * @param role 角色
     * @return 是否成功
     */
    boolean updateRole(Long userId, Integer role);

    /**
     * 更新学习时长
     * 
     * @param userId 用户ID
     * @param duration 时长（分钟）
     * @return 是否成功
     */
    boolean updateLearningDuration(Long userId, Long duration);

    /**
     * 更新积分
     * 
     * @param userId 用户ID
     * @param points 积分
     * @return 是否成功
     */
    boolean updatePoints(Long userId, Integer points);

    /**
     * 更新成就数
     * 
     * @param userId 用户ID
     * @param count 成就数
     * @return 是否成功
     */
    boolean updateAchievementCount(Long userId, Integer count);
}
