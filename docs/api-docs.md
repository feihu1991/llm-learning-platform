# 在线大模型学习平台 - API文档

## 📋 API概览

本项目提供RESTful API接口，支持前后端分离架构。

## 🔐 认证方式

所有API请求都需要携带JWT Token：

```
Authorization: Bearer <token>
```

## 📁 API模块

### 1. 用户模块

#### 1.1 用户注册
```
POST /api/user/register
```

**请求体：**
```json
{
  "username": "string",
  "email": "string",
  "password": "string",
  "phone": "string"
}
```

**响应：**
```json
{
  "code": 200,
  "message": "注册成功",
  "data": {
    "id": 1,
    "username": "string",
    "email": "string"
  }
}
```

#### 1.2 用户登录
```
POST /api/user/login
```

**请求体：**
```json
{
  "username": "string",
  "password": "string"
}
```

**响应：**
```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "username": "string",
      "email": "string",
      "role": "STUDENT"
    }
  }
}
```

#### 1.3 获取用户信息
```
GET /api/user/info
```

**响应：**
```json
{
  "code": 200,
  "message": "成功",
  "data": {
    "id": 1,
    "username": "string",
    "email": "string",
    "phone": "string",
    "avatar": "string",
    "role": "STUDENT",
    "created_at": "2026-03-01T00:00:00"
  }
}
```

#### 1.4 更新用户信息
```
PUT /api/user/info
```

**请求体：**
```json
{
  "email": "string",
  "phone": "string",
  "avatar": "string"
}
```

**响应：**
```json
{
  "code": 200,
  "message": "更新成功"
}
```

### 2. 课程模块

#### 2.1 课程列表
```
GET /api/courses
```

**查询参数：**
- `page` - 页码（默认1）
- `size` - 每页数量（默认10）
- `category` - 分类筛选
- `difficulty` - 难度筛选
- `keyword` - 关键词搜索

**响应：**
```json
{
  "code": 200,
  "message": "成功",
  "data": {
    "list": [
      {
        "id": 1,
        "title": "Python基础入门",
        "description": "从零开始学习Python编程语言",
        "cover_image": "string",
        "category": "基础",
        "difficulty": "BEGINNER",
        "duration": 120,
        "progress": 50,
        "question_count": 10
      }
    ],
    "total": 100,
    "page": 1,
    "size": 10
  }
}
```

#### 2.2 课程详情
```
GET /api/courses/{id}
```

**响应：**
```json
{
  "code": 200,
  "message": "成功",
  "data": {
    "id": 1,
    "title": "Python基础入门",
    "description": "从零开始学习Python编程语言",
    "cover_image": "string",
    "category": "基础",
    "difficulty": "BEGINNER",
    "duration": 120,
    "video_url": "string",
    "content": "课程内容（Markdown）",
    "question_count": 10,
    "progress": 50,
    "created_by": {
      "id": 1,
      "username": "admin"
    },
    "created_at": "2026-03-01T00:00:00"
  }
}
```

#### 2.3 创建课程（管理员）
```
POST /api/courses
```

**请求体：**
```json
{
  "title": "string",
  "description": "string",
  "cover_image": "string",
  "category": "string",
  "difficulty": "BEGINNER|INTERMEDIATE|ADVANCED",
  "duration": 60,
  "video_url": "string",
  "content": "string"
}
```

**响应：**
```json
{
  "code": 200,
  "message": "创建成功",
  "data": {
    "id": 1,
    "title": "string"
  }
}
```

#### 2.4 更新课程
```
PUT /api/courses/{id}
```

**请求体：**
```json
{
  "title": "string",
  "description": "string",
  "cover_image": "string",
  "category": "string",
  "difficulty": "BEGINNER|INTERMEDIATE|ADVANCED",
  "duration": 60,
  "video_url": "string",
  "content": "string"
}
```

**响应：**
```json
{
  "code": 200,
  "message": "更新成功"
}
```

#### 2.5 删除课程
```
DELETE /api/courses/{id}
```

**响应：**
```json
{
  "code": 200,
  "message": "删除成功"
}
```

### 3. 试题模块

#### 3.1 试题列表
```
GET /api/questions
```

**查询参数：**
- `course_id` - 课程ID（必填）
- `type` - 试题类型
- `difficulty` - 难度
- `page` - 页码
- `size` - 每页数量

**响应：**
```json
{
  "code": 200,
  "message": "成功",
  "data": {
    "list": [
      {
        "id": 1,
        "course_id": 1,
        "type": "SINGLE_CHOICE",
        "difficulty": "EASY",
        "content": "Python中定义函数的关键字是？",
        "options": {
          "A": "function",
          "B": "def",
          "C": "func",
          "D": "define"
        },
        "score": 10,
        "tags": "基础,函数"
      }
    ],
    "total": 50,
    "page": 1,
    "size": 10
  }
}
```

#### 3.2 试题详情
```
GET /api/questions/{id}
```

**响应：**
```json
{
  "code": 200,
  "message": "成功",
  "data": {
    "id": 1,
    "course_id": 1,
    "type": "SINGLE_CHOICE",
    "difficulty": "EASY",
    "content": "Python中定义函数的关键字是？",
    "options": {
      "A": "function",
      "B": "def",
      "C": "func",
      "D": "define"
    },
    "correct_answer": "B",
    "explanation": "Python使用def关键字定义函数",
    "score": 10,
    "tags": "基础,函数"
  }
}
```

#### 3.3 创建试题
```
POST /api/questions
```

**请求体：**
```json
{
  "course_id": 1,
  "type": "SINGLE_CHOICE|MULTIPLE_CHOICE|TRUE_FALSE|FILL_BLANK|SHORT_ANSWER|CODE",
  "difficulty": "EASY|MEDIUM|HARD",
  "content": "string",
  "options": {
    "A": "string",
    "B": "string"
  },
  "correct_answer": "string",
  "explanation": "string",
  "tags": "string",
  "score": 10
}
```

**响应：**
```json
{
  "code": 200,
  "message": "创建成功",
  "data": {
    "id": 1
  }
}
```

#### 3.4 更新试题
```
PUT /api/questions/{id}
```

**请求体：**
```json
{
  "type": "SINGLE_CHOICE",
  "difficulty": "EASY",
  "content": "string",
  "options": {
    "A": "string",
    "B": "string"
  },
  "correct_answer": "string",
  "explanation": "string",
  "tags": "string",
  "score": 10
}
```

**响应：**
```json
{
  "code": 200,
  "message": "更新成功"
}
```

#### 3.5 删除试题
```
DELETE /api/questions/{id}
```

**响应：**
```json
{
  "code": 200,
  "message": "删除成功"
}
```

### 4. 答题模块

#### 4.1 提交答案
```
POST /api/answers/submit
```

**请求体：**
```json
{
  "question_id": 1,
  "answer": "string"
}
```

**响应：**
```json
{
  "code": 200,
  "message": "提交成功",
  "data": {
    "answer_id": 1,
    "status": "PENDING",
    "score": null
  }
}
```

#### 4.2 答题历史
```
GET /api/answers/history
```

**查询参数：**
- `course_id` - 课程ID
- `page` - 页码
- `size` - 每页数量

**响应：**
```json
{
  "code": 200,
  "message": "成功",
  "data": {
    "list": [
      {
        "id": 1,
        "question_id": 1,
        "question_content": "Python中定义函数的关键字是？",
        "answer": "B",
        "score": 10,
        "status": "CORRECT",
        "created_at": "2026-03-01T00:00:00"
      }
    ],
    "total": 100,
    "page": 1,
    "size": 10
  }
}
```

#### 4.3 评分（教师）
```
POST /api/answers/grade
```

**请求体：**
```json
{
  "answer_id": 1,
  "score": 8,
  "comment": "回答基本正确，但不够完整"
}
```

**响应：**
```json
{
  "code": 200,
  "message": "评分成功"
}
```

### 5. 学习进度模块

#### 5.1 学习进度
```
GET /api/progress/{course_id}
```

**响应：**
```json
{
  "code": 200,
  "message": "成功",
  "data": {
    "course_id": 1,
    "course_title": "Python基础入门",
    "progress": 50,
    "total_duration": 120,
    "last_accessed": "2026-03-01T00:00:00",
    "completed_at": null,
    "question_stats": {
      "total": 10,
      "answered": 5,
      "correct": 4,
      "incorrect": 1
    }
  }
}
```

#### 5.2 更新进度
```
PUT /api/progress/{course_id}
```

**请求体：**
```json
{
  "progress": 60,
  "total_duration": 150
}
```

**响应：**
```json
{
  "code": 200,
  "message": "更新成功"
}
```

#### 5.3 学习统计
```
GET /api/progress/stats
```

**响应：**
```json
{
  "code": 200,
  "message": "成功",
  "data": {
    "total_courses": 5,
    "completed_courses": 2,
    "total_duration": 360,
    "total_questions": 50,
    "total_correct": 40,
    "accuracy_rate": 80,
    "achievements": [
      {
        "type": "COURSE_COMPLETE",
        "name": "Python入门完成",
        "achieved_at": "2026-03-01T00:00:00"
      }
    ]
  }
}
```

### 6. 试卷模块

#### 6.1 创建试卷
```
POST /api/exams
```

**请求体：**
```json
{
  "course_id": 1,
  "title": "Python基础测试",
  "description": "测试Python基础知识",
  "duration": 60,
  "question_types": {
    "SINGLE_CHOICE": 5,
    "MULTIPLE_CHOICE": 3,
    "TRUE_FALSE": 2,
    "FILL_BLANK": 2,
    "SHORT_ANSWER": 2,
    "CODE": 1
  }
}
```

**响应：**
```json
{
  "code": 200,
  "message": "创建成功",
  "data": {
    "exam_id": 1,
    "title": "Python基础测试",
    "total_score": 150,
    "duration": 60,
    "question_count": 15
  }
}
```

#### 6.2 开始考试
```
POST /api/exams/{exam_id}/start
```

**响应：**
```json
{
  "code": 200,
  "message": "考试开始",
  "data": {
    "user_exam_id": 1,
    "start_time": "2026-03-01T00:00:00",
    "end_time": "2026-03-01T01:00:00",
    "questions": [
      {
        "id": 1,
        "type": "SINGLE_CHOICE",
        "content": "Python中定义函数的关键字是？",
        "options": {
          "A": "function",
          "B": "def",
          "C": "func",
          "D": "define"
        },
        "score": 10
      }
    ]
  }
}
```

#### 6.3 提交试卷
```
POST /api/exams/{exam_id}/submit
```

**请求体：**
```json
{
  "answers": [
    {
      "question_id": 1,
      "answer": "B"
    }
  ]
}
```

**响应：**
```json
{
  "code": 200,
  "message": "提交成功",
  "data": {
    "user_exam_id": 1,
    "total_score": 130,
    "status": "GRADED"
  }
}
```

#### 6.4 考试结果
```
GET /api/exams/{exam_id}/result
```

**响应：**
```json
{
  "code": 200,
  "message": "成功",
  "data": {
    "exam_id": 1,
    "exam_title": "Python基础测试",
    "total_score": 150,
    "user_score": 130,
    "accuracy_rate": 86.7,
    "duration": 45,
    "details": [
      {
        "question_id": 1,
        "type": "SINGLE_CHOICE",
        "content": "Python中定义函数的关键字是？",
        "user_answer": "B",
        "correct_answer": "B",
        "score": 10,
        "status": "CORRECT",
        "explanation": "Python使用def关键字定义函数"
      }
    ]
  }
}
```

### 7. 笔记模块

#### 7.1 创建笔记
```
POST /api/notes
```

**请求体：**
```json
{
  "course_id": 1,
  "question_id": 1,
  "content": "学习笔记内容",
  "tags": "Python,函数"
}
```

**响应：**
```json
{
  "code": 200,
  "message": "创建成功",
  "data": {
    "id": 1
  }
}
```

#### 7.2 获取笔记
```
GET /api/notes
```

**查询参数：**
- `course_id` - 课程ID
- `question_id` - 试题ID
- `page` - 页码
- `size` - 每页数量

**响应：**
```json
{
  "code": 200,
  "message": "成功",
  "data": {
    "list": [
      {
        "id": 1,
        "course_id": 1,
        "question_id": 1,
        "content": "学习笔记内容",
        "tags": "Python,函数",
        "created_at": "2026-03-01T00:00:00"
      }
    ],
    "total": 10,
    "page": 1,
    "size": 10
  }
}
```

### 8. 成就模块

#### 8.1 获取成就
```
GET /api/achievements
```

**响应：**
```json
{
  "code": 200,
  "message": "成功",
  "data": {
    "list": [
      {
        "id": 1,
        "type": "COURSE_COMPLETE",
        "name": "Python入门完成",
        "description": "完成Python基础入门课程",
        "badge_image": "string",
        "achieved_at": "2026-03-01T00:00:00"
      }
    ],
    "total": 5
  }
}
```

## 🔧 错误码

| 错误码 | 描述 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未授权 |
| 403 | 禁止访问 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

## 📝 请求示例

### 使用cURL
```bash
# 登录
curl -X POST http://localhost:8080/api/user/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# 获取课程列表（需要Token）
curl -X GET "http://localhost:8080/api/courses?page=1&size=10" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### 使用JavaScript
```javascript
// 登录
fetch('http://localhost:8080/api/user/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    username: 'admin',
    password: 'admin123'
  })
})
.then(response => response.json())
.then(data => console.log(data));

// 获取课程列表
fetch('http://localhost:8080/api/courses?page=1&size=10', {
  headers: {
    'Authorization': 'Bearer ' + token
  }
})
.then(response => response.json())
.then(data => console.log(data));
```

## 📚 数据模型

### 通用响应格式
```json
{
  "code": 200,
  "message": "成功",
  "data": {}
}
```

### 分页格式
```json
{
  "code": 200,
  "message": "成功",
  "data": {
    "list": [],
    "total": 100,
    "page": 1,
    "size": 10
  }
}
```

## 🔒 安全说明

1. **JWT Token**：所有需要认证的接口必须携带JWT Token
2. **密码加密**：密码使用BCrypt加密存储
3. **权限控制**：不同角色有不同的访问权限
4. **输入验证**：所有输入参数都会进行验证和过滤
5. **SQL注入防护**：使用MyBatis Plus防止SQL注入

## 🚀 性能优化

1. **缓存策略**：热门课程和试题使用Redis缓存
2. **分页查询**：大数据量使用分页查询
3. **索引优化**：常用查询字段建立索引
4. **连接池**：使用HikariCP连接池
5. **异步处理**：耗时操作使用异步处理

## 📊 监控指标

- API响应时间
- 请求成功率
- 并发连接数
- 数据库连接数
- 缓存命中率

## 📝 版本历史

| 版本 | 日期 | 说明 |
|------|------|------|
| v1.0 | 2026-03-01 | 初始版本，基础API设计 |
