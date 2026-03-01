# 在线大模型学习平台 - 部署指南

## 📋 部署概述

本指南提供在线大模型学习平台的完整部署流程，包括开发环境、测试环境和生产环境的部署方法。

## 🎯 部署环境

### 开发环境
- **操作系统**：Windows / macOS / Linux
- **JDK**：17+
- **Maven**：3.8+
- **Node.js**：18+
- **MySQL**：8.0+
- **Redis**：7.0+

### 测试环境
- **操作系统**：Linux (Ubuntu/CentOS)
- **JDK**：17+
- **Maven**：3.8+
- **Node.js**：18+
- **MySQL**：8.0+
- **Redis**：7.0+
- **Nginx**：1.18+

### 生产环境
- **操作系统**：Linux (Ubuntu/CentOS)
- **JDK**：17+
- **Maven**：3.8+
- **Node.js**：18+
- **MySQL**：8.0+
- **Redis**：7.0+
- **Nginx**：1.18+
- **Docker**：20.10+

## 📦 环境准备

### 1. 安装JDK 17

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install openjdk-17-jdk
java -version
```

**CentOS/RHEL:**
```bash
sudo yum install java-17-openjdk-devel
java -version
```

**macOS:**
```bash
brew install openjdk@17
export JAVA_HOME=/usr/local/opt/openjdk@17
export PATH=$JAVA_HOME/bin:$PATH
```

**Windows:**
1. 下载JDK 17：https://www.oracle.com/java/technologies/downloads/
2. 安装并配置环境变量
3. 验证：`java -version`

### 2. 安装Maven

**Ubuntu/Debian:**
```bash
sudo apt install maven
mvn -version
```

**CentOS/RHEL:**
```bash
sudo yum install maven
mvn -version
```

**macOS:**
```bash
brew install maven
mvn -version
```

**Windows:**
1. 下载Maven：https://maven.apache.org/download.cgi
2. 解压到C:\Program Files\Apache\maven
3. 配置环境变量：
   - M2_HOME: C:\Program Files\Apache\maven
   - PATH: %M2_HOME%\bin
4. 验证：`mvn -version`

### 3. 安装Node.js

**Ubuntu/Debian:**
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v
npm -v
```

**CentOS/RHEL:**
```bash
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs
node -v
npm -v
```

**macOS:**
```bash
brew install node
node -v
npm -v
```

**Windows:**
1. 下载Node.js：https://nodejs.org/
2. 安装LTS版本
3. 验证：`node -v` 和 `npm -v`

### 4. 安装MySQL 8.0

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install mysql-server
sudo mysql_secure_installation
```

**CentOS/RHEL:**
```bash
sudo yum install mysql-server
sudo systemctl start mysqld
sudo systemctl enable mysqld
sudo mysql_secure_installation
```

**macOS:**
```bash
brew install mysql
brew services start mysql
mysql_secure_installation
```

**Windows:**
1. 下载MySQL Installer：https://dev.mysql.com/downloads/installer/
2. 安装MySQL Server 8.0
3. 配置root密码

### 5. 安装Redis

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install redis-server
sudo systemctl start redis
sudo systemctl enable redis
redis-cli ping
```

**CentOS/RHEL:**
```bash
sudo yum install redis
sudo systemctl start redis
sudo systemctl enable redis
redis-cli ping
```

**macOS:**
```bash
brew install redis
brew services start redis
redis-cli ping
```

**Windows:**
1. 下载Redis：https://github.com/microsoftarchive/redis/releases
2. 安装并启动Redis服务
3. 验证：`redis-cli ping`

### 6. 安装Docker（可选，用于生产环境）

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
docker --version
```

**CentOS/RHEL:**
```bash
sudo yum install docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
docker --version
```

**macOS:**
1. 下载Docker Desktop：https://www.docker.com/products/docker-desktop/
2. 安装并启动

**Windows:**
1. 下载Docker Desktop：https://www.docker.com/products/docker-desktop/
2. 安装并启动

## 🗄️ 数据库配置

### 1. 创建数据库

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

-- 退出
EXIT;
```

### 2. 导入数据库结构

```bash
mysql -u llm_user -p llm_learning_platform < docs/database-schema.sql
```

### 3. 验证数据库

```bash
mysql -u llm_user -p llm_learning_platform
```

```sql
-- 查看表
SHOW TABLES;

-- 查看用户表
SELECT COUNT(*) FROM user;

-- 查看课程表
SELECT COUNT(*) FROM course;

-- 查看试题表
SELECT COUNT(*) FROM question;
```

## 🚀 后端部署

### 开发环境部署

#### 1. 克隆项目
```bash
cd /path/to/workspace
git clone https://github.com/feihu1991/llm-learning-platform.git
cd llm-learning-platform/backend
```

#### 2. 配置数据库连接

编辑 `src/main/resources/application.yml`：

```yaml
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
      idle-timeout: 600000
      max-lifetime: 1800000

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
  mapper-locations: classpath:mapper/*.xml

jwt:
  secret: llm-learning-platform-secret-key-2026
  expiration: 86400000
  token-prefix: Bearer

logging:
  level:
    com.llm.learning: DEBUG
    org.springframework: INFO
```

#### 3. 启动后端服务

```bash
# 使用Maven启动
mvn spring-boot:run

# 或者打包后启动
mvn clean package
java -jar target/llm-learning-platform-1.0.0.jar
```

#### 4. 验证后端服务

访问：http://localhost:8080/swagger-ui.html

测试API：
```bash
curl -X GET http://localhost:8080/api/courses
```

### 生产环境部署

#### 1. 打包项目

```bash
cd /path/to/llm-learning-platform/backend
mvn clean package -DskipTests
```

#### 2. 配置生产环境

创建 `application-prod.yml`：

```yaml
server:
  port: 8080

spring:
  datasource:
    url: jdbc:mysql://your-mysql-host:3306/llm_learning_platform?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
    username: llm_user
    password: your_production_password
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      maximum-pool-size: 50
      minimum-idle: 10
      connection-timeout: 30000

  redis:
    host: your-redis-host
    port: 6379
    password: your_redis_password
    database: 0
    timeout: 5000ms

  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: false

jwt:
  secret: your-production-secret-key
  expiration: 86400000
  token-prefix: Bearer

logging:
  level:
    com.llm.learning: INFO
    org.springframework: WARN
  file:
    name: /var/log/llm-learning-platform/app.log
```

#### 3. 使用Docker部署

创建 `Dockerfile`：

```dockerfile
# 构建阶段
FROM maven:3.8.6-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# 运行阶段
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/target/llm-learning-platform-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

构建镜像：
```bash
docker build -t llm-learning-platform:1.0.0 .
```

运行容器：
```bash
docker run -d \
  --name llm-learning-platform \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  -v /var/log/llm-learning-platform:/app/logs \
  llm-learning-platform:1.0.0
```

#### 4. 使用Docker Compose部署

创建 `docker-compose.yml`：

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: llm-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: llm_learning_platform
      MYSQL_USER: llm_user
      MYSQL_PASSWORD: llm_password123
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
      - ./docs/database-schema.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - llm-network

  redis:
    image: redis:7.0-alpine
    container_name: llm-redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    networks:
      - llm-network

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: llm-backend
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/llm_learning_platform?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
      - SPRING_DATASOURCE_USERNAME=llm_user
      - SPRING_DATASOURCE_PASSWORD=llm_password123
      - SPRING_REDIS_HOST=redis
      - SPRING_REDIS_PORT=6379
    depends_on:
      - mysql
      - redis
    networks:
      - llm-network

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: llm-frontend
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - llm-network

volumes:
  mysql-data:
  redis-data:

networks:
  llm-network:
    driver: bridge
```

启动服务：
```bash
docker-compose up -d
```

查看日志：
```bash
docker-compose logs -f
```

## 🎨 前端部署

### 开发环境部署

#### 1. 安装依赖

```bash
cd /path/to/llm-learning-platform/frontend
npm install
```

#### 2. 配置API地址

编辑 `src/config/config.js`：

```javascript
export const API_CONFIG = {
  baseURL: 'http://localhost:8080/api',
  timeout: 10000,
  withCredentials: false
};
```

#### 3. 启动开发服务器

```bash
npm run serve
```

访问：http://localhost:8081

### 生产环境部署

#### 1. 构建项目

```bash
cd /path/to/llm-learning-platform/frontend
npm run build
```

构建产物在 `dist/` 目录。

#### 2. 配置Nginx

创建 `nginx.conf`：

```nginx
# HTTP服务器
server {
    listen 80;
    server_name your-domain.com;
    
    # 前端静态文件
    location / {
        root /var/www/llm-learning-platform/frontend;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
    
    # 后端API代理
    location /api/ {
        proxy_pass http://localhost:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # 超时设置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # Swagger文档（可选，生产环境建议关闭）
    location /swagger-ui.html {
        proxy_pass http://localhost:8080/swagger-ui.html;
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
    
    # 日志
    access_log /var/log/nginx/llm-learning-platform-access.log;
    error_log /var/log/nginx/llm-learning-platform-error.log;
}

# HTTPS服务器（生产环境推荐）
server {
    listen 443 ssl http2;
    server_name your-domain.com;
    
    ssl_certificate /etc/ssl/certs/your-domain.com.crt;
    ssl_certificate_key /etc/ssl/private/your-domain.com.key;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    
    # 前端静态文件
    location / {
        root /var/www/llm-learning-platform/frontend;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
    
    # 后端API代理
    location /api/ {
        proxy_pass http://localhost:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    # 日志
    access_log /var/log/nginx/llm-learning-platform-ssl-access.log;
    error_log /var/log/nginx/llm-learning-platform-ssl-error.log;
}
```

#### 3. 部署前端文件

```bash
# 创建目录
sudo mkdir -p /var/www/llm-learning-platform/frontend

# 复制构建文件
sudo cp -r dist/* /var/www/llm-learning-platform/frontend/

# 设置权限
sudo chown -R www-data:www-data /var/www/llm-learning-platform
sudo chmod -R 755 /var/www/llm-learning-platform
```

#### 4. 配置Nginx

```bash
# 复制配置文件
sudo cp nginx.conf /etc/nginx/sites-available/llm-learning-platform

# 创建符号链接
sudo ln -s /etc/nginx/sites-available/llm-learning-platform /etc/nginx/sites-enabled/

# 测试配置
sudo nginx -t

# 重启Nginx
sudo systemctl restart nginx
```

#### 5. 配置SSL证书（可选）

使用Let's Encrypt免费证书：
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

## 🔧 环境变量配置

### 开发环境

创建 `.env` 文件：

```env
# 后端配置
VITE_API_BASE_URL=http://localhost:8080/api
VITE_WS_URL=ws://localhost:8080/ws

# 应用配置
VITE_APP_NAME=在线大模型学习平台
VITE_APP_VERSION=1.0.0

# 功能开关
VITE_ENABLE_SWAGGER=true
VITE_ENABLE_ANALYTICS=false
```

### 生产环境

创建 `.env.production` 文件：

```env
# 后端配置
VITE_API_BASE_URL=https://api.your-domain.com/api
VITE_WS_URL=wss://api.your-domain.com/ws

# 应用配置
VITE_APP_NAME=在线大模型学习平台
VITE_APP_VERSION=1.0.0

# 功能开关
VITE_ENABLE_SWAGGER=false
VITE_ENABLE_ANALYTICS=true
```

## 📊 监控配置

### 1. 应用监控

使用Spring Boot Actuator：

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: always
  metrics:
    export:
      prometheus:
        enabled: true
```

访问：http://localhost:8080/actuator/health

### 2. 日志配置

创建 `logback-spring.xml`：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>/var/log/llm-learning-platform/app.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>/var/log/llm-learning-platform/app.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    
    <root level="INFO">
        <appender-ref ref="CONSOLE" />
        <appender-ref ref="FILE" />
    </root>
</configuration>
```

### 3. 性能监控

使用Prometheus + Grafana：

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'llm-learning-platform'
    static_configs:
      - targets: ['localhost:8080']
```

## 🛡️ 安全配置

### 1. 数据库安全

```sql
-- 创建专用用户
CREATE USER 'llm_user'@'localhost' IDENTIFIED BY 'strong_password';

-- 最小权限原则
GRANT SELECT, INSERT, UPDATE, DELETE ON llm_learning_platform.* TO 'llm_user'@'localhost';

-- 禁止root远程登录
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
```

### 2. JWT配置

```yaml
jwt:
  secret: your-256-bit-secret-key-here
  expiration: 86400000
  refresh-expiration: 604800000
```

### 3. CORS配置

```java
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("https://your-domain.com")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }
}
```

## 🔄 备份策略

### 1. 数据库备份

创建备份脚本 `backup.sh`：

```bash
#!/bin/bash

# 配置
BACKUP_DIR="/var/backups/llm-learning-platform"
MYSQL_USER="llm_user"
MYSQL_PASSWORD="your_password"
MYSQL_DATABASE="llm_learning_platform"
DATE=$(date +%Y%m%d_%H%M%S)

# 创建备份目录
mkdir -p $BACKUP_DIR

# 备份数据库
mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > $BACKUP_DIR/db_$DATE.sql

# 压缩
gzip $BACKUP_DIR/db_$DATE.sql

# 删除30天前的备份
find $BACKUP_DIR -name "db_*.sql.gz" -mtime +30 -delete

echo "Backup completed: $BACKUP_DIR/db_$DATE.sql.gz"
```

设置定时任务：
```bash
# 每天凌晨2点执行备份
0 2 * * * /path/to/backup.sh
```

### 2. 代码备份

```bash
# 推送到远程仓库
git push origin main

# 创建标签
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## 🚨 故障排查

### 1. 后端启动失败

**问题**：端口被占用
```bash
# 查看端口占用
netstat -tulpn | grep 8080

# 或者
lsof -i :8080

# 杀死进程
kill -9 <PID>
```

**问题**：数据库连接失败
```bash
# 检查MySQL状态
sudo systemctl status mysql

# 检查数据库是否创建
mysql -u llm_user -p -e "SHOW DATABASES;"

# 检查用户权限
mysql -u root -p -e "SHOW GRANTS FOR 'llm_user'@'localhost';"
```

**问题**：Redis连接失败
```bash
# 检查Redis状态
sudo systemctl status redis

# 测试连接
redis-cli ping
```

### 2. 前端构建失败

**问题**：Node.js版本不兼容
```bash
# 检查Node版本
node -v

# 使用nvm切换版本
nvm install 18
nvm use 18
```

**问题**：依赖安装失败
```bash
# 清除缓存
npm cache clean --force

# 删除node_modules
rm -rf node_modules

# 重新安装
npm install
```

### 3. Nginx配置问题

**问题**：502 Bad Gateway
```bash
# 检查后端服务
curl http://localhost:8080/api/courses

# 检查Nginx错误日志
tail -f /var/log/nginx/error.log
```

**问题**：静态文件404
```bash
# 检查文件权限
ls -la /var/www/llm-learning-platform/frontend

# 检查Nginx配置
nginx -t
```

## 📈 性能优化

### 1. 数据库优化

```sql
-- 添加索引
CREATE INDEX idx_user_email ON user(email);
CREATE INDEX idx_course_category ON course(category);
CREATE INDEX idx_question_course ON question(course_id);

-- 优化表
OPTIMIZE TABLE user, course, question, user_answer;

-- 分析表
ANALYZE TABLE user, course, question, user_answer;
```

### 2. Redis缓存

```java
@Service
@CacheConfig(cacheNames = "courses")
public class CourseServiceImpl implements CourseService {
    
    @Cacheable(key = "#id")
    public Course getCourseById(Long id) {
        // 查询数据库
        return courseMapper.selectById(id);
    }
    
    @CacheEvict(key = "#id")
    public void updateCourse(Long id, Course course) {
        // 更新数据库
        courseMapper.updateById(course);
    }
}
```

### 3. JVM调优

```bash
java -jar \
  -Xms512m \
  -Xmx2048m \
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -XX:+HeapDumpOnOutOfMemoryError \
  -XX:HeapDumpPath=/var/log/llm-learning-platform/heapdump.hprof \
  llm-learning-platform-1.0.0.jar
```

## 📝 部署检查清单

### 部署前检查
- [ ] 数据库已创建并导入结构
- [ ] Redis已安装并启动
- [ ] 后端配置文件已修改
- [ ] 前端API地址已配置
- [ ] 环境变量已设置
- [ ] 日志目录已创建
- [ ] 备份策略已配置

### 部署后验证
- [ ] 后端服务正常启动
- [ ] 前端页面可访问
- [ ] API接口可调用
- [ ] 数据库连接正常
- [ ] Redis连接正常
- [ ] Nginx配置正确
- [ ] 日志正常记录
- [ ] 监控指标正常

### 生产环境额外检查
- [ ] HTTPS证书已配置
- [ ] 防火墙规则已设置
- [ ] 安全组规则已配置
- [ ] 备份任务已配置
- [ ] 监控告警已配置
- [ ] 性能测试已完成

## 📚 参考资料

- [Spring Boot官方文档](https://spring.io/projects/spring-boot)
- [Vue 3官方文档](https://vuejs.org/)
- [MySQL官方文档](https://dev.mysql.com/doc/)
- [Redis官方文档](https://redis.io/docs/)
- [Nginx官方文档](https://nginx.org/en/docs/)

## 📞 技术支持

如有问题，请联系：
- 作者：feihu1991
- GitHub：https://github.com/feihu1991
- 邮箱：115920877@qq.com

---

**文档版本**：v1.0
**最后更新**：2026-03-01
**文档状态**：草稿
