-- 在线大模型学习平台 - 数据库初始化脚本
-- 创建时间：2026-03-01
-- 作者：feihu1991

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `llm_learning_platform` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `llm_learning_platform`;

-- 1. 用户表
CREATE TABLE IF NOT EXISTS `user` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码（加密后）',
  `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `gender` TINYINT(1) DEFAULT 0 COMMENT '性别：0-未知，1-男，2-女',
  `birthday` DATETIME DEFAULT NULL COMMENT '生日',
  `bio` VARCHAR(500) DEFAULT NULL COMMENT '个人简介',
  `status` TINYINT(1) DEFAULT 1 COMMENT '用户状态：0-禁用，1-正常',
  `role` TINYINT(1) DEFAULT 0 COMMENT '用户角色：0-普通用户，1-管理员',
  `learning_duration` BIGINT(20) DEFAULT 0 COMMENT '学习时长（分钟）',
  `points` INT(11) DEFAULT 0 COMMENT '积分',
  `achievement_count` INT(11) DEFAULT 0 COMMENT '成就数',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '删除标记：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  UNIQUE KEY `uk_phone` (`phone`),
  KEY `idx_status` (`status`),
  KEY `idx_role` (`role`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 2. 课程表
CREATE TABLE IF NOT EXISTS `course` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `title` VARCHAR(200) NOT NULL COMMENT '课程标题',
  `description` VARCHAR(1000) DEFAULT NULL COMMENT '课程描述',
  `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '封面图片URL',
  `difficulty` TINYINT(1) DEFAULT 1 COMMENT '难度：1-简单，2-中等，3-困难',
  `duration` INT(11) DEFAULT 0 COMMENT '课程时长（分钟）',
  `video_url` VARCHAR(500) DEFAULT NULL COMMENT '视频URL',
  `content` LONGTEXT DEFAULT NULL COMMENT '课程内容（Markdown格式）',
  `status` TINYINT(1) DEFAULT 1 COMMENT '课程状态：0-草稿，1-已发布，2-已下架',
  `category_id` BIGINT(20) DEFAULT NULL COMMENT '分类ID',
  `category_name` VARCHAR(50) DEFAULT NULL COMMENT '分类名称',
  `teacher_id` BIGINT(20) DEFAULT NULL COMMENT '讲师ID',
  `teacher_name` VARCHAR(50) DEFAULT NULL COMMENT '讲师名称',
  `student_count` INT(11) DEFAULT 0 COMMENT '学生数量',
  `rating` DECIMAL(3,2) DEFAULT 0.00 COMMENT '评分',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '删除标记：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_teacher` (`teacher_id`),
  KEY `idx_status` (`status`),
  KEY `idx_difficulty` (`difficulty`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程表';

-- 3. 试题表
CREATE TABLE IF NOT EXISTS `question` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '试题ID',
  `type` TINYINT(1) NOT NULL COMMENT '试题类型：1-单选题，2-多选题，3-判断题，4-填空题，5-简答题，6-代码题',
  `content` TEXT NOT NULL COMMENT '试题内容',
  `options` JSON DEFAULT NULL COMMENT '选项（JSON格式）',
  `correct_answer` VARCHAR(500) DEFAULT NULL COMMENT '正确答案',
  `difficulty` TINYINT(1) DEFAULT 1 COMMENT '难度：1-简单，2-中等，3-困难',
  `score` INT(11) DEFAULT 10 COMMENT '分值',
  `explanation` TEXT DEFAULT NULL COMMENT '解析',
  `tags` JSON DEFAULT NULL COMMENT '标签（JSON格式）',
  `course_id` BIGINT(20) DEFAULT NULL COMMENT '课程ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '删除标记：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_type` (`type`),
  KEY `idx_difficulty` (`difficulty`),
  KEY `idx_course` (`course_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试题表';

-- 4. 用户答题记录表
CREATE TABLE IF NOT EXISTS `user_answer` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID',
  `question_id` BIGINT(20) NOT NULL COMMENT '试题ID',
  `answer` VARCHAR(500) DEFAULT NULL COMMENT '用户答案',
  `score` INT(11) DEFAULT 0 COMMENT '得分',
  `is_correct` TINYINT(1) DEFAULT 0 COMMENT '是否正确：0-错误，1-正确',
  `exam_paper_id` BIGINT(20) DEFAULT NULL COMMENT '试卷ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '删除标记：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_question` (`question_id`),
  KEY `idx_exam_paper` (`exam_paper_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户答题记录表';

-- 5. 学习进度表
CREATE TABLE IF NOT EXISTS `learning_progress` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '进度ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID',
  `course_id` BIGINT(20) NOT NULL COMMENT '课程ID',
  `progress` INT(11) DEFAULT 0 COMMENT '进度百分比',
  `last_study_time` DATETIME DEFAULT NULL COMMENT '最后学习时间',
  `study_duration` INT(11) DEFAULT 0 COMMENT '学习时长（分钟）',
  `is_completed` TINYINT(1) DEFAULT 0 COMMENT '是否完成：0-未完成，1-已完成',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '删除标记：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_course` (`user_id`, `course_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_course` (`course_id`),
  KEY `idx_is_completed` (`is_completed`),
  KEY `idx_last_study_time` (`last_study_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习进度表';

-- 6. 试卷表
CREATE TABLE IF NOT EXISTS `exam_paper` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '试卷ID',
  `title` VARCHAR(200) NOT NULL COMMENT '试卷标题',
  `course_id` BIGINT(20) DEFAULT NULL COMMENT '课程ID',
  `course_name` VARCHAR(200) DEFAULT NULL COMMENT '课程名称',
  `difficulty` TINYINT(1) DEFAULT 1 COMMENT '难度：1-简单，2-中等，3-困难',
  `duration` INT(11) DEFAULT 60 COMMENT '考试时长（分钟）',
  `total_score` INT(11) DEFAULT 100 COMMENT '总分',
  `question_count` INT(11) DEFAULT 0 COMMENT '试题数量',
  `pass_score` INT(11) DEFAULT 60 COMMENT '及格分数',
  `status` TINYINT(1) DEFAULT 1 COMMENT '试卷状态：0-草稿，1-已发布，2-已下架',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '删除标记：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_course` (`course_id`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试卷表';

-- 7. 用户考试记录表
CREATE TABLE IF NOT EXISTS `user_exam` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID',
  `exam_paper_id` BIGINT(20) NOT NULL COMMENT '试卷ID',
  `total_score` INT(11) DEFAULT 0 COMMENT '总分',
  `user_score` INT(11) DEFAULT 0 COMMENT '用户得分',
  `pass_score` INT(11) DEFAULT 0 COMMENT '及格分数',
  `is_passed` TINYINT(1) DEFAULT 0 COMMENT '是否通过：0-未通过，1-通过',
  `duration` INT(11) DEFAULT 0 COMMENT '考试时长（秒）',
  `start_time` DATETIME DEFAULT NULL COMMENT '开始时间',
  `end_time` DATETIME DEFAULT NULL COMMENT '结束时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '删除标记：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_exam_paper` (`exam_paper_id`),
  KEY `idx_is_passed` (`is_passed`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户考试记录表';

-- 8. 用户笔记表
CREATE TABLE IF NOT EXISTS `user_note` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '笔记ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID',
  `course_id` BIGINT(20) DEFAULT NULL COMMENT '课程ID',
  `title` VARCHAR(200) NOT NULL COMMENT '笔记标题',
  `content` LONGTEXT NOT NULL COMMENT '笔记内容',
  `tags` JSON DEFAULT NULL COMMENT '标签（JSON格式）',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '删除标记：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_course` (`course_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户笔记表';

-- 9. 用户成就表
CREATE TABLE IF NOT EXISTS `user_achievement` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '成就ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID',
  `achievement_type` TINYINT(1) NOT NULL COMMENT '成就类型：1-学习时长，2-完成课程，3-考试通过，4-获得积分',
  `achievement_value` INT(11) DEFAULT 0 COMMENT '成就值',
  `achievement_name` VARCHAR(100) NOT NULL COMMENT '成就名称',
  `achievement_desc` VARCHAR(500) DEFAULT NULL COMMENT '成就描述',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '获得时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '删除标记：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_type` (`achievement_type`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户成就表';

-- 10. 评分标准表
CREATE TABLE IF NOT EXISTS `grading_criteria` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '标准ID',
  `question_id` BIGINT(20) NOT NULL COMMENT '试题ID',
  `criteria_type` TINYINT(1) NOT NULL COMMENT '标准类型：1-关键词，2-代码规范，3-逻辑正确',
  `criteria_content` TEXT NOT NULL COMMENT '标准内容',
  `score_weight` DECIMAL(5,2) DEFAULT 1.00 COMMENT '分值权重',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '删除标记：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_question` (`question_id`),
  KEY `idx_type` (`criteria_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评分标准表';

-- 11. 系统配置表
CREATE TABLE IF NOT EXISTS `system_config` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` VARCHAR(100) NOT NULL COMMENT '配置键',
  `config_value` TEXT DEFAULT NULL COMMENT '配置值',
  `config_desc` VARCHAR(500) DEFAULT NULL COMMENT '配置描述',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '删除标记：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

-- 12. 试卷试题关联表
CREATE TABLE IF NOT EXISTS `exam_question` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `exam_paper_id` BIGINT(20) NOT NULL COMMENT '试卷ID',
  `question_id` BIGINT(20) NOT NULL COMMENT '试题ID',
  `question_order` INT(11) DEFAULT 0 COMMENT '试题顺序',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '删除标记：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_exam_question` (`exam_paper_id`, `question_id`),
  KEY `idx_exam_paper` (`exam_paper_id`),
  KEY `idx_question` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试卷试题关联表';

-- 插入测试数据
-- 插入管理员用户
INSERT INTO `user` (`username`, `password`, `nickname`, `email`, `status`, `role`, `create_time`, `update_time`) 
VALUES ('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '管理员', 'admin@llm-learning.com', 1, 1, NOW(), NOW());

-- 插入普通用户
INSERT INTO `user` (`username`, `password`, `nickname`, `email`, `status`, `role`, `create_time`, `update_time`) 
VALUES ('testuser', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', '测试用户', 'test@llm-learning.com', 1, 0, NOW(), NOW());

-- 插入课程分类
INSERT INTO `system_config` (`config_key`, `config_value`, `config_desc`) VALUES
('course_category', '[{"id":1,"name":"大模型基础","description":"大模型基础知识"},{"id":2,"name":"机器学习","description":"机器学习算法"},{"id":3,"name":"深度学习","description":"深度学习技术"},{"id":4,"name":"大模型应用","description":"大模型应用开发"},{"id":5,"name":"实战项目","description":"实战项目开发"}]', '课程分类配置');

-- 插入测试课程
INSERT INTO `course` (`title`, `description`, `cover_image`, `difficulty`, `duration`, `status`, `category_id`, `category_name`, `teacher_id`, `teacher_name`, `student_count`, `rating`) VALUES
('大模型基础入门', '从零开始学习大模型基础知识，了解大模型的原理和应用场景', 'https://example.com/course1.jpg', 1, 120, 1, 1, '大模型基础', 1, '张老师', 100, 4.5),
('机器学习基础', '学习机器学习的基本概念、算法和应用', 'https://example.com/course2.jpg', 2, 180, 1, 2, '机器学习', 1, '张老师', 80, 4.3),
('深度学习实战', '通过实战项目学习深度学习技术', 'https://example.com/course3.jpg', 3, 240, 1, 3, '深度学习', 1, '张老师', 60, 4.7);

-- 插入测试试题
INSERT INTO `question` (`type`, `content`, `options`, `correct_answer`, `difficulty`, `score`, `explanation`, `tags`, `course_id`) VALUES
(1, '以下哪个是大模型？', '["GPT-3", "ResNet", "SVM", "K-Means"]', 'GPT-3', 1, 10, 'GPT-3是OpenAI开发的大语言模型', '["大模型", "GPT"]', 1),
(2, '以下哪些是深度学习框架？', '["TensorFlow", "PyTorch", "Scikit-learn", "Pandas"]', 'TensorFlow,PyTorch', 2, 15, 'TensorFlow和PyTorch是主流深度学习框架', '["深度学习", "框架"]', 3),
(3, 'Transformer模型是Google在2017年提出的。', NULL, '正确', 1, 5, 'Transformer模型在2017年论文《Attention is All You Need》中提出', '["Transformer", "注意力"]', 1);

-- 插入测试试卷
INSERT INTO `exam_paper` (`title`, `course_id`, `course_name`, `difficulty`, `duration`, `total_score`, `question_count`, `pass_score`, `status`) VALUES
('大模型基础测试', 1, '大模型基础入门', 1, 60, 100, 3, 60, 1);

-- 插入试卷试题关联
INSERT INTO `exam_question` (`exam_paper_id`, `question_id`, `question_order`) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3);

-- 插入系统配置
INSERT INTO `system_config` (`config_key`, `config_value`, `config_desc`) VALUES
('system_name', '在线大模型学习平台', '系统名称'),
('system_version', '1.0.0', '系统版本'),
('system_description', '一个专注于大模型开发学习的在线平台', '系统描述'),
('system_author', 'feihu1991', '系统作者'),
('system_email', '115920877@qq.com', '系统邮箱'),
('system_website', 'https://github.com/feihu1991/llm-learning-platform', '系统网站'),
('points_per_minute', '1', '每分钟学习获得的积分'),
('points_per_course', '50', '完成课程获得的积分'),
('points_per_exam_pass', '30', '考试通过获得的积分'),
('achievement_thresholds', '{"learning_duration": [100, 500, 1000, 5000], "completed_courses": [1, 5, 10, 20], "exam_passed": [1, 5, 10, 20], "points": [100, 500, 1000, 5000]}', '成就阈值配置');

-- 创建视图
-- 用户学习统计视图
CREATE OR REPLACE VIEW `user_learning_stats` AS
SELECT 
    u.id AS user_id,
    u.username,
    u.nickname,
    u.learning_duration,
    u.points,
    u.achievement_count,
    COUNT(DISTINCT lp.course_id) AS completed_courses,
    COUNT(DISTINCT ue.id) AS passed_exams,
    AVG(ue.user_score) AS avg_exam_score
FROM 
    user u
LEFT JOIN 
    learning_progress lp ON u.id = lp.user_id AND lp.is_completed = 1
LEFT JOIN 
    user_exam ue ON u.id = ue.user_id AND ue.is_passed = 1
WHERE 
    u.deleted = 0
GROUP BY 
    u.id, u.username, u.nickname, u.learning_duration, u.points, u.achievement_count;

-- 课程统计视图
CREATE OR REPLACE VIEW `course_stats` AS
SELECT 
    c.id AS course_id,
    c.title,
    c.category_name,
    c.teacher_name,
    c.student_count,
    c.rating,
    c.difficulty,
    COUNT(DISTINCT lp.user_id) AS active_students,
    AVG(lp.progress) AS avg_progress,
    COUNT(DISTINCT q.id) AS question_count
FROM 
    course c
LEFT JOIN 
    learning_progress lp ON c.id = lp.course_id AND lp.deleted = 0
LEFT JOIN 
    question q ON c.id = q.course_id AND q.deleted = 0
WHERE 
    c.deleted = 0
GROUP BY 
    c.id, c.title, c.category_name, c.teacher_name, c.student_count, c.rating, c.difficulty;

-- 创建存储过程
-- 更新用户学习时长和积分
DELIMITER //
CREATE PROCEDURE UpdateUserLearningStats(
    IN p_user_id BIGINT,
    IN p_duration INT,
    IN p_points_per_minute INT
)
BEGIN
    DECLARE v_total_duration BIGINT;
    DECLARE v_total_points INT;
    
    -- 获取当前学习时长和积分
    SELECT learning_duration, points INTO v_total_duration, v_total_points
    FROM user WHERE id = p_user_id;
    
    -- 更新学习时长
    SET v_total_duration = v_total_duration + p_duration;
    
    -- 计算新增积分
    SET v_total_points = v_total_points + (p_duration * p_points_per_minute);
    
    -- 更新用户数据
    UPDATE user 
    SET learning_duration = v_total_duration,
        points = v_total_points,
        update_time = NOW()
    WHERE id = p_user_id;
    
    -- 检查是否触发成就
    CALL CheckAchievements(p_user_id);
END //
DELIMITER ;

-- 检查成就存储过程
DELIMITER //
CREATE PROCEDURE CheckAchievements(
    IN p_user_id BIGINT
)
BEGIN
    DECLARE v_learning_duration BIGINT;
    DECLARE v_completed_courses INT;
    DECLARE v_passed_exams INT;
    DECLARE v_points INT;
    DECLARE v_achievement_count INT;
    
    -- 获取用户统计数据
    SELECT learning_duration, points INTO v_learning_duration, v_points
    FROM user WHERE id = p_user_id;
    
    SELECT COUNT(*) INTO v_completed_courses
    FROM learning_progress 
    WHERE user_id = p_user_id AND is_completed = 1 AND deleted = 0;
    
    SELECT COUNT(*) INTO v_passed_exams
    FROM user_exam 
    WHERE user_id = p_user_id AND is_passed = 1 AND deleted = 0;
    
    -- 获取成就阈值
    SELECT achievement_count INTO v_achievement_count
    FROM user WHERE id = p_user_id;
    
    -- 检查学习时长成就
    IF v_learning_duration >= 100 AND NOT EXISTS (
        SELECT 1 FROM user_achievement 
        WHERE user_id = p_user_id AND achievement_type = 1 AND achievement_value = 100
    ) THEN
        INSERT INTO user_achievement (user_id, achievement_type, achievement_value, achievement_name, achievement_desc)
        VALUES (p_user_id, 1, 100, '学习达人', '累计学习100分钟');
        SET v_achievement_count = v_achievement_count + 1;
    END IF;
    
    IF v_learning_duration >= 500 AND NOT EXISTS (
        SELECT 1 FROM user_achievement 
        WHERE user_id = p_user_id AND achievement_type = 1 AND achievement_value = 500
    ) THEN
        INSERT INTO user_achievement (user_id, achievement_type, achievement_value, achievement_name, achievement_desc)
        VALUES (p_user_id, 1, 500, '学习大师', '累计学习500分钟');
        SET v_achievement_count = v_achievement_count + 1;
    END IF;
    
    -- 检查课程完成成就
    IF v_completed_courses >= 1 AND NOT EXISTS (
        SELECT 1 FROM user_achievement 
        WHERE user_id = p_user_id AND achievement_type = 2 AND achievement_value = 1
    ) THEN
        INSERT INTO user_achievement (user_id, achievement_type, achievement_value, achievement_name, achievement_desc)
        VALUES (p_user_id, 2, 1, '初学者', '完成第一门课程');
        SET v_achievement_count = v_achievement_count + 1;
    END IF;
    
    IF v_completed_courses >= 5 AND NOT EXISTS (
        SELECT 1 FROM user_achievement 
        WHERE user_id = p_user_id AND achievement_type = 2 AND achievement_value = 5
    ) THEN
        INSERT INTO user_achievement (user_id, achievement_type, achievement_value, achievement_name, achievement_desc)
        VALUES (p_user_id, 2, 5, '学习者', '完成5门课程');
        SET v_achievement_count = v_achievement_count + 1;
    END IF;
    
    -- 检查考试通过成就
    IF v_passed_exams >= 1 AND NOT EXISTS (
        SELECT 1 FROM user_achievement 
        WHERE user_id = p_user_id AND achievement_type = 3 AND achievement_value = 1
    ) THEN
        INSERT INTO user_achievement (user_id, achievement_type, achievement_value, achievement_name, achievement_desc)
        VALUES (p_user_id, 3, 1, '考试通过', '通过第一次考试');
        SET v_achievement_count = v_achievement_count + 1;
    END IF;
    
    IF v_passed_exams >= 5 AND NOT EXISTS (
        SELECT 1 FROM user_achievement 
        WHERE user_id = p_user_id AND achievement_type = 3 AND achievement_value = 5
    ) THEN
        INSERT INTO user_achievement (user_id, achievement_type, achievement_value, achievement_name, achievement_desc)
        VALUES (p_user_id, 3, 5, '考试高手', '通过5次考试');
        SET v_achievement_count = v_achievement_count + 1;
    END IF;
    
    -- 检查积分成就
    IF v_points >= 100 AND NOT EXISTS (
        SELECT 1 FROM user_achievement 
        WHERE user_id = p_user_id AND achievement_type = 4 AND achievement_value = 100
    ) THEN
        INSERT INTO user_achievement (user_id, achievement_type, achievement_value, achievement_name, achievement_desc)
        VALUES (p_user_id, 4, 100, '积分达人', '获得100积分');
        SET v_achievement_count = v_achievement_count + 1;
    END IF;
    
    IF v_points >= 500 AND NOT EXISTS (
        SELECT 1 FROM user_achievement 
        WHERE user_id = p_user_id AND achievement_type = 4 AND achievement_value = 500
    ) THEN
        INSERT INTO user_achievement (user_id, achievement_type, achievement_value, achievement_name, achievement_desc)
        VALUES (p_user_id, 4, 500, '积分大师', '获得500积分');
        SET v_achievement_count = v_achievement_count + 1;
    END IF;
    
    -- 更新用户成就数
    UPDATE user SET achievement_count = v_achievement_count WHERE id = p_user_id;
END //
DELIMITER ;

-- 创建触发器
-- 自动更新课程学生数
DELIMITER //
CREATE TRIGGER update_course_student_count
AFTER INSERT ON learning_progress
FOR EACH ROW
BEGIN
    UPDATE course 
    SET student_count = (
        SELECT COUNT(DISTINCT user_id) 
        FROM learning_progress 
        WHERE course_id = NEW.course_id AND deleted = 0
    )
    WHERE id = NEW.course_id;
END //
DELIMITER ;

-- 自动更新课程评分
DELIMITER //
CREATE TRIGGER update_course_rating
AFTER INSERT ON user_exam
FOR EACH ROW
BEGIN
    UPDATE course c
    SET rating = (
        SELECT AVG(user_score) 
        FROM user_exam ue
        JOIN exam_paper ep ON ue.exam_paper_id = ep.id
        WHERE ep.course_id = c.id AND ue.deleted = 0
    )
    WHERE c.id = (
        SELECT course_id 
        FROM exam_paper 
        WHERE id = NEW.exam_paper_id
    );
END //
DELIMITER ;

-- 自动更新试卷试题数量
DELIMITER //
CREATE TRIGGER update_exam_question_count
AFTER INSERT ON exam_question
FOR EACH ROW
BEGIN
    UPDATE exam_paper 
    SET question_count = (
        SELECT COUNT(*) 
        FROM exam_question 
        WHERE exam_paper_id = NEW.exam_paper_id AND deleted = 0
    )
    WHERE id = NEW.exam_paper_id;
END //
DELIMITER ;

-- 创建索引优化查询
-- 用户表索引
CREATE INDEX idx_user_status_role ON user(status, role);
CREATE INDEX idx_user_learning_duration ON user(learning_duration);
CREATE INDEX idx_user_points ON user(points);

-- 课程表索引
CREATE INDEX idx_course_status_category ON course(status, category_id);
CREATE INDEX idx_course_difficulty ON course(difficulty);
CREATE INDEX idx_course_rating ON course(rating);

-- 试题表索引
CREATE INDEX idx_question_type_difficulty ON question(type, difficulty);
CREATE INDEX idx_question_course ON question(course_id);

-- 学习进度表索引
CREATE INDEX idx_learning_progress_user_course ON learning_progress(user_id, course_id);
CREATE INDEX idx_learning_progress_completed ON learning_progress(is_completed);
CREATE INDEX idx_learning_progress_duration ON learning_progress(study_duration);

-- 试卷表索引
CREATE INDEX idx_exam_paper_status ON exam_paper(status);
CREATE INDEX idx_exam_paper_difficulty ON exam_paper(difficulty);

-- 用户考试记录表索引
CREATE INDEX idx_user_exam_user ON user_exam(user_id);
CREATE INDEX idx_user_exam_passed ON user_exam(is_passed);
CREATE INDEX idx_user_exam_score ON user_exam(user_score);

-- 完成初始化
SELECT '数据库初始化完成！' AS message;
