@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ==========================================
echo 在线大模型学习平台 - 开发环境设置
echo ==========================================
echo.

echo 检查环境...
echo.

echo 1. 检查Java...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo    错误: Java未安装，请先安装Java 17+
    pause
    exit /b 1
)
for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| findstr /i "version"') do (
    set JAVA_VERSION=%%i
)
echo    Java版本: !JAVA_VERSION!

echo.
echo 2. 检查Maven...
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo    错误: Maven未安装，请先安装Maven 3.8+
    pause
    exit /b 1
)
for /f "tokens=3" %%i in ('mvn -version 2^>^&1 ^| findstr /i "version"') do (
    set MVN_VERSION=%%i
)
echo    Maven版本: !MVN_VERSION!

echo.
echo 3. 检查Node.js...
node -version >nul 2>&1
if %errorlevel% neq 0 (
    echo    错误: Node.js未安装，请先安装Node.js 18+
    pause
    exit /b 1
)
for /f "tokens=1" %%i in ('node -version') do (
    set NODE_VERSION=%%i
)
echo    Node.js版本: !NODE_VERSION!

echo.
echo ==========================================
echo 环境检查完成
echo ==========================================
echo.

set /p CONTINUE="是否继续设置开发环境？(y/n): "
if /i not "%CONTINUE%"=="y" (
    echo 取消设置
    exit /b 0
)

echo.
echo 开始设置开发环境...
echo.

echo 1. 设置后端...
cd backend

echo    - 安装Maven依赖...
call mvn clean install -DskipTests

echo    - 创建配置文件...
if not exist src\main\resources\application-local.yml (
    (
        echo server:
        echo   port: 8080
        echo.
        echo spring:
        echo   datasource:
        echo     url: jdbc:mysql://localhost:3306/llm_learning_platform?useUnicode=true^&characterEncoding=utf8^&serverTimezone=Asia/Shanghai
        echo     username: llm_user
        echo     password: llm_password123
        echo     driver-class-name: com.mysql.cj.jdbc.Driver
        echo     hikari:
        echo       maximum-pool-size: 20
        echo       minimum-idle: 5
        echo       connection-timeout: 30000
        echo.
        echo   redis:
        echo     host: localhost
        echo     port: 6379
        echo     password: 
        echo     database: 0
        echo     timeout: 5000ms
        echo.
        echo   jpa:
        echo     hibernate:
        echo       ddl-auto: update
        echo     show-sql: false
        echo.
        echo mybatis-plus:
        echo   configuration:
        echo     log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
        echo.
        echo jwt:
        echo   secret: llm-learning-platform-secret-key-2026
        echo   expiration: 86400000
        echo   token-prefix: Bearer
        echo.
        echo logging:
        echo   level:
        echo     com.llm.learning: DEBUG
        echo     org.springframework: INFO
    ) > src\main\resources\application-local.yml
    echo    - 已创建 application-local.yml
)

echo    - 后端设置完成
cd ..

echo.
echo 2. 设置前端...
cd frontend

echo    - 安装Node.js依赖...
call npm install

echo    - 创建配置文件...
if not exist .env.local (
    (
        echo VITE_API_BASE_URL=http://localhost:8080/api
        echo VITE_WS_URL=ws://localhost:8080/ws
        echo VITE_APP_NAME=在线大模型学习平台
        echo VITE_APP_VERSION=1.0.0
        echo VITE_ENABLE_SWAGGER=true
        echo VITE_ENABLE_ANALYTICS=false
    ) > .env.local
    echo    - 已创建 .env.local
)

echo    - 前端设置完成
cd ..

echo.
echo ==========================================
echo 开发环境设置完成
echo ==========================================
echo.

echo 下一步操作：
echo 1. 创建数据库：mysql -u root -p ^< docs\database-schema.sql
echo 2. 启动后端：cd backend ^&^& mvn spring-boot:run
echo 3. 启动前端：cd frontend ^&^& npm run serve
echo 4. 访问：http://localhost:8081
echo.

echo 常用命令：
echo   后端启动：cd backend ^&^& mvn spring-boot:run
echo   前端启动：cd frontend ^&^& npm run serve
echo   构建前端：cd frontend ^&^& npm run build
echo   打包后端：cd backend ^&^& mvn clean package -DskipTests
echo.

echo 文档位置：
echo   项目计划：PROJECT_PLAN.md
echo   数据库设计：docs\database-schema.sql
echo   API文档：docs\api-docs.md
echo   部署指南：docs\deployment-guide.md
echo   项目总结：docs\project-summary.md
echo.

echo ==========================================
echo 设置完成！
echo ==========================================

pause
