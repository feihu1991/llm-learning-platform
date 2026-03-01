import api from './index'

export interface Course {
  id: number
  title: string
  description: string
  coverImage?: string
  category: string
  difficulty: 'BEGINNER' | 'INTERMEDIATE' | 'ADVANCED'
  duration: number
  videoUrl?: string
  content?: string
  status: number
  createdBy: number
  createTime: string
  updateTime: string
}

export interface CourseListRequest {
  page?: number
  size?: number
  category?: string
  difficulty?: string
  search?: string
}

export interface CourseCreateRequest {
  title: string
  description: string
  coverImage?: string
  category: string
  difficulty: 'BEGINNER' | 'INTERMEDIATE' | 'ADVANCED'
  duration: number
  videoUrl?: string
  content?: string
}

export interface CourseUpdateRequest {
  title?: string
  description?: string
  coverImage?: string
  category?: string
  difficulty?: 'BEGINNER' | 'INTERMEDIATE' | 'ADVANCED'
  duration?: number
  videoUrl?: string
  content?: string
  status?: number
}

// 获取课程列表
export const getCourses = (params: CourseListRequest = {}) => {
  return api.get('/courses', { params })
}

// 获取课程详情
export const getCourseById = (id: number) => {
  return api.get(`/courses/${id}`)
}

// 创建课程
export const createCourse = (data: CourseCreateRequest) => {
  return api.post('/courses', data)
}

// 更新课程
export const updateCourse = (id: number, data: CourseUpdateRequest) => {
  return api.put(`/courses/${id}`, data)
}

// 删除课程
export const deleteCourse = (id: number) => {
  return api.delete(`/courses/${id}`)
}

// 获取课程分类
export const getCourseCategories = () => {
  return api.get('/courses/categories')
}

// 获取课程难度统计
export const getCourseDifficultyStats = () => {
  return api.get('/courses/difficulty-stats')
}