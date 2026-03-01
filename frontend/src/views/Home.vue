<template>
  <div class="home-container">
    <!-- 导航栏 -->
    <el-header class="header">
      <div class="header-content">
        <div class="logo">
          <h1>在线大模型学习平台</h1>
        </div>
        <div class="nav-menu">
          <el-menu
            :default-active="$route.path"
            mode="horizontal"
            router
            class="nav-menu"
          >
            <el-menu-item index="/">首页</el-menu-item>
            <el-menu-item index="/courses">课程</el-menu-item>
            <el-menu-item index="/exam">考试</el-menu-item>
            <el-menu-item index="/profile" v-if="isLogin">个人中心</el-menu-item>
            <el-menu-item index="/admin" v-if="isAdmin">管理后台</el-menu-item>
          </el-menu>
        </div>
        <div class="user-info">
          <template v-if="isLogin">
            <el-dropdown>
              <span class="user-name">
                {{ userInfo?.nickname || userInfo?.username }}
                <el-icon><ArrowDown /></el-icon>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item @click="goToProfile">个人中心</el-dropdown-item>
                  <el-dropdown-item @click="logout">退出登录</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </template>
          <template v-else>
            <el-button type="text" @click="goToLogin">登录</el-button>
            <el-button type="text" @click="goToRegister">注册</el-button>
          </template>
        </div>
      </div>
    </el-header>

    <!-- 主内容区 -->
    <el-main class="main-content">
      <!-- 英雄区域 -->
      <section class="hero-section">
        <div class="hero-content">
          <h2>开启你的大模型学习之旅</h2>
          <p>从Java转型大模型开发，系统化学习路径，丰富的实战项目</p>
          <el-button type="primary" size="large" @click="goToCourses">
            开始学习
          </el-button>
        </div>
      </section>

      <!-- 特色功能 -->
      <section class="features-section">
        <h3>平台特色</h3>
        <div class="features-grid">
          <div class="feature-card">
            <el-icon><Reading /></el-icon>
            <h4>丰富课程</h4>
            <p>从基础到实战，系统化学习大模型开发</p>
          </div>
          <div class="feature-card">
            <el-icon><EditPen /></el-icon>
            <h4>多样试题</h4>
            <p>6种题型，智能评分，全面检验学习成果</p>
          </div>
          <div class="feature-card">
            <el-icon><Trophy /></el-icon>
            <h4>成就系统</h4>
            <p>学习进度追踪，成就激励，持续进步</p>
          </div>
          <div class="feature-card">
            <el-icon><User /></el-icon>
            <h4>学习社区</h4>
            <p>与同行交流，共同成长</p>
          </div>
        </div>
      </section>

      <!-- 推荐课程 -->
      <section class="courses-section">
        <h3>推荐课程</h3>
        <div class="courses-grid" v-if="courses.length > 0">
          <el-card
            v-for="course in courses.slice(0, 4)"
            :key="course.id"
            class="course-card"
            @click="goToCourse(course.id)"
          >
            <div class="course-cover">
              <img :src="course.coverImage" :alt="course.title" />
            </div>
            <div class="course-info">
              <h4>{{ course.title }}</h4>
              <p class="course-desc">{{ course.description }}</p>
              <div class="course-meta">
                <span class="difficulty">{{ getDifficultyText(course.difficulty) }}</span>
                <span class="duration">{{ course.duration }}分钟</span>
              </div>
            </div>
          </el-card>
        </div>
        <div v-else class="no-courses">
          <p>暂无推荐课程</p>
        </div>
      </section>

      <!-- 学习统计 -->
      <section class="stats-section" v-if="isLogin">
        <h3>我的学习统计</h3>
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-number">{{ userStore.userInfo?.learningDuration || 0 }}</div>
            <div class="stat-label">学习时长（分钟）</div>
          </div>
          <div class="stat-card">
            <div class="stat-number">{{ userStore.userInfo?.points || 0 }}</div>
            <div class="stat-label">积分</div>
          </div>
          <div class="stat-card">
            <div class="stat-number">{{ userStore.userInfo?.achievementCount || 0 }}</div>
            <div class="stat-label">成就数</div>
          </div>
        </div>
      </section>
    </el-main>

    <!-- 页脚 -->
    <el-footer class="footer">
      <div class="footer-content">
        <p>© 2026 在线大模型学习平台 - feihu1991</p>
        <p>GitHub: https://github.com/feihu1991/llm-learning-platform</p>
      </div>
    </el-footer>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/store/modules/user'
import { useCourseStore } from '@/store/modules/course'

export default defineComponent({
  name: 'Home',
  setup() {
    const router = useRouter()
    const userStore = useUserStore()
    const courseStore = useCourseStore()
    const courses = ref<any[]>([])

    const isLogin = computed(() => userStore.isLogin)
    const isAdmin = computed(() => userStore.isAdmin)
    const userInfo = computed(() => userStore.userInfo)

    const getDifficultyText = (difficulty: number) => {
      const map = { 1: '简单', 2: '中等', 3: '困难' }
      return map[difficulty] || '未知'
    }

    const goToLogin = () => router.push('/login')
    const goToRegister = () => router.push('/register')
    const goToCourses = () => router.push('/courses')
    const goToProfile = () => router.push('/profile')
    const goToCourse = (id: number) => router.push(`/course/${id}`)

    const logout = () => {
      userStore.logout()
      ElMessage.success('已退出登录')
      router.push('/')
    }

    const fetchCourses = async () => {
      const res = await courseStore.fetchCourses({ page: 1, size: 4 })
      if (res && res.list) {
        courses.value = res.list
      }
    }

    onMounted(() => {
      userStore.init()
      fetchCourses()
    })

    return {
      userStore,
      courses,
      isLogin,
      isAdmin,
      userInfo,
      getDifficultyText,
      goToLogin,
      goToRegister,
      goToCourses,
      goToProfile,
      goToCourse,
      logout
    }
  }
})
</script>

<style lang="scss" scoped>
.home-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  background: white;
  border-bottom: 1px solid #ebeef5;
  padding: 0 20px;
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 60px;
  max-width: 1200px;
  margin: 0 auto;
}

.logo h1 {
  font-size: 20px;
  color: #409eff;
  margin: 0;
}

.nav-menu {
  border: none;
  background: transparent;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;

  .user-name {
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 5px;
  }
}

.main-content {
  flex: 1;
  padding: 0;
}

.hero-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 80px 20px;
  text-align: center;

  .hero-content {
    max-width: 800px;
    margin: 0 auto;

    h2 {
      font-size: 36px;
      margin-bottom: 20px;
    }

    p {
      font-size: 18px;
      margin-bottom: 30px;
      opacity: 0.9;
    }
  }
}

.features-section,
.courses-section,
.stats-section {
  padding: 60px 20px;
  max-width: 1200px;
  margin: 0 auto;

  h3 {
    text-align: center;
    font-size: 28px;
    margin-bottom: 40px;
    color: #333;
  }
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 30px;
}

.feature-card {
  background: white;
  border-radius: 12px;
  padding: 30px;
  text-align: center;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s;

  &:hover {
    transform: translateY(-5px);
  }

  .el-icon {
    font-size: 48px;
    color: #409eff;
    margin-bottom: 15px;
  }

  h4 {
    margin: 0 0 10px 0;
    color: #333;
  }

  p {
    margin: 0;
    color: #666;
    font-size: 14px;
  }
}

.courses-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
}

.course-card {
  cursor: pointer;
  transition: transform 0.3s;

  &:hover {
    transform: translateY(-5px);
  }

  .course-cover {
    height: 160px;
    overflow: hidden;
    border-radius: 8px 8px 0 0;

    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  }

  .course-info {
    padding: 15px;

    h4 {
      margin: 0 0 8px 0;
      font-size: 16px;
      color: #333;
    }

    .course-desc {
      margin: 0 0 10px 0;
      font-size: 13px;
      color: #666;
      line-height: 1.5;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .course-meta {
      display: flex;
      justify-content: space-between;
      font-size: 12px;
      color: #999;

      .difficulty {
        padding: 2px 8px;
        border-radius: 4px;
        background: #f5f5f5;
      }
    }
  }
}

.no-courses {
  text-align: center;
  color: #999;
  padding: 40px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 30px;
  text-align: center;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);

  .stat-number {
    font-size: 36px;
    font-weight: bold;
    color: #409eff;
    margin-bottom: 10px;
  }

  .stat-label {
    font-size: 14px;
    color: #666;
  }
}

.footer {
  background: #f5f5f5;
  padding: 20px;
  text-align: center;
  color: #666;
  font-size: 14px;

  p {
    margin: 5px 0;
  }
}
</style>
