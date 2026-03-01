@echo off
echo ========================================
echo 在线大模型学习平台 - 后端启动脚本
echo ========================================
echo.

echo 1. 检查Java环境...
java -version >nul 2>&1
if errorlevel 1 (
    echo 错误：未找到Java，请安装Java 17或更高版本
    pause
    exit /b 1
)
echo Java环境检查通过

echo.
echo 2. 检查Maven环境...
mvn -version >nul 2>&1
if errorlevel 1 (
    echo 错误：未找到Maven，请安装Maven
    pause
    exit /b 1
)
echo Maven环境检查通过

echo.
echo 3. 检查MySQL环境...
mysql --version >nul 2>&1
if errorlevel 1 (
    echo 警告：未找到MySQL客户端，但可以继续启动
    echo 请确保MySQL服务已启动
) else (
    echo MySQL客户端检查通过
)

echo.
echo 4. 检查Redis环境...
redis-cli --version >nul 2>&1
if errorlevel 1 (
    echo 警告：未找到Redis客户端，但可以继续启动
    echo 请确保Redis服务已启动
) else (
    echo Redis客户端检查通过
)

echo.
echo 5. 编译项目...
call mvn clean compile -DskipTests
if errorlevel 1 (
    echo 错误：项目编译失败
    pause
    exit /b 1
)
echo 项目编译成功

echo.
echo 6. 启动后端服务...
echo 访问地址：http://localhost:8080/api
echo API文档：http://localhost:8080/api/swagger-ui.html
echo.
echo 按Ctrl+C停止服务
echo.

call mvn spring-boot:run
