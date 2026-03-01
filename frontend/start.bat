@echo off
echo ========================================
echo 在线大模型学习平台 - 前端启动脚本
echo ========================================
echo.

echo 1. 检查Node.js环境...
node --version >nul 2>&1
if errorlevel 1 (
    echo 错误：未找到Node.js，请安装Node.js 18或更高版本
    pause
    exit /b 1
)
echo Node.js环境检查通过

echo.
echo 2. 检查npm环境...
npm --version >nul 2>&1
if errorlevel 1 (
    echo 错误：未找到npm，请安装Node.js
    pause
    exit /b 1
)
echo npm环境检查通过

echo.
echo 3. 检查依赖...
if not exist node_modules (
    echo 未找到node_modules目录，正在安装依赖...
    call npm install
    if errorlevel 1 (
        echo 错误：依赖安装失败
        pause
        exit /b 1
    )
)
echo 依赖检查通过

echo.
echo 4. 启动开发服务器...
echo 访问地址：http://localhost:8081
echo.
echo 按Ctrl+C停止服务
echo.

call npm run serve
