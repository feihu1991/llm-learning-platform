import api from './index'

export interface User {
  id: number
  username: string
  email: string
  phone?: string
  avatar?: string
  role: number
  status: number
  learningDuration: number
  points: number
  achievementCount: number
  createTime: string
  updateTime: string
}

export interface LoginRequest {
  username: string
  password: string
}

export interface RegisterRequest {
  username: string
  email: string
  password: string
  phone?: string
}

export interface UpdateUserRequest {
  email?: string
  phone?: string
  avatar?: string
  nickname?: string
  bio?: string
}

// 用户登录
export const login = (data: LoginRequest) => {
  return api.post('/user/login', data)
}

// 用户注册
export const register = (data: RegisterRequest) => {
  return api.post('/user/register', data)
}

// 获取用户信息
export const getUserInfo = () => {
  return api.get('/user/info')
}

// 更新用户信息
export const updateUserInfo = (data: UpdateUserRequest) => {
  return api.put('/user/info', data)
}

// 修改密码
export const changePassword = (data: { oldPassword: string; newPassword: string }) => {
  return api.put('/user/password', data)
}

// 获取用户学习统计
export const getUserStats = () => {
  return api.get('/user/stats')
}

// 获取用户学习历史
export const getUserHistory = (params?: { page?: number; size?: number }) => {
  return api.get('/user/history', { params })
}