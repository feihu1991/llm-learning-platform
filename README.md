# 在线大模型学习平台

> 一个基于Spring Boot + Vue 3的在线学习大模型开发的Web平台

## 📋 项目简介

本项目是一个在线学习平台，专注于大模型开发相关的课程学习。平台提供丰富的课程内容、多样化的试题类型和智能的评分系统，帮助Java开发者顺利转型大模型开发。

## 🎯 核心功能

### 1. 课程系统
- ✅ 多种课程分类（基础、进阶、实战）
- ✅ 课程视频/文档播放
- ✅ 学习进度追踪
- ✅ 课程难度分级

### 2. 试题系统
- ✅ 6种试题类型
  - 单选题
  - 多选题
  - 判断题
  - 填空题
  - 简答题
  - 代码题
- ✅ 试题难度分级（简单、中等、困难）
- ✅ 试题标签系统
- ✅ 随机组卷功能

### 3. 评分系统
- ✅ 自动评分（选择题、判断题、填空题）
- ✅ 人工评分（简答题、代码题）
- ✅ 评分标准配置
- ✅ 成绩统计分析

### 4. 学习进度
- ✅ 学习路径规划
- ✅ 学习时长统计
- ✅ 学习成就系统
- ✅ 学习报告生成

## 🛠️ 技术栈

### 后端
- **框架**：Spring Boot 3.x
- **ORM**：MyBatis Plus
- **数据库**：MySQL 8.0
- **缓存**：Redis
- **安全**：Spring Security + JWT
- **文档**：Swagger/OpenAPI

### 前端
- **框架**：Vue 3 + TypeScript
- **UI库**：Element Plus
- **状态管理**：Pinia
- **路由**：Vue Router
- **HTTP**：Axios

### 部署
- **容器**：Docker
- **Web服务器**：Nginx
- **监控**：Prometheus + Grafana

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

## 🗄️ 数据库设计

### 核心表
1. **user** - 用户表
2. **course** - 课程表
3. **question** - 试题表
4. **user_answer** - 用户答题记录表
5. **learning_progress** - 学习进度表
6. **exam_paper** - 试卷表
7. **user_exam** - 用户考试记录表
8. **user_note** - 用户笔记表
9. **user_achievement** - 用户成就表
10. **grading_criteria** - 评分标准表
11. **system_config** - 系统配置表

详细设计见：[docs/database-schema.sql](docs/database-schema.sql)

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

## 🚀 快速开始

### 1. 环境要求
- JDK 17+
- Maven 3.8+
- Node.js 18+
- MySQL 8.0+
- Redis 7.0+

### 2. 数据库初始化
```bash
mysql -u root -p < docs/database-schema.sql
```

### 3. 后端启动
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

### 4. 前端启动
```bash
cd frontend
npm install
npm run serve
```

### 5. Docker部署
```bash
cd docker
docker-compose up -d
```

## 📖 API文档

启动后访问：http://localhost:8080/swagger-ui.html

## 🎯 开发计划

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

详细计划见：[PROJECT_PLAN.md](PROJECT_PLAN.md)

## 📊 成功指标

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

## 🔧 改进建议

### 功能增强
- [ ] **AI助教**：集成大模型API，提供智能答疑
- [ ] **个性化推荐**：根据学习进度推荐课程
- [ ] **学习社区**：论坛/讨论区功能
- [ ] **证书系统**：完成课程颁发证书

### 技术优化
- [ ] **缓存优化**：Redis缓存热门课程和试题
- [ ] **搜索优化**：Elasticsearch全文搜索
- [ ] **实时通信**：WebSocket实时通知
- [ ] **微服务架构**：模块解耦

### 用户体验
- [ ] **移动端适配**：响应式设计
- [ ] **离线学习**：支持离线下载
- [ ] **学习提醒**：定时提醒学习
- [ ] **学习计划**：智能学习计划生成

### 数据分析
- [ ] **学习分析**：学习行为分析
- [ ] **试题分析**：试题难度分析
- [ ] **成绩预测**：基于历史数据预测成绩
- [ ] **学习路径优化**：基于数据优化学习路径

### 安全与运维
- [ ] **权限管理**：细粒度权限控制
- [ ] **数据备份**：自动备份机制
- [ ] **监控告警**：系统监控与告警
- [ ] **日志分析**：操作日志分析

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

## 📚 参考资料

### 技术文档
- [Vue 3官方文档](https://vuejs.org/)
- [Spring Boot官方文档](https://spring.io/projects/spring-boot)
- [Element Plus组件库](https://element-plus.org/)

### 学习资源
- [大模型学习路径](https://github.com/feihu1991/java-to-llm-blog)
- [在线学习平台案例](https://github.com/feihu1991/llm-learning-platform)

## 📝 开发指南

### 代码规范
- 遵循Java编码规范
- 遵循Vue组件规范
- 使用ESLint和Prettier
- 编写单元测试

### 提交规范
- feat: 新功能
- fix: 修复bug
- docs: 文档更新
- style: 代码格式
- refactor: 重构
- test: 测试相关
- chore: 构建过程或辅助工具的变动

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 🤝 贡献

欢迎贡献代码、提交issue或建议！

## 📞 联系方式

- 作者：feihu1991
- GitHub：https://github.com/feihu1991
- 邮箱：115920877@qq.com

---

**项目创建时间**：2026-03-01
**项目版本**：v1.0
**项目状态**：规划中
