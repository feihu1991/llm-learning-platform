# 在线大模型学习平台 - 前端

> 基于 Vue 3 + TypeScript + Element Plus 的前端项目

## 技术栈

- **框架**: Vue 3
- **语言**: TypeScript
- **UI库**: Element Plus
- **状态管理**: Pinia
- **路由**: Vue Router
- **HTTP**: Axios
- **样式**: SCSS

## 项目结构

```
frontend/
├── public/                 # 静态资源
├── src/
│   ├── api/               # API接口
│   ├── assets/            # 静态资源
│   ├── components/        # 公共组件
│   ├── router/            # 路由配置
│   ├── store/             # Pinia状态管理
│   ├── views/             # 页面视图
│   ├── App.vue            # 根组件
│   └── main.ts            # 入口文件
├── .env.development       # 开发环境变量
├── .env.production        # 生产环境变量
├── .gitignore             # Git忽略文件
├── package.json           # 项目依赖
├── tsconfig.json          # TypeScript配置
└── vue.config.js          # Vue CLI配置
```

## 开发指南

### 安装依赖

```bash
npm install
```

### 开发环境运行

```bash
npm run serve
```

### 生产环境构建

```bash
npm run build
```

### 代码检查

```bash
npm run lint
```

## 环境变量

- `VUE_APP_API_BASE_URL`: API基础URL
- `VUE_APP_TITLE`: 应用标题

## 路由配置

- `/` - 首页
- `/login` - 登录页
- `/register` - 注册页
- `/courses` - 课程列表
- `/course/:id` - 课程详情
- `/exam/:id` - 考试页面
- `/profile` - 个人中心
- `/admin` - 管理后台

## 状态管理

### 用户Store (user)
- `token`: 用户令牌
- `userInfo`: 用户信息
- `isLogin`: 是否登录
- `isAdmin`: 是否管理员
- `loginAction`: 登录
- `registerAction`: 注册
- `logout`: 退出登录

### 课程Store (course)
- `courses`: 课程列表
- `currentCourse`: 当前课程
- `courseProgress`: 学习进度
- `fetchCourses`: 获取课程列表
- `fetchCourseDetail`: 获取课程详情
- `updateProgress`: 更新学习进度

### 考试Store (exam)
- `currentExam`: 当前考试
- `userAnswers`: 用户答案
- `examResult`: 考试结果
- `fetchExamPaper`: 获取考试试卷
- `submitAnswer`: 提交答案
- `submitExamAction`: 提交考试

## API接口

### 用户相关
- `login`: 登录
- `register`: 注册
- `getUserInfo`: 获取用户信息
- `updateUserInfo`: 更新用户信息
- `updatePassword`: 更新密码

### 课程相关
- `getCourses`: 获取课程列表
- `getCourseDetail`: 获取课程详情
- `getCourseProgress`: 获取学习进度
- `updateCourseProgress`: 更新学习进度

### 考试相关
- `getExamPaper`: 获取考试试卷
- `submitExam`: 提交考试
- `getExamResult`: 获取考试结果

## 开发注意事项

1. 所有API请求都通过Axios实例发送，自动添加认证Token
2. 使用Pinia进行状态管理，保持状态的可预测性
3. 使用Element Plus组件库，保持UI风格一致
4. 使用TypeScript进行类型检查，提高代码质量
5. 使用SCSS进行样式编写，提高样式的可维护性

## 部署说明

### 开发环境
```bash
npm run serve
```
访问: http://localhost:8081

### 生产环境
```bash
npm run build
```
将`dist`目录部署到Web服务器

## 贡献指南

1. Fork项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 创建Pull Request

## 许可证

MIT License

## 作者

feihu1991

## 项目地址

https://github.com/feihu1991/llm-learning-platform
