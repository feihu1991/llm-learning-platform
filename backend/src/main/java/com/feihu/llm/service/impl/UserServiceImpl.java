package com.feihu.llm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.feihu.llm.entity.User;
import com.feihu.llm.mapper.UserMapper;
import com.feihu.llm.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

/**
 * 用户Service实现类
 * 
 * @author feihu1991
 * @version 1.0
 * @since 2026-03-01
 */
@Slf4j
@Service
@Transactional(rollbackFor = Exception.class)
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public User findByUsername(String username) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, username)
               .eq(User::getDeleted, 0);
        return baseMapper.selectOne(wrapper);
    }

    @Override
    public User findByEmail(String email) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getEmail, email)
               .eq(User::getDeleted, 0);
        return baseMapper.selectOne(wrapper);
    }

    @Override
    public User findByPhone(String phone) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getPhone, phone)
               .eq(User::getDeleted, 0);
        return baseMapper.selectOne(wrapper);
    }

    @Override
    public boolean register(User user) {
        // 检查用户名是否已存在
        User existingUser = findByUsername(user.getUsername());
        if (existingUser != null) {
            log.warn("用户名已存在: {}", user.getUsername());
            return false;
        }

        // 检查邮箱是否已存在
        if (user.getEmail() != null) {
            existingUser = findByEmail(user.getEmail());
            if (existingUser != null) {
                log.warn("邮箱已存在: {}", user.getEmail());
                return false;
            }
        }

        // 检查手机号是否已存在
        if (user.getPassword() != null) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        }

        // 设置默认值
        user.setStatus(1); // 正常状态
        user.setRole(0); // 普通用户
        user.setLearningDuration(0L); // 学习时长为0
        user.setPoints(0); // 积分为0
        user.setAchievementCount(0); // 成就数为0
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        user.setDeleted(0);

        int result = baseMapper.insert(user);
        log.info("用户注册成功: {}", user.getUsername());
        return result > 0;
    }

    @Override
    public boolean updateUserInfo(User user) {
        if (user.getId() == null) {
            log.warn("用户ID不能为空");
            return false;
        }

        user.setUpdateTime(LocalDateTime.now());
        int result = baseMapper.updateById(user);
        log.info("用户信息更新成功: {}", user.getId());
        return result > 0;
    }

    @Override
    public boolean updatePassword(Long userId, String oldPassword, String newPassword) {
        User user = baseMapper.selectById(userId);
        if (user == null) {
            log.warn("用户不存在: {}", userId);
            return false;
        }

        // 验证旧密码
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            log.warn("旧密码错误: {}", userId);
            return false;
        }

        // 更新密码
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdateTime(LocalDateTime.now());
        int result = baseMapper.updateById(user);
        log.info("用户密码更新成功: {}", userId);
        return result > 0;
    }

    @Override
    public boolean updateStatus(Long userId, Integer status) {
        User user = new User();
        user.setId(userId);
        user.setStatus(status);
        user.setUpdateTime(LocalDateTime.now());
        int result = baseMapper.updateById(user);
        log.info("用户状态更新成功: {}, 状态: {}", userId, status);
        return result > 0;
    }

    @Override
    public boolean updateRole(Long userId, Integer role) {
        User user = new User();
        user.setId(userId);
        user.setRole(role);
        user.setUpdateTime(LocalDateTime.now());
        int result = baseMapper.updateById(user);
        log.info("用户角色更新成功: {}, 角色: {}", userId, role);
        return result > 0;
    }

    @Override
    public boolean updateLearningDuration(Long userId, Long duration) {
        User user = new User();
        user.setId(userId);
        user.setLearningDuration(duration);
        user.setUpdateTime(LocalDateTime.now());
        int result = baseMapper.updateById(user);
        log.info("用户学习时长更新成功: {}, 时长: {}分钟", userId, duration);
        return result > 0;
    }

    @Override
    public boolean updatePoints(Long userId, Integer points) {
        User user = new User();
        user.setId(userId);
        user.setPoints(points);
        user.setUpdateTime(LocalDateTime.now());
        int result = baseMapper.updateById(user);
        log.info("用户积分更新成功: {}, 积分: {}", userId, points);
        return result > 0;
    }

    @Override
    public boolean updateAchievementCount(Long userId, Integer count) {
        User user = new User();
        user.setId(userId);
        user.setAchievementCount(count);
        user.setUpdateTime(LocalDateTime.now());
        int result = baseMapper.updateById(user);
        log.info("用户成就数更新成功: {}, 成就数: {}", userId, count);
        return result > 0;
    }
}
