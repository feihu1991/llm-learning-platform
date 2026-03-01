-- ============================================
-- 在线大模型学习平台 - 数据库设计
-- 创建时间：2026-03-01
-- ============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS llm_learning_platform
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE llm_learning_platform;

-- ============================================
-- 1. 用户表 (user)
-- ============================================
CREATE TABLE user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) UNIQUE NOT NULL COMMENT '用户名',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT '邮箱',
    password VARCHAR(255) NOT NULL COMMENT '密码（加密存储）',
    phone VARCHAR(20) COMMENT '手机号',
    avatar VARCHAR(255) COMMENT '头像URL',
    role ENUM('STUDENT', 'TEACHER', 'ADMIN') DEFAULT 'STUDENT' COMMENT '角色',
    status TINYINT DEFAULT 1 COMMENT '状态：1-正常，0-禁用',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ============================================
-- 2. 课程表 (course)
-- ============================================
CREATE TABLE course (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '课程ID',
    title VARCHAR(200) NOT NULL COMMENT '课程标题',
    description TEXT COMMENT '课程描述',
    cover_image VARCHAR(255) COMMENT '封面图片URL',
    category VARCHAR(50) COMMENT '课程分类',
    difficulty ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED') COMMENT '难度等级',
    duration INT DEFAULT 0 COMMENT '课程时长（分钟）',
    video_url VARCHAR(500) COMMENT '视频URL',
    content TEXT COMMENT '课程内容（Markdown）',
    status TINYINT DEFAULT 1 COMMENT '状态：1-上架，0-下架',
    created_by BIGINT COMMENT '创建者ID',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_category (category),
    INDEX idx_difficulty (difficulty),
    INDEX idx_status (status),
    INDEX idx_created_by (created_by),
    FOREIGN KEY (created_by) REFERENCES user(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程表';

-- ============================================
-- 3. 试题表 (question)
-- ============================================
CREATE TABLE question (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '试题ID',
    course_id BIGINT NOT NULL COMMENT '所属课程ID',
    type ENUM('SINGLE_CHOICE', 'MULTIPLE_CHOICE', 'TRUE_FALSE', 'FILL_BLANK', 'SHORT_ANSWER', 'CODE') NOT NULL COMMENT '试题类型',
    difficulty ENUM('EASY', 'MEDIUM', 'HARD') COMMENT '难度等级',
    content TEXT NOT NULL COMMENT '试题内容',
    options JSON COMMENT '选项（选择题）',
    correct_answer TEXT COMMENT '正确答案',
    explanation TEXT COMMENT '解析',
    tags VARCHAR(200) COMMENT '标签（逗号分隔）',
    score INT DEFAULT 10 COMMENT '分值',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_course_id (course_id),
    INDEX idx_type (type),
    INDEX idx_difficulty (difficulty),
    INDEX idx_tags (tags),
    FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试题表';

-- ============================================
-- 4. 用户答题记录表 (user_answer)
-- ============================================
CREATE TABLE user_answer (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '答题记录ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    question_id BIGINT NOT NULL COMMENT '试题ID',
    answer TEXT COMMENT '用户答案',
    score INT COMMENT '得分',
    status ENUM('PENDING', 'GRADED', 'CORRECT', 'INCORRECT') DEFAULT 'PENDING' COMMENT '状态',
    graded_by BIGINT COMMENT '评分人ID',
    graded_at DATETIME COMMENT '评分时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (user_id),
    INDEX idx_question_id (question_id),
    INDEX idx_status (status),
    INDEX idx_user_question (user_id, question_id),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE,
    FOREIGN KEY (graded_by) REFERENCES user(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户答题记录表';

-- ============================================
-- 5. 学习进度表 (learning_progress)
-- ============================================
CREATE TABLE learning_progress (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '进度ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    course_id BIGINT NOT NULL COMMENT '课程ID',
    progress INT DEFAULT 0 COMMENT '进度百分比',
    completed_at DATETIME COMMENT '完成时间',
    total_duration INT DEFAULT 0 COMMENT '总学习时长（分钟）',
    last_accessed DATETIME COMMENT '最后访问时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (user_id),
    INDEX idx_course_id (course_id),
    UNIQUE KEY uk_user_course (user_id, course_id),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习进度表';

-- ============================================
-- 6. 试题组卷表 (exam_paper)
-- ============================================
CREATE TABLE exam_paper (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '试卷ID',
    course_id BIGINT NOT NULL COMMENT '所属课程ID',
    title VARCHAR(200) NOT NULL COMMENT '试卷标题',
    description TEXT COMMENT '试卷描述',
    total_score INT DEFAULT 100 COMMENT '总分',
    duration INT DEFAULT 60 COMMENT '考试时长（分钟）',
    question_count INT DEFAULT 0 COMMENT '试题数量',
    status ENUM('DRAFT', 'PUBLISHED', 'ARCHIVED') DEFAULT 'DRAFT' COMMENT '状态',
    created_by BIGINT COMMENT '创建者ID',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_course_id (course_id),
    INDEX idx_status (status),
    INDEX idx_created_by (created_by),
    FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES user(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试题组卷表';

-- ============================================
-- 7. 试卷试题关联表 (exam_question)
-- ============================================
CREATE TABLE exam_question (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关联ID',
    exam_paper_id BIGINT NOT NULL COMMENT '试卷ID',
    question_id BIGINT NOT NULL COMMENT '试题ID',
    question_number INT COMMENT '题号',
    score INT COMMENT '分值',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_exam_paper_id (exam_paper_id),
    INDEX idx_question_id (question_id),
    UNIQUE KEY uk_exam_question (exam_paper_id, question_id),
    FOREIGN KEY (exam_paper_id) REFERENCES exam_paper(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试卷试题关联表';

-- ============================================
-- 8. 用户考试记录表 (user_exam)
-- ============================================
CREATE TABLE user_exam (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '考试记录ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    exam_paper_id BIGINT NOT NULL COMMENT '试卷ID',
    start_time DATETIME COMMENT '开始时间',
    end_time DATETIME COMMENT '结束时间',
    total_score INT COMMENT '总分',
    status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'GRADED') DEFAULT 'NOT_STARTED' COMMENT '状态',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (user_id),
    INDEX idx_exam_paper_id (exam_paper_id),
    INDEX idx_status (status),
    UNIQUE KEY uk_user_exam (user_id, exam_paper_id),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (exam_paper_id) REFERENCES exam_paper(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户考试记录表';

-- ============================================
-- 9. 学习笔记表 (user_note)
-- ============================================
CREATE TABLE user_note (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '笔记ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    course_id BIGINT COMMENT '课程ID',
    question_id BIGINT COMMENT '试题ID',
    content TEXT NOT NULL COMMENT '笔记内容',
    tags VARCHAR(200) COMMENT '标签',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (user_id),
    INDEX idx_course_id (course_id),
    INDEX idx_question_id (question_id),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户笔记表';

-- ============================================
-- 10. 学习成就表 (user_achievement)
-- ============================================
CREATE TABLE user_achievement (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '成就ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    achievement_type ENUM('COURSE_COMPLETE', 'EXAM_HIGH_SCORE', 'STREAK_LEARNING', 'CERTIFICATE') NOT NULL COMMENT '成就类型',
    achievement_name VARCHAR(100) NOT NULL COMMENT '成就名称',
    achievement_desc VARCHAR(200) COMMENT '成就描述',
    badge_image VARCHAR(255) COMMENT '徽章图片',
    achieved_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '获得时间',
    INDEX idx_user_id (user_id),
    INDEX idx_achievement_type (achievement_type),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户成就表';

-- ============================================
-- 11. 评分标准表 (grading_criteria)
-- ============================================
CREATE TABLE grading_criteria (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '标准ID',
    course_id BIGINT COMMENT '课程ID',
    question_type ENUM('SINGLE_CHOICE', 'MULTIPLE_CHOICE', 'TRUE_FALSE', 'FILL_BLANK', 'SHORT_ANSWER', 'CODE') NOT NULL COMMENT '试题类型',
    criteria_name VARCHAR(100) NOT NULL COMMENT '标准名称',
    criteria_desc TEXT COMMENT '标准描述',
    score_weight INT DEFAULT 100 COMMENT '分值权重',
    created_by BIGINT COMMENT '创建者ID',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_course_id (course_id),
    INDEX idx_question_type (question_type),
    FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES user(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评分标准表';

-- ============================================
-- 12. 系统配置表 (system_config)
-- ============================================
CREATE TABLE system_config (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '配置ID',
    config_key VARCHAR(100) UNIQUE NOT NULL COMMENT '配置键',
    config_value TEXT COMMENT '配置值',
    config_desc VARCHAR(200) COMMENT '配置描述',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

-- ============================================
-- 初始化数据
-- ============================================

-- 系统配置
INSERT INTO system_config (config_key, config_value, config_desc) VALUES
('site_name', '大模型学习平台', '网站名称'),
('site_description', '在线学习大模型开发的平台', '网站描述'),
('default_avatar', 'https://example.com/default-avatar.png', '默认头像'),
('max_upload_size', '10485760', '最大上传大小（10MB）'),
('exam_timeout', '3600', '考试超时时间（秒）'),
('auto_grade_enabled', '1', '是否启用自动评分');

-- 默认管理员账号（密码：admin123，需要在应用层加密）
INSERT INTO user (username, email, password, role, status) VALUES
('admin', 'admin@llm-learning.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', 'ADMIN', 1);

-- 默认课程分类
INSERT INTO course (title, description, category, difficulty, status) VALUES
('Python基础入门', '从零开始学习Python编程语言', '基础', 'BEGINNER', 1),
('机器学习入门', '机器学习基础概念和算法', '进阶', 'INTERMEDIATE', 1),
('大模型应用开发', '使用大模型API开发应用', '实战', 'ADVANCED', 1);

-- 默认试题（示例）
INSERT INTO question (course_id, type, difficulty, content, options, correct_answer, explanation, score) VALUES
(1, 'SINGLE_CHOICE', 'EASY', 'Python中定义函数的关键字是？', '{"A": "function", "B": "def", "C": "func", "D": "define"}', 'B', 'Python使用def关键字定义函数', 10),
(1, 'MULTIPLE_CHOICE', 'MEDIUM', 'Python中哪些是可变数据类型？', '{"A": "list", "B": "tuple", "C": "dict", "D": "set"}', 'A,C,D', 'list、dict、set是可变类型，tuple是不可变类型', 10),
(1, 'TRUE_FALSE', 'EASY', 'Python是编译型语言。', NULL, 'FALSE', 'Python是解释型语言', 10),
(1, 'FILL_BLANK', 'MEDIUM', 'Python中用于导入模块的关键词是______。', NULL, 'import', '使用import导入模块', 10),
(1, 'SHORT_ANSWER', 'MEDIUM', '请简述Python中列表和元组的区别。', NULL, '列表可变，元组不可变', '列表是可变序列，元组是不可变序列', 10),
(1, 'CODE', 'HARD', '请编写一个Python函数，计算两个数的和。', NULL, 'def add(a, b): return a + b', '函数定义正确，能计算两个数的和', 10);

-- ============================================
-- 视图和存储过程
-- ============================================

-- 用户学习进度视图
CREATE VIEW user_learning_progress_view AS
SELECT 
    u.id AS user_id,
    u.username,
    c.id AS course_id,
    c.title AS course_title,
    lp.progress,
    lp.total_duration,
    lp.last_accessed,
    lp.completed_at
FROM user u
LEFT JOIN learning_progress lp ON u.id = lp.user_id
LEFT JOIN course c ON lp.course_id = c.id;

-- 课程试题统计视图
CREATE VIEW course_question_stats_view AS
SELECT 
    c.id AS course_id,
    c.title AS course_title,
    COUNT(q.id) AS total_questions,
    SUM(CASE WHEN q.type = 'SINGLE_CHOICE' THEN 1 ELSE 0 END) AS single_choice_count,
    SUM(CASE WHEN q.type = 'MULTIPLE_CHOICE' THEN 1 ELSE 0 END) AS multiple_choice_count,
    SUM(CASE WHEN q.type = 'TRUE_FALSE' THEN 1 ELSE 0 END) AS true_false_count,
    SUM(CASE WHEN q.type = 'FILL_BLANK' THEN 1 ELSE 0 END) AS fill_blank_count,
    SUM(CASE WHEN q.type = 'SHORT_ANSWER' THEN 1 ELSE 0 END) AS short_answer_count,
    SUM(CASE WHEN q.type = 'CODE' THEN 1 ELSE 0 END) AS code_count,
    AVG(q.score) AS avg_score
FROM course c
LEFT JOIN question q ON c.id = q.course_id
GROUP BY c.id, c.title;

-- 用户成绩统计视图
CREATE VIEW user_exam_stats_view AS
SELECT 
    u.id AS user_id,
    u.username,
    ue.exam_paper_id,
    ep.title AS exam_title,
    ue.total_score,
    ue.status,
    ue.start_time,
    ue.end_time,
    DATEDIFF(ue.end_time, ue.start_time) AS days_taken
FROM user u
LEFT JOIN user_exam ue ON u.id = ue.user_id
LEFT JOIN exam_paper ep ON ue.exam_paper_id = ep.id;

-- ============================================
-- 索引优化
-- ============================================

-- 为常用查询添加复合索引
CREATE INDEX idx_user_course_progress ON learning_progress(user_id, course_id, progress);
CREATE INDEX idx_question_course_type ON question(course_id, type, difficulty);
CREATE INDEX idx_user_answer_user_question ON user_answer(user_id, question_id, status);
CREATE INDEX idx_user_exam_user_status ON user_exam(user_id, status, end_time);
CREATE INDEX idx_course_category_difficulty ON course(category, difficulty, status);

-- ============================================
-- 存储过程
-- ============================================

-- 计算用户课程完成度
DELIMITER //
CREATE PROCEDURE calculate_user_progress(IN user_id_param BIGINT, IN course_id_param BIGINT)
BEGIN
    DECLARE total_questions INT;
    DECLARE answered_questions INT;
    DECLARE correct_questions INT;
    DECLARE progress_percent INT;
    
    -- 计算总试题数
    SELECT COUNT(*) INTO total_questions 
    FROM question 
    WHERE course_id = course_id_param;
    
    -- 计算已答题数
    SELECT COUNT(*) INTO answered_questions 
    FROM user_answer 
    WHERE user_id = user_id_param 
    AND question_id IN (SELECT id FROM question WHERE course_id = course_id_param)
    AND status != 'PENDING';
    
    -- 计算正确题数
    SELECT COUNT(*) INTO correct_questions 
    FROM user_answer 
    WHERE user_id = user_id_param 
    AND question_id IN (SELECT id FROM question WHERE course_id = course_id_param)
    AND status = 'CORRECT';
    
    -- 计算进度百分比
    IF total_questions > 0 THEN
        SET progress_percent = (answered_questions * 100) / total_questions;
    ELSE
        SET progress_percent = 0;
    END IF;
    
    -- 更新学习进度
    INSERT INTO learning_progress (user_id, course_id, progress, last_accessed)
    VALUES (user_id_param, course_id_param, progress_percent, NOW())
    ON DUPLICATE KEY UPDATE 
        progress = progress_percent,
        last_accessed = NOW();
    
    -- 返回结果
    SELECT 
        total_questions,
        answered_questions,
        correct_questions,
        progress_percent;
END //
DELIMITER ;

-- 生成随机试题组卷
DELIMITER //
CREATE PROCEDURE generate_random_exam(
    IN course_id_param BIGINT,
    IN single_choice_count INT,
    IN multiple_choice_count INT,
    IN true_false_count INT,
    IN fill_blank_count INT,
    IN short_answer_count INT,
    IN code_count INT,
    IN exam_title VARCHAR(200)
)
BEGIN
    DECLARE exam_id BIGINT;
    DECLARE question_id BIGINT;
    DECLARE question_number INT DEFAULT 1;
    
    -- 创建试卷
    INSERT INTO exam_paper (course_id, title, total_score, duration, question_count, status, created_by)
    VALUES (course_id_param, exam_title, 
            (single_choice_count + multiple_choice_count + true_false_count + fill_blank_count + short_answer_count + code_count) * 10,
            60,
            (single_choice_count + multiple_choice_count + true_false_count + fill_blank_count + short_answer_count + code_count),
            'PUBLISHED',
            1);
    
    SET exam_id = LAST_INSERT_ID();
    
    -- 添加单选题
    IF single_choice_count > 0 THEN
        INSERT INTO exam_question (exam_paper_id, question_id, question_number, score)
        SELECT exam_id, id, question_number, 10
        FROM question 
        WHERE course_id = course_id_param AND type = 'SINGLE_CHOICE'
        ORDER BY RAND()
        LIMIT single_choice_count;
        SET question_number = question_number + single_choice_count;
    END IF;
    
    -- 添加多选题
    IF multiple_choice_count > 0 THEN
        INSERT INTO exam_question (exam_paper_id, question_id, question_number, score)
        SELECT exam_id, id, question_number, 10
        FROM question 
        WHERE course_id = course_id_param AND type = 'MULTIPLE_CHOICE'
        ORDER BY RAND()
        LIMIT multiple_choice_count;
        SET question_number = question_number + multiple_choice_count;
    END IF;
    
    -- 添加判断题
    IF true_false_count > 0 THEN
        INSERT INTO exam_question (exam_paper_id, question_id, question_number, score)
        SELECT exam_id, id, question_number, 10
        FROM question 
        WHERE course_id = course_id_param AND type = 'TRUE_FALSE'
        ORDER BY RAND()
        LIMIT true_false_count;
        SET question_number = question_number + true_false_count;
    END IF;
    
    -- 添加填空题
    IF fill_blank_count > 0 THEN
        INSERT INTO exam_question (exam_paper_id, question_id, question_number, score)
        SELECT exam_id, id, question_number, 10
        FROM question 
        WHERE course_id = course_id_param AND type = 'FILL_BLANK'
        ORDER BY RAND()
        LIMIT fill_blank_count;
        SET question_number = question_number + fill_blank_count;
    END IF;
    
    -- 添加简答题
    IF short_answer_count > 0 THEN
        INSERT INTO exam_question (exam_paper_id, question_id, question_number, score)
        SELECT exam_id, id, question_number, 10
        FROM question 
        WHERE course_id = course_id_param AND type = 'SHORT_ANSWER'
        ORDER BY RAND()
        LIMIT short_answer_count;
        SET question_number = question_number + short_answer_count;
    END IF;
    
    -- 添加代码题
    IF code_count > 0 THEN
        INSERT INTO exam_question (exam_paper_id, question_id, question_number, score)
        SELECT exam_id, id, question_number, 10
        FROM question 
        WHERE course_id = course_id_param AND type = 'CODE'
        ORDER BY RAND()
        LIMIT code_count;
        SET question_number = question_number + code_count;
    END IF;
    
    -- 返回试卷ID
    SELECT exam_id AS new_exam_id;
END //
DELIMITER ;

-- ============================================
-- 触发器
-- ============================================

-- 自动更新课程试题数量
DELIMITER //
CREATE TRIGGER update_course_question_count
AFTER INSERT ON question
FOR EACH ROW
BEGIN
    UPDATE course 
    SET updated_at = NOW()
    WHERE id = NEW.course_id;
END //
DELIMITER ;

-- 自动更新用户答题状态
DELIMITER //
CREATE TRIGGER update_user_answer_status
AFTER UPDATE ON user_answer
FOR EACH ROW
BEGIN
    IF NEW.status = 'CORRECT' THEN
        -- 可以在这里添加积分、成就等逻辑
        INSERT INTO user_achievement (user_id, achievement_type, achievement_name, achievement_desc)
        VALUES (NEW.user_id, 'EXAM_HIGH_SCORE', '答题正确', '回答问题正确');
    END IF;
END //
DELIMITER ;

-- ============================================
-- 数据备份和恢复脚本
-- ============================================

-- 备份命令（示例）
-- mysqldump -u root -p llm_learning_platform > backup_$(date +%Y%m%d).sql

-- 恢复命令（示例）
-- mysql -u root -p llm_learning_platform < backup_20260301.sql

-- ============================================
-- 性能优化建议
-- ============================================

-- 1. 定期清理历史数据
-- DELETE FROM user_answer WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- 2. 定期备份
-- 建议每天凌晨2点执行备份

-- 3. 索引维护
-- OPTIMIZE TABLE user, course, question, user_answer;

-- 4. 查询优化
-- 使用EXPLAIN分析慢查询

-- ============================================
-- 测试数据插入（可选）
-- ============================================

-- 插入测试用户
INSERT INTO user (username, email, password, role, status) VALUES
('test_student', 'student@test.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', 'STUDENT', 1),
('test_teacher', 'teacher@test.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9tYjKUiFjFO2/fG', 'TEACHER', 1);

-- 插入更多测试课程
INSERT INTO course (title, description, category, difficulty, status, created_by) VALUES
('深度学习基础', '神经网络和深度学习入门', '进阶', 'INTERMEDIATE', 1, 2),
('大模型API实战', '使用MiniMax API开发应用', '实战', 'ADVANCED', 1, 2),
('提示工程', '如何设计有效的提示词', '进阶', 'INTERMEDIATE', 1, 2),
('RAG技术', '检索增强生成技术详解', '进阶', 'INTERMEDIATE', 1, 2);

-- 插入更多测试试题
INSERT INTO question (course_id, type, difficulty, content, options, correct_answer, explanation, score) VALUES
(4, 'SINGLE_CHOICE', 'MEDIUM', '深度学习中，反向传播算法的作用是？', '{"A": "前向传播", "B": "计算梯度", "C": "更新权重", "D": "损失计算"}', 'B', '反向传播用于计算损失函数对参数的梯度', 10),
(4, 'MULTIPLE_CHOICE', 'HARD', '以下哪些是深度学习框架？', '{"A": "TensorFlow", "B": "PyTorch", "C": "Scikit-learn", "D": "Keras"}', 'A,B,D', 'Scikit-learn是传统机器学习库', 10),
(5, 'SHORT_ANSWER', 'MEDIUM', '请简述MiniMax API的主要功能。', NULL, '提供大模型API服务，支持文本生成、对话等', 'MiniMax提供大模型API服务', 10),
(6, 'CODE', 'HARD', '请编写一个Python函数，使用MiniMax API进行文本生成。', NULL, 'import requests; def generate_text(prompt): ...', '正确调用MiniMax API', 10);

-- 插入测试学习进度
INSERT INTO learning_progress (user_id, course_id, progress, total_duration, last_accessed) VALUES
(3, 1, 50, 120, NOW()),
(3, 2, 30, 60, NOW()),
(4, 1, 80, 200, NOW());

-- 插入测试答题记录
INSERT INTO user_answer (user_id, question_id, answer, score, status) VALUES
(3, 1, 'B', 10, 'CORRECT'),
(3, 2, 'A,C,D', 10, 'CORRECT'),
(3, 3, 'FALSE', 10, 'CORRECT'),
(3, 4, 'import', 10, 'CORRECT'),
(3, 5, '列表可变，元组不可变', 8, 'GRADED'),
(4, 1, 'B', 10, 'CORRECT'),
(4, 2, 'A,B,C', 0, 'INCORRECT');

-- 插入测试成就
INSERT INTO user_achievement (user_id, achievement_type, achievement_name, achievement_desc) VALUES
(3, 'COURSE_COMPLETE', 'Python入门完成', '完成Python基础入门课程'),
(3, 'EXAM_HIGH_SCORE', '高分通过', '考试获得90分以上'),
(3, 'STREAK_LEARNING', '连续学习7天', '连续学习7天');

-- ============================================
-- 数据库维护脚本
-- ============================================

-- 清理过期数据（每月执行一次）
-- DELETE FROM user_answer WHERE created_at < DATE_SUB(NOW(), INTERVAL 6 MONTH);
-- DELETE FROM user_exam WHERE end_time < DATE_SUB(NOW(), INTERVAL 6 MONTH);

-- 优化表（每周执行一次）
-- OPTIMIZE TABLE user, course, question, user_answer, learning_progress;

-- 检查数据完整性
-- SELECT 
--     '用户表' AS table_name,
--     COUNT(*) AS total_count,
--     COUNT(DISTINCT username) AS unique_usernames,
--     COUNT(DISTINCT email) AS unique_emails
-- FROM user
-- UNION ALL
-- SELECT 
--     '课程表',
--     COUNT(*),
--     COUNT(DISTINCT category),
--     COUNT(DISTINCT difficulty)
-- FROM course
-- UNION ALL
-- SELECT 
--     '试题表',
--     COUNT(*),
--     COUNT(DISTINCT course_id),
--     COUNT(DISTINCT type)
-- FROM question;

-- ============================================
-- 结束
-- ============================================
