#!/bin/bash

# 在线大模型学习平台 - 开发环境设置脚本
# 作者：feihu1991
# 创建时间：2026-03-01

set -e

echo "=========================================="
echo "在线大模型学习平台 - 开发环境设置"
echo "=========================================="
echo ""

# 检查系统
OS=$(uname -s)
echo "操作系统: $OS"

# 检查Java
echo "检查Java..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')
    echo "Java版本: $JAVA_VERSION"
    if [[ ! "$JAVA_VERSION" =~ ^17 ]]; then
        echo "警告: 需要Java 17+，当前版本可能不兼容"
    fi
else
    echo "错误: Java未安装，请先安装Java 17"
    exit 1
fi

# 检查Maven
echo "检查Maven..."
if command -v mvn &> /dev/null; then
    MVN_VERSION=$(mvn -version 2>&1 | head -n 1 | awk '{print $3}')
    echo "Maven版本: $MVN_VERSION"
else
    echo "错误: Maven未安装，请先安装Maven 3.8+"
    exit 1
fi

# 检查Node.js
echo "检查Node.js..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo "Node.js版本: $NODE_VERSION"
    if [[ ! "$NODE_VERSION" =~ ^v18 ]]; then
        echo "警告: 需要Node.js 18+，当前版本可能不兼容"
    fi
else
    echo "错误: Node.js未安装，请先安装Node.js 18+"
    exit 1
fi

# 检查MySQL
echo "检查MySQL..."
if command -v mysql &> /dev/null; then
    MYSQL_VERSION=$(mysql --version 2>&1 | awk '{print $5}')
    echo "MySQL版本: $MYSQL_VERSION"
else
    echo "警告: MySQL未安装，将跳过数据库配置"
fi

# 检查Redis
echo "检查Redis..."
if command -v redis-cli &> /dev/null; then
    REDIS_VERSION=$(redis-cli --version | awk '{print $2}')
    echo "Redis版本: $REDIS_VERSION"
else
    echo "警告: Redis未安装，将跳过Redis配置"
fi

echo ""
echo "=========================================="
echo "环境检查完成"
echo "=========================================="
echo ""

# 询问用户是否继续
read -p "是否继续设置开发环境？(y/n): " CONTINUE
if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
    echo "取消设置"
    exit 0
fi

echo ""
echo "开始设置开发环境..."
echo ""

# 设置后端
echo "1. 设置后端..."
cd backend

echo "   - 安装Maven依赖..."
mvn clean install -DskipTests

echo "   - 创建配置文件..."
if [ ! -f src/main/resources/application-local.yml ]; then
    cat > src/main/resources/application-local.yml << 'EOF'
server:
  port: 8080

spring:
  datasource:
    url: jdbc:mysql://localhost:3306/llm_learning_platform?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
    username: llm_user
    password: llm_password123
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000

  redis:
    host: localhost
    port: 6379
    password: 
    database: 0
    timeout: 5000ms

  jpa:
    hibernate:
      ddl-auto: update
    show-sql: false

mybatis-plus:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl

jwt:
  secret: llm-learning-platform-secret-key-2026
  expiration: 86400000
  token-prefix: Bearer

logging:
  level:
    com.llm.learning: DEBUG
    org.springframework: INFO
EOF
    echo "   - 已创建 application-local.yml"
fi

echo "   - 后端设置完成"
cd ..

# 设置前端
echo "2. 设置前端..."
cd frontend

echo "   - 安装Node.js依赖..."
npm install

echo "   - 创建配置文件..."
if [ ! -f .env.local ]; then
    cat > .env.local << 'EOF'
VITE_API_BASE_URL=http://localhost:8080/api
VITE_WS_URL=ws://localhost:8080/ws
VITE_APP_NAME=在线大模型学习平台
VITE_APP_VERSION=1.0.0
VITE_ENABLE_SWAGGER=true
VITE_ENABLE_ANALYTICS=false
EOF
    echo "   - 已创建 .env.local"
fi

echo "   - 前端设置完成"
cd ..

echo ""
echo "=========================================="
echo "开发环境设置完成"
echo "=========================================="
echo ""

echo "下一步操作："
echo "1. 创建数据库：mysql -u root -p < docs/database-schema.sql"
echo "2. 启动后端：cd backend && mvn spring-boot:run"
echo "3. 启动前端：cd frontend && npm run serve"
echo "4. 访问：http://localhost:8081"
echo ""

echo "常用命令："
echo "  后端启动：cd backend && mvn spring-boot:run"
echo "  前端启动：cd frontend && npm run serve"
echo "  构建前端：cd frontend && npm run build"
echo "  打包后端：cd backend && mvn clean package -DskipTests"
echo ""

echo "文档位置："
echo "  项目计划：PROJECT_PLAN.md"
echo "  数据库设计：docs/database-schema.sql"
echo "  API文档：docs/api-docs.md"
echo "  部署指南：docs/deployment-guide.md"
echo "  项目总结：docs/project-summary.md"
echo ""

echo "=========================================="
echo "设置完成！"
echo "=========================================="
