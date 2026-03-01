# 在线大模型学习平台 - 快速开始

## 🚀 快速开始指南

本指南帮助你快速启动在线大模型学习平台项目。

## 📋 前置条件

### 必需环境
- ✅ Java 17+
- ✅ Maven 3.8+
- ✅ Node.js 18+
- ✅ MySQL 8.0+
- ✅ Redis 7.0+

### 可选环境
- ✅ Docker（用于生产环境部署）
- ✅ Nginx（用于生产环境部署）

## 📦 快速启动

### 方式一：使用设置脚本（推荐）

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

### 方式二：手动设置

#### 1. 克隆项目
```bash
git clone https://github.com/feihu1991/llm-learning-platform.git
cd llm-learning-platform
```

#### 2. 创建数据库
```bash
mysql -u root -p
```

```sql
-- 创建数据库
CREATE DATABASE llm_learning_platform
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- 创建用户
CREATE USER 'llm_user'@'localhost' IDENTIFIED BY 'llm_password123';

-- 授权
GRANT ALL PRIVILEGES ON llm_learning_platform.* TO 'llm_user'@'localhost';

-- 刷新权限
FLUSH PRIVILEGES;

-- 导入数据
EXIT;
```

```bash
mysql -u llm_user -p llm_learning_platform < docs/database-schema.sql
```

#### 3. 启动后端
```bash
cd backend

# 安装依赖
mvn clean install -DskipTests

# 配置数据库连接
# 编辑 src/main/resources/application-local.yml

# 启动服务
mvn spring-boot:run
```

#### 4. 启动前端
```bash
cd frontend

# 安装依赖
npm install

# 配置API地址
# 编辑 .env.local

# 启动开发服务器
npm run serve
```

#### 5. 访问应用
- **前端**：http://localhost:8081
- **后端API**：http://localhost:8080/api
- **Swagger文档**：http://localhost:8080/swagger-ui.html

## 🎯 测试账号

### 管理员账号
- 用户名：`admin`
- 密码：`admin123`
- 角色：`ADMIN`

### 测试学生账号
- 用户名：`test_student`
- 密码：`admin123`
- 角色：`STUDENT`

### 测试教师账号
- 用户名：`test_teacher`
- 密码：`admin123`
- 角色：`TEACHER`

## 📚 API测试

### 1. 用户登录
```bash
curl -X POST http://localhost:8080/api/user/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

### 2. 获取课程列表
```bash
curl -X GET "http://localhost:8080/api/courses?page=1&size=10" \
  -H "Authorization: Bearer <token>"
```

### 3. 获取试题列表
```bash
curl -X GET "http://localhost:8080/api/questions?course_id=1" \
  -H "Authorization: Bearer <token>"
```

### 4. 提交答案
```bash
curl -X POST http://localhost:8080/api/answers/submit \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"question_id":1,"answer":"B"}'
```

## 🔧 常用命令

### 后端命令
```bash
# 启动后端
cd backend && mvn spring-boot:run

# 打包后端
cd backend && mvn clean package -DskipTests

# 运行打包后的jar
cd backend && java -jar target/llm-learning-platform-1.0.0.jar

# 查看日志
tail -f /var/log/llm-learning-platform/app.log
```

### 前端命令
```bash
# 启动开发服务器
cd frontend && npm run serve

# 构建生产版本
cd frontend && npm run build

# 查看构建报告
cd frontend && npm run build -- --report

# 运行单元测试
cd frontend && npm run test:unit

# 运行E2E测试
cd frontend && npm run test:e2e
```

### 数据库命令
```bash
# 登录MySQL
mysql -u llm_user -p llm_learning_platform

# 查看表
SHOW TABLES;

# 查看数据
SELECT * FROM user LIMIT 5;
SELECT * FROM course LIMIT 5;
SELECT * FROM question LIMIT 5;

# 备份数据库
mysqldump -u llm_user -p llm_learning_platform > backup.sql

# 恢复数据库
mysql -u llm_user -p llm_learning_platform < backup.sql
```

### Redis命令
```bash
# 连接Redis
redis-cli

# 查看所有键
KEYS *

# 查看缓存数据
GET <key>

# 清空缓存
FLUSHDB
```

## 🎯 功能测试

### 1. 用户注册登录
1. 访问 http://localhost:8081
2. 点击"注册"按钮
3. 填写注册信息
4. 使用注册账号登录

### 2. 课程学习
1. 登录后访问课程列表
2. 点击任意课程
3. 查看课程详情
4. 开始学习课程

### 3. 试题答题
1. 在课程详情页点击"试题"
2. 选择试题类型
3. 开始答题
4. 提交答案
5. 查看评分结果

### 4. 学习进度
1. 访问个人中心
2. 查看学习进度
3. 查看成绩统计
4. 查看学习历史

## 📊 数据验证

### 验证数据库连接
```bash
mysql -u llm_user -p llm_learning_platform -e "SELECT COUNT(*) FROM user;"
```

### 验证Redis连接
```bash
redis-cli ping
```

### 验证后端API
```bash
curl -X GET http://localhost:8080/api/courses
```

### 验证前端服务
```bash
curl -X GET http://localhost:8081
```

## 🚨 故障排查

### 问题1：端口被占用
```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :8080
kill -9 <PID>
```

### 问题2：数据库连接失败
```bash
# 检查MySQL状态
sudo systemctl status mysql

# 检查数据库是否创建
mysql -u llm_user -p -e "SHOW DATABASES;"

# 检查用户权限
mysql -u root -p -e "SHOW GRANTS FOR 'llm_user'@'localhost';"
```

### 问题3：Redis连接失败
```bash
# 检查Redis状态
sudo systemctl status redis

# 测试连接
redis-cli ping
```

### 问题4：前端构建失败
```bash
# 清除缓存
npm cache clean --force

# 删除node_modules
rm -rf node_modules

# 重新安装
npm install
```

## 📝 开发建议

### 1. 开发顺序
1. 先完成后端基础架构
2. 实现核心业务逻辑
3. 开发前端界面
4. 进行集成测试
5. 优化和部署

### 2. 代码规范
- 遵循Java编码规范
- 遵循Vue组件规范
- 使用ESLint和Prettier
- 编写单元测试

### 3. 提交规范
- feat: 新功能
- fix: 修复bug
- docs: 文档更新
- style: 代码格式
- refactor: 重构
- test: 测试相关
- chore: 构建过程或辅助工具的变动

## 📚 参考文档

### 项目文档
- [项目计划](PROJECT_PLAN.md)
- [数据库设计](docs/database-schema.sql)
- [API文档](docs/api-docs.md)
- [部署指南](docs/deployment-guide.md)
- [项目总结](docs/project-summary.md)
- [待办事项](docs/TODO.md)

### 技术文档
- [Vue 3官方文档](https://vuejs.org/)
- [Spring Boot官方文档](https://spring.io/projects/spring-boot)
- [Element Plus组件库](https://element-plus.org/)
- [MyBatis Plus文档](https://baomidou.com/)

## 📞 技术支持

如有问题，请联系：
- **GitHub**：https://github.com/feihu1991
- **邮箱**：115920877@qq.com
- **博客**：https://github.com/feihu1991/java-to-llm-blog

---

**文档版本**：v1.0

**最后更新**：2026-03-01

**文档状态**：完成 ✅
