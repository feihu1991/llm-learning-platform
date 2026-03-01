import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { login, register, getUserInfo, updateUserInfo, updatePassword } from '@/api/user'

export interface User {
  id: number
  username: string
  nickname: string
  avatar: string
  email: string
  phone: string
  gender: number
  birthday: string
  bio: string
  status: number
  role: number
  learningDuration: number
  points: number
  achievementCount: number
  createTime: string
  updateTime: string
}

export const useUserStore = defineStore('user', () => {
  // 状态
  const token = ref<string>(localStorage.getItem('token') || '')
  const userInfo = ref<User | null>(null)
  const isLogin = computed(() => !!token.value)
  const isAdmin = computed(() => userInfo.value?.role === 1)

  // 获取用户信息
  const fetchUserInfo = async () => {
    if (!token.value) return

    try {
      const res = await getUserInfo()
      if (res.data) {
        userInfo.value = res.data
        localStorage.setItem('userInfo', JSON.stringify(res.data))
      }
    } catch (error) {
      console.error('获取用户信息失败:', error)
    }
  }

  // 登录
  const loginAction = async (username: string, password: string) => {
    try {
      const res = await login({ username, password })
      if (res.code === 200) {
        token.value = res.data.token
        localStorage.setItem('token', res.data.token)
        await fetchUserInfo()
        return true
      }
      return false
    } catch (error) {
      console.error('登录失败:', error)
      return false
    }
  }

  // 注册
  const registerAction = async (userData: any) => {
    try {
      const res = await register(userData)
      return res.code === 200
    } catch (error) {
      console.error('注册失败:', error)
      return false
    }
  }

  // 更新用户信息
  const updateUserInfoAction = async (userData: Partial<User>) => {
    try {
      const res = await updateUserInfo(userData)
      if (res.code === 200) {
        if (userInfo.value) {
          userInfo.value = { ...userInfo.value, ...userData }
          localStorage.setItem('userInfo', JSON.stringify(userInfo.value))
        }
        return true
      }
      return false
    } catch (error) {
      console.error('更新用户信息失败:', error)
      return false
    }
  }

  // 更新密码
  const updatePasswordAction = async (oldPassword: string, newPassword: string) => {
    try {
      const res = await updatePassword({
        userId: userInfo.value?.id,
        oldPassword,
        newPassword
      })
      return res.code === 200
    } catch (error) {
      console.error('更新密码失败:', error)
      return false
    }
  }

  // 退出登录
  const logout = () => {
    token.value = ''
    userInfo.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
  }

  // 初始化
  const init = () => {
    const storedUserInfo = localStorage.getItem('userInfo')
    if (storedUserInfo) {
      userInfo.value = JSON.parse(storedUserInfo)
    }
  }

  return {
    token,
    userInfo,
    isLogin,
    isAdmin,
    fetchUserInfo,
    loginAction,
    registerAction,
    updateUserInfoAction,
    updatePasswordAction,
    logout,
    init
  }
})
