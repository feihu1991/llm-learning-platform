# 在线大模型学习平台

> 一个基于Spring Boot + Vue 3的在线学习大模型开发的Web平台

[English](README.md) | [中文](README_CN.md)

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
│   ├── deployment-guide.md
│   ├── project-summary.md
│   ├── TODO.md
│   ├── QUICKSTART.md
│   └── PROJECT_COMPLETE.md
├── scripts/
│   ├── setup.sh
│   └── setup.bat
└── ... (其他目录将在开发时创建)
```

## 🚀 快速开始

### 前置条件
- Java 17+
- Maven 3.8+
- Node.js 18+
- MySQL 8.0+
- Redis 7.0+

### 快速启动

#### Windows
```bash
# 1. 克隆项目
git clone https://github.com/feihu1991/llm-learning-platform.git
cd llm-learning-platform

# 2. 运行设置脚本
scripts\setup.bat

# 3. 创建数据库
mysql -u root -p < docs\database-schema.sql

# 4. 启动后端
cd backend
mvn spring-boot:run

# 5. 启动前端（新终端）
cd frontend
npm run serve

# 6. 访问应用
# 前端：http://localhost:8081
# 后端API：http://localhost:8080/api
# Swagger文档：http://localhost:8080/swagger-ui.html
```

#### Linux/Mac
```bash
# 1. 克隆项目
git clone https://github.com/feihu1991/llm-learning-platform.git
cd llm-learning-platform

# 2. 运行设置脚本
chmod +x scripts/setup.sh
./scripts/setup.sh

# 3. 创建数据库
mysql -u root -p < docs/database-schema.sql

# 4. 启动后端
cd backend
mvn spring-boot:run

# 5. 启动前端（新终端）
cd frontend
npm run serve

# 6. 访问应用
# 前端：http://localhost:8081
# 后端API：http://localhost:8080/api
# Swagger文档：http://localhost:8080/swagger-ui.html
```

详见：[docs/QUICKSTART.md](docs/QUICKSTART.md)

## 📖 文档

- [项目计划](PROJECT_PLAN.md) - 详细项目计划
- [数据库设计](docs/database-schema.sql) - 完整数据库设计
- [API文档](docs/api-docs.md) - API接口文档
- [部署指南](docs/deployment-guide.md) - 部署和运维指南
- [项目总结](docs/project-summary.md) - 项目总结
- [待办事项](docs/TODO.md) - 开发任务清单
- [快速开始](docs/QUICKSTART.md) - 快速开始指南
- [项目完成](docs/PROJECT_COMPLETE.md) - 项目完成总结

## 📊 开发计划

### 总计：120个任务，预计22-28天

| 阶段 | 任务数 | 预计时间 |
|------|--------|----------|
| 基础架构 | 15 | 1-2天 |
| 课程系统 | 15 | 2-3天 |
| 试题系统 | 25 | 3-4天 |
| 评分系统 | 15 | 2-3天 |
| 学习功能 | 10 | 2天 |
| 前端界面 | 20 | 3-4天 |
| 测试优化 | 10 | 2天 |
| 部署上线 | 10 | 1天 |

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

## 🔍 改进建议

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

## 📚 参考资料

### 技术文档
- [Vue 3官方文档](https://vuejs.org/)
- [Spring Boot官方文档](https://spring.io/projects/spring-boot)
- [Element Plus组件库](https://element-plus.org/)
- [MyBatis Plus文档](https://baomidou.com/)

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

- **作者**：feihu1991
- **GitHub**：https://github.com/feihu1991
- **邮箱**：115920877@qq.com
- **博客**：https://github.com/feihu1991/java-to-llm-blog

---

**项目创建时间**：2026-03-01

**项目版本**：v1.0

**项目状态**：规划完成 ✅

**文档字数**：约92,759字

**开发任务**：120个，预计22-28天
