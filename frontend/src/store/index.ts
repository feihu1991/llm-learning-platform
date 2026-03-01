import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useUserStore = defineStore('user', () => {
  const user = ref<any>(null)
  const token = ref<string | null>(null)
  const loading = ref(false)

  const isLoggedIn = computed(() => !!token.value)
  const isAdmin = computed(() => user.value?.role === 1)

  const login = async (credentials: { username: string; password: string }) => {
    loading.value = true
    try {
      // 模拟登录
      const response = await fetch('/api/user/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(credentials)
      })
      
      if (response.ok) {
        const data = await response.json()
        token.value = data.token
        user.value = data.user
        localStorage.setItem('token', data.token)
        localStorage.setItem('user', JSON.stringify(data.user))
        return true
      }
      return false
    } catch (error) {
      console.error('登录失败:', error)
      return false
    } finally {
      loading.value = false
    }
  }

  const register = async (userData: { username: string; email: string; password: string }) => {
    loading.value = true
    try {
      const response = await fetch('/api/user/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(userData)
      })
      
      if (response.ok) {
        return true
      }
      return false
    } catch (error) {
      console.error('注册失败:', error)
      return false
    } finally {
      loading.value = false
    }
  }

  const logout = () => {
    token.value = null
    user.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('user')
  }

  const fetchUserInfo = async () => {
    if (!token.value) return
    
    loading.value = true
    try {
      const response = await fetch('/api/user/info', {
        headers: { 'Authorization': `Bearer ${token.value}` }
      })
      
      if (response.ok) {
        const data = await response.json()
        user.value = data
        localStorage.setItem('user', JSON.stringify(data))
      }
    } catch (error) {
      console.error('获取用户信息失败:', error)
    } finally {
      loading.value = false
    }
  }

  const updateUserInfo = async (userData: any) => {
    if (!token.value) return false
    
    loading.value = true
    try {
      const response = await fetch('/api/user/info', {
        method: 'PUT',
        headers: { 
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token.value}`
        },
        body: JSON.stringify(userData)
      })
      
      if (response.ok) {
        const data = await response.json()
        user.value = data
        localStorage.setItem('user', JSON.stringify(data))
        return true
      }
      return false
    } catch (error) {
      console.error('更新用户信息失败:', error)
      return false
    } finally {
      loading.value = false
    }
  }

  // 从localStorage恢复状态
  const restoreState = () => {
    const storedToken = localStorage.getItem('token')
    const storedUser = localStorage.getItem('user')
    
    if (storedToken) {
      token.value = storedToken
    }
    if (storedUser) {
      user.value = JSON.parse(storedUser)
    }
  }

  return {
    user,
    token,
    loading,
    isLoggedIn,
    isAdmin,
    login,
    register,
    logout,
    fetchUserInfo,
    updateUserInfo,
    restoreState
  }
})

export const useCourseStore = defineStore('course', () => {
  const courses = ref<any[]>([])
  const currentCourse = ref<any>(null)
  const loading = ref(false)

  const fetchCourses = async (params?: { category?: string; difficulty?: string; search?: string }) => {
    loading.value = true
    try {
      const queryParams = new URLSearchParams()
      if (params?.category) queryParams.append('category', params.category)
      if (params?.difficulty) queryParams.append('difficulty', params.difficulty)
      if (params?.search) queryParams.append('search', params.search)
      
      const response = await fetch(`/api/courses?${queryParams.toString()}`)
      
      if (response.ok) {
        const data = await response.json()
        courses.value = data
      }
    } catch (error) {
      console.error('获取课程列表失败:', error)
    } finally {
      loading.value = false
    }
  }

  const fetchCourseById = async (id: string) => {
    loading.value = true
    try {
      const response = await fetch(`/api/courses/${id}`)
      
      if (response.ok) {
        const data = await response.json()
        currentCourse.value = data
        return data
      }
    } catch (error) {
      console.error('获取课程详情失败:', error)
    } finally {
      loading.value = false
    }
  }

  return {
    courses,
    currentCourse,
    loading,
    fetchCourses,
    fetchCourseById
  }
})