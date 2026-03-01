package com.feihu.llm.controller;

import com.feihu.llm.entity.User;
import com.feihu.llm.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * 用户Controller
 * 
 * @author feihu1991
 * @version 1.0
 * @since 2026-03-01
 */
@Slf4j
@RestController
@RequestMapping("/user")
@Api(tags = "用户管理")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 根据用户名查询用户
     */
    @GetMapping("/username/{username}")
    @ApiOperation(value = "根据用户名查询用户", notes = "根据用户名查询用户信息")
    public ResponseEntity<User> findByUsername(
            @ApiParam(value = "用户名", required = true)
            @PathVariable("username") @NotBlank(message = "用户名不能为空") String username) {
        User user = userService.findByUsername(username);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(user);
    }

    /**
     * 根据邮箱查询用户
     */
    @GetMapping("/email/{email}")
    @ApiOperation(value = "根据邮箱查询用户", notes = "根据邮箱查询用户信息")
    public ResponseEntity<User> findByEmail(
            @ApiParam(value = "邮箱", required = true)
            @PathVariable("email") @NotBlank(message = "邮箱不能为空") String email) {
        User user = userService.findByEmail(email);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(user);
    }

    /**
     * 根据手机号查询用户
     */
    @GetMapping("/phone/{phone}")
    @ApiOperation(value = "根据手机号查询用户", notes = "根据手机号查询用户信息")
    public ResponseEntity<User> findByPhone(
            @ApiParam(value = "手机号", required = true)
            @PathVariable("phone") @NotBlank(message = "手机号不能为空") String phone) {
        User user = userService.findByPhone(phone);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(user);
    }

    /**
     * 注册用户
     */
    @PostMapping("/register")
    @ApiOperation(value = "注册用户", notes = "用户注册")
    public ResponseEntity<String> register(
            @ApiParam(value = "用户信息", required = true)
            @Valid @RequestBody User user) {
        boolean success = userService.register(user);
        if (success) {
            return ResponseEntity.ok("注册成功");
        } else {
            return ResponseEntity.badRequest().body("注册失败，用户名或邮箱已存在");
        }
    }

    /**
     * 更新用户信息
     */
    @PutMapping("/info")
    @ApiOperation(value = "更新用户信息", notes = "更新用户基本信息")
    public ResponseEntity<String> updateUserInfo(
            @ApiParam(value = "用户信息", required = true)
            @Valid @RequestBody User user) {
        boolean success = userService.updateUserInfo(user);
        if (success) {
            return ResponseEntity.ok("更新成功");
        } else {
            return ResponseEntity.badRequest().body("更新失败");
        }
    }

    /**
     * 更新用户密码
     */
    @PutMapping("/password")
    @ApiOperation(value = "更新用户密码", notes = "更新用户密码")
    public ResponseEntity<String> updatePassword(
            @ApiParam(value = "用户ID", required = true)
            @RequestParam("userId") @NotNull(message = "用户ID不能为空") Long userId,
            @ApiParam(value = "旧密码", required = true)
            @RequestParam("oldPassword") @NotBlank(message = "旧密码不能为空") String oldPassword,
            @ApiParam(value = "新密码", required = true)
            @RequestParam("newPassword") @NotBlank(message = "新密码不能为空") String newPassword) {
        boolean success = userService.updatePassword(userId, oldPassword, newPassword);
        if (success) {
            return ResponseEntity.ok("密码更新成功");
        } else {
            return ResponseEntity.badRequest().body("密码更新失败");
        }
    }

    /**
     * 更新用户状态
     */
    @PutMapping("/status")
    @ApiOperation(value = "更新用户状态", notes = "更新用户状态")
    public ResponseEntity<String> updateStatus(
            @ApiParam(value = "用户ID", required = true)
            @RequestParam("userId") @NotNull(message = "用户ID不能为空") Long userId,
            @ApiParam(value = "状态", required = true)
            @RequestParam("status") @NotNull(message = "状态不能为空") Integer status) {
        boolean success = userService.updateStatus(userId, status);
        if (success) {
            return ResponseEntity.ok("状态更新成功");
        } else {
            return ResponseEntity.badRequest().body("状态更新失败");
        }
    }

    /**
     * 更新用户角色
     */
    @PutMapping("/role")
    @ApiOperation(value = "更新用户角色", notes = "更新用户角色")
    public ResponseEntity<String> updateRole(
            @ApiParam(value = "用户ID", required = true)
            @RequestParam("userId") @NotNull(message = "用户ID不能为空") Long userId,
            @ApiParam(value = "角色", required = true)
            @RequestParam("role") @NotNull(message = "角色不能为空") Integer role) {
        boolean success = userService.updateRole(userId, role);
        if (success) {
            return ResponseEntity.ok("角色更新成功");
        } else {
            return ResponseEntity.badRequest().body("角色更新失败");
        }
    }

    /**
     * 更新学习时长
     */
    @PutMapping("/learning-duration")
    @ApiOperation(value = "更新学习时长", notes = "更新用户学习时长")
    public ResponseEntity<String> updateLearningDuration(
            @ApiParam(value = "用户ID", required = true)
            @RequestParam("userId") @NotNull(message = "用户ID不能为空") Long userId,
            @ApiParam(value = "学习时长（分钟）", required = true)
            @RequestParam("duration") @NotNull(message = "学习时长不能为空") Long duration) {
        boolean success = userService.updateLearningDuration(userId, duration);
        if (success) {
            return ResponseEntity.ok("学习时长更新成功");
        } else {
            return ResponseEntity.badRequest().body("学习时长更新失败");
        }
    }

    /**
     * 更新积分
     */
    @PutMapping("/points")
    @ApiOperation(value = "更新积分", notes = "更新用户积分")
    public ResponseEntity<String> updatePoints(
            @ApiParam(value = "用户ID", required = true)
            @RequestParam("userId") @NotNull(message = "用户ID不能为空") Long userId,
            @ApiParam(value = "积分", required = true)
            @RequestParam("points") @NotNull(message = "积分不能为空") Integer points) {
        boolean success = userService.updatePoints(userId, points);
        if (success) {
            return ResponseEntity.ok("积分更新成功");
        } else {
            return ResponseEntity.badRequest().body("积分更新失败");
        }
    }

    /**
     * 更新成就数
     */
    @PutMapping("/achievement-count")
    @ApiOperation(value = "更新成就数", notes = "更新用户成就数")
    public ResponseEntity<String> updateAchievementCount(
            @ApiParam(value = "用户ID", required = true)
            @RequestParam("userId") @NotNull(message = "用户ID不能为空") Long userId,
            @ApiParam(value = "成就数", required = true)
            @RequestParam("count") @NotNull(message = "成就数不能为空") Integer count) {
        boolean success = userService.updateAchievementCount(userId, count);
        if (success) {
            return ResponseEntity.ok("成就数更新成功");
        } else {
            return ResponseEntity.badRequest().body("成就数更新失败");
        }
    }
}
