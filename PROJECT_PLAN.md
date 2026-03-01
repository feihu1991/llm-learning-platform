# 在线大模型学习平台 - 项目计划

## 📋 项目概述

**项目名称**：在线大模型学习平台

**项目目标**：创建一个Web平台，提供大模型相关的在线课程学习，每个课程包含丰富的试题和自动评分系统。

**目标用户**：Java开发者转型大模型开发的学习者

**技术栈**：
- 前端：Vue 3 + TypeScript + Element Plus
- 后端：Spring Boot + MyBatis Plus
- 数据库：MySQL 8.0
- 缓存：Redis
- 部署：Docker + Nginx

---

## 🎯 核心功能

### 1. 用户管理模块
- [ ] 用户注册/登录
- [ ] 个人信息管理
- [ ] 学习进度追踪
- [ ] 学习历史记录

### 2. 课程管理模块
- [ ] 课程分类（基础、进阶、实战）
- [ ] 课程列表展示
- [ ] 课程详情页
- [ ] 课程视频/文档播放
- [ ] 课程进度标记

### 3. 试题系统模块
- [ ] 试题类型支持：
  - [ ] 单选题
  - [ ] 多选题
  - [ ] 判断题
  - [ ] 填空题
  - [ ] 简答题
  - [ ] 代码题
- [ ] 试题难度分级（简单、中等、困难）
- [ ] 试题标签系统
- [ ] 试题随机组卷

### 4. 评分系统模块
- [ ] 自动评分（选择题、判断题、填空题）
- [ ] 人工评分（简答题、代码题）
- [ ] 评分标准配置
- [ ] 评分历史记录
- [ ] 成绩统计分析

### 5. 学习进度模块
- [ ] 学习路径规划
- [ ] 学习时长统计
- [ ] 学习成就系统
- [ ] 学习报告生成

---

## 📁 项目结构

```
llm-learning-platform/
├── README.md
├── PROJECT_PLAN.md
├── docs/
│   ├── database-schema.sql
│   ├── api-docs.md
│   └── deployment-guide.md
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── components/
│   │   ├── views/
│   │   ├── router/
│   │   ├── store/
│   │   ├── api/
│   │   ├── utils/
│   │   └── styles/
│   ├── package.json
│   └── vue.config.js
├── backend/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/llm/learning/
│   │   │   │   ├── controller/
│   │   │   │   ├── service/
│   │   │   │   ├── dao/
│   │   │   │   ├── entity/
│   │   │   │   ├── config/
│   │   │   │   └── LlmLearningApplication.java
│   │   │   └── resources/
│   │   │       ├── application.yml
│   │   │       ├── mapper/
│   │   │       └── static/
│   │   └── test/
│   ├── pom.xml
│   └── Dockerfile
├── database/
│   ├── init.sql
│   └── seed-data.sql
├── docker/
│   ├── docker-compose.yml
│   └── nginx.conf
└── scripts/
    ├── deploy.sh
    └── backup.sh
```

---

## 🗄️ 数据库设计

### 核心表结构

#### 1. 用户表 (user)
```sql
CREATE TABLE user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    avatar VARCHAR(255),
    role ENUM('STUDENT', 'TEACHER', 'ADMIN') DEFAULT 'STUDENT',
    status TINYINT DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### 2. 课程表 (course)
```sql
CREATE TABLE course (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    cover_image VARCHAR(255),
    category VARCHAR(50),
    difficulty ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED'),
    duration INT,
    video_url VARCHAR(500),
    content TEXT,
    status TINYINT DEFAULT 1,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### 3. 试题表 (question)
```sql
CREATE TABLE question (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course_id BIGINT NOT NULL,
    type ENUM('SINGLE_CHOICE', 'MULTIPLE_CHOICE', 'TRUE_FALSE', 'FILL_BLANK', 'SHORT_ANSWER', 'CODE') NOT NULL,
    difficulty ENUM('EASY', 'MEDIUM', 'HARD'),
    content TEXT NOT NULL,
    options JSON,
    correct_answer TEXT,
    explanation TEXT,
    tags VARCHAR(200),
    score INT DEFAULT 10,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES course(id)
);
```

#### 4. 用户答题记录表 (user_answer)
```sql
CREATE TABLE user_answer (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    answer TEXT,
    score INT,
    status ENUM('PENDING', 'GRADED', 'CORRECT', 'INCORRECT'),
    graded_by BIGINT,
    graded_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (question_id) REFERENCES question(id),
    FOREIGN KEY (graded_by) REFERENCES user(id)
);
```

#### 5. 学习进度表 (learning_progress)
```sql
CREATE TABLE learning_progress (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    progress INT DEFAULT 0,
    completed_at DATETIME,
    total_duration INT DEFAULT 0,
    last_accessed DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (course_id) REFERENCES course(id),
    UNIQUE KEY uk_user_course (user_id, course_id)
);
```

---

## 🎨 前端页面规划

### 1. 首页
- [ ] 轮播图展示热门课程
- [ ] 课程分类导航
- [ ] 推荐课程列表
- [ ] 学习排行榜

### 2. 课程列表页
- [ ] 分类筛选
- [ ] 难度筛选
- [ ] 搜索功能
- [ ] 分页展示

### 3. 课程详情页
- [ ] 课程基本信息
- [ ] 课程大纲
- [ ] 课程视频/文档
- [ ] 试题列表
- [ ] 开始学习按钮

### 4. 学习页面
- [ ] 视频播放器
- [ ] 文档阅读器
- [ ] 学习进度条
- [ ] 笔记功能

### 5. 试题页面
- [ ] 试题展示
- [ ] 答题界面
- [ ] 计时器
- [ ] 提交按钮

### 6. 评分结果页
- [ ] 得分展示
- [ ] 错题分析
- [ ] 详细解析
- [ ] 重新答题

### 7. 个人中心
- [ ] 学习进度
- [ ] 成绩统计
- [ ] 学习历史
- [ ] 个人信息

---

## 🔧 后端API设计

### 用户模块
- `POST /api/user/register` - 用户注册
- `POST /api/user/login` - 用户登录
- `GET /api/user/info` - 获取用户信息
- `PUT /api/user/info` - 更新用户信息

### 课程模块
- `GET /api/courses` - 课程列表
- `GET /api/courses/{id}` - 课程详情
- `POST /api/courses` - 创建课程（管理员）
- `PUT /api/courses/{id}` - 更新课程
- `DELETE /api/courses/{id}` - 删除课程

### 试题模块
- `GET /api/questions` - 试题列表
- `GET /api/questions/{id}` - 试题详情
- `POST /api/questions` - 创建试题
- `PUT /api/questions/{id}` - 更新试题
- `DELETE /api/questions/{id}` - 删除试题
- `GET /api/courses/{courseId}/questions` - 课程试题列表

### 答题模块
- `POST /api/answers/submit` - 提交答案
- `GET /api/answers/history` - 答题历史
- `POST /api/answers/grade` - 评分（教师）

### 学习进度模块
- `GET /api/progress/{courseId}` - 学习进度
- `PUT /api/progress/{courseId}` - 更新进度
- `GET /api/progress/stats` - 学习统计

---

## 🚀 开发计划

### 第一阶段：基础架构（1-2天）
- [ ] 创建项目结构
- [ ] 配置开发环境
- [ ] 数据库设计与初始化
- [ ] 用户模块开发
- [ ] 基础API接口

### 第二阶段：课程系统（2-3天）
- [ ] 课程管理模块
- [ ] 课程分类功能
- [ ] 课程详情页面
- [ ] 课程视频/文档功能

### 第三阶段：试题系统（3-4天）
- [ ] 试题管理模块
- [ ] 试题类型支持
- [ ] 试题难度分级
- [ ] 试题标签系统

### 第四阶段：评分系统（2-3天）
- [ ] 自动评分逻辑
- [ ] 人工评分界面
- [ ] 评分标准配置
- [ ] 成绩统计分析

### 第五阶段：学习进度（2天）
- [ ] 学习进度追踪
- [ ] 学习时长统计
- [ ] 学习成就系统
- [ ] 学习报告生成

### 第六阶段：前端界面（3-4天）
- [ ] 首页设计
- [ ] 课程列表/详情
- [ ] 学习页面
- [ ] 试题页面
- [ ] 个人中心

### 第七阶段：测试与优化（2天）
- [ ] 单元测试
- [ ] 集成测试
- [ ] 性能优化
- [ ] 安全加固

### 第八阶段：部署上线（1天）
- [ ] Docker容器化
- [ ] Nginx配置
- [ ] 生产环境部署
- [ ] 监控配置

---

## 📊 试题丰富度设计

### 试题类型分布
| 类型 | 占比 | 示例 |
|------|------|------|
| 单选题 | 30% | 基础概念考察 |
| 多选题 | 20% | 综合理解考察 |
| 判断题 | 15% | 概念准确性 |
| 填空题 | 15% | 关键词记忆 |
| 简答题 | 10% | 理解深度 |
| 代码题 | 10% | 实践能力 |

### 试题难度分布
| 难度 | 占比 | 目标 |
|------|------|------|
| 简单 | 40% | 基础知识 |
| 中等 | 40% | 综合应用 |
| 困难 | 20% | 深度理解 |

### 试题标签系统
- **知识点标签**：Python基础、机器学习、深度学习、大模型API、提示工程、RAG
- **技能标签**：理论理解、代码实践、问题解决、系统设计
- **场景标签**：入门学习、项目实战、面试准备

---

## 🎯 评分系统设计

### 自动评分规则
1. **选择题**：完全正确得满分，错误得0分
2. **判断题**：完全正确得满分，错误得0分
3. **填空题**：关键词匹配，部分正确按比例给分
4. **代码题**：语法检查 + 功能测试 + 代码规范

### 人工评分规则
1. **简答题**：按评分标准分档给分
   - 完全正确：100%
   - 基本正确：70-90%
   - 部分正确：40-60%
   - 完全错误：0-20%

2. **代码题**：多维度评分
   - 功能正确性：40%
   - 代码规范：20%
   - 效率优化：20%
   - 可读性：20%

### 评分标准配置
- 支持自定义评分标准
- 支持不同课程不同标准
- 支持教师自定义评分模板

---

## 🔍 改进建议

### 1. 功能增强
- [ ] **AI助教**：集成大模型API，提供智能答疑
- [ ] **个性化推荐**：根据学习进度推荐课程
- [ ] **学习社区**：论坛/讨论区功能
- [ ] **证书系统**：完成课程颁发证书

### 2. 技术优化
- [ ] **缓存优化**：Redis缓存热门课程和试题
- [ ] **搜索优化**：Elasticsearch全文搜索
- [ ] **实时通信**：WebSocket实时通知
- [ ] **微服务架构**：模块解耦

### 3. 用户体验
- [ ] **移动端适配**：响应式设计
- [ ] **离线学习**：支持离线下载
- [ ] **学习提醒**：定时提醒学习
- [ ] **学习计划**：智能学习计划生成

### 4. 数据分析
- [ ] **学习分析**：学习行为分析
- [ ] **试题分析**：试题难度分析
- [ ] **成绩预测**：基于历史数据预测成绩
- [ ] **学习路径优化**：基于数据优化学习路径

### 5. 安全与运维
- [ ] **权限管理**：细粒度权限控制
- [ ] **数据备份**：自动备份机制
- [ ] **监控告警**：系统监控与告警
- [ ] **日志分析**：操作日志分析

---

## 💰 成本估算

### 开发成本
| 项目 | 时间 | 说明 |
|------|------|------|
| 后端开发 | 10-12天 | Spring Boot + MySQL |
| 前端开发 | 8-10天 | Vue 3 + Element Plus |
| 测试优化 | 3-4天 | 单元测试 + 集成测试 |
| 部署上线 | 1-2天 | Docker + Nginx |
| **总计** | **22-28天** | 约1个月 |

### 运维成本
| 项目 | 月费用 | 说明 |
|------|--------|------|
| 服务器 | ¥200-500 | 云服务器 |
| 域名 | ¥50-100 | 域名费用 |
| CDN | ¥50-100 | 加速服务 |
| **总计** | **¥300-700/月** | 基础运维 |

---

## 📅 里程碑计划

### 里程碑1：MVP版本（第1周）
- [ ] 用户系统
- [ ] 课程管理
- [ ] 基础试题
- [ ] 自动评分

### 里程碑2：Beta版本（第2-3周）
- [ ] 完整试题系统
- [ ] 人工评分
- [ ] 学习进度
- [ ] 前端界面

### 里程碑3：正式版本（第4周）
- [ ] 性能优化
- [ ] 安全加固
- [ ] 测试完成
- [ ] 部署上线

---

## 🎯 成功指标

### 用户指标
- 注册用户数：目标 1000+
- 活跃用户数：目标 300+
- 课程完成率：目标 60%+

### 学习指标
- 平均学习时长：目标 2小时/周
- 试题正确率：目标 70%+
- 用户满意度：目标 4.5/5

### 技术指标
- API响应时间：< 200ms
- 系统可用性：> 99.9%
- 并发用户数：> 100

---

## 📝 下一步行动

### 立即开始
1. [ ] 创建GitHub仓库
2. [ ] 初始化项目结构
3. [ ] 设计数据库表结构
4. [ ] 创建开发环境

### 本周完成
1. [ ] 用户模块开发
2. [ ] 课程管理模块
3. [ ] 基础API接口
4. [ ] 前端框架搭建

### 下周完成
1. [ ] 试题系统开发
2. [ ] 评分系统开发
3. [ ] 学习进度模块
4. [ ] 前端页面开发

---

## 📚 参考资料

### 技术文档
- [Vue 3官方文档](https://vuejs.org/)
- [Spring Boot官方文档](https://spring.io/projects/spring-boot)
- [Element Plus组件库](https://element-plus.org/)

### 学习资源
- [大模型学习路径](https://github.com/feihu1991/java-to-llm-blog)
- [在线学习平台案例](https://github.com/feihu1991/llm-learning-platform)

---

**计划制定时间**：2026-03-01
**计划版本**：v1.0
**计划状态**：待评审
