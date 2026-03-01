import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { getCourses, getCourseDetail, getCourseProgress } from '@/api/course'

export interface Course {
  id: number
  title: string
  description: string
  coverImage: string
  difficulty: number
  duration: number
  videoUrl: string
  content: string
  status: number
  categoryId: number
  categoryName: string
  teacherId: number
  teacherName: string
  studentCount: number
  rating: number
  createTime: string
  updateTime: string
}

export interface CourseProgress {
  id: number
  userId: number
  courseId: number
  progress: number
  lastStudyTime: string
  studyDuration: number
  isCompleted: boolean
}

export const useCourseStore = defineStore('course', () => {
  // 状态
  const courses = ref<Course[]>([])
  const currentCourse = ref<Course | null>(null)
  const courseProgress = ref<CourseProgress[]>([])
  const loading = ref(false)

  // 计算属性
  const totalCourses = computed(() => courses.value.length)
  const completedCourses = computed(() => 
    courseProgress.value.filter(p => p.isCompleted).length
  )
  const totalStudyDuration = computed(() => 
    courseProgress.value.reduce((sum, p) => sum + p.studyDuration, 0)
  )

  // 获取课程列表
  const fetchCourses = async (params?: any) => {
    loading.value = true
    try {
      const res = await getCourses(params)
      if (res.code === 200) {
        courses.value = res.data.list || []
        return res.data
      }
      return null
    } catch (error) {
      console.error('获取课程列表失败:', error)
      return null
    } finally {
      loading.value = false
    }
  }

  // 获取课程详情
  const fetchCourseDetail = async (courseId: number) => {
    loading.value = true
    try {
      const res = await getCourseDetail(courseId)
      if (res.code === 200) {
        currentCourse.value = res.data
        return res.data
      }
      return null
    } catch (error) {
      console.error('获取课程详情失败:', error)
      return null
    } finally {
      loading.value = false
    }
  }

  // 获取学习进度
  const fetchCourseProgress = async (userId: number) => {
    try {
      const res = await getCourseProgress(userId)
      if (res.code === 200) {
        courseProgress.value = res.data || []
        return res.data
      }
      return null
    } catch (error) {
      console.error('获取学习进度失败:', error)
      return null
    }
  }

  // 更新学习进度
  const updateProgress = async (courseId: number, progress: number, duration: number) => {
    try {
      // 这里应该调用API更新进度
      const existingProgress = courseProgress.value.find(p => p.courseId === courseId)
      if (existingProgress) {
        existingProgress.progress = progress
        existingProgress.studyDuration += duration
        existingProgress.lastStudyTime = new Date().toISOString()
        if (progress >= 100) {
          existingProgress.isCompleted = true
        }
      } else {
        courseProgress.value.push({
          id: Date.now(),
          userId: 0, // 这里应该从用户store获取
          courseId,
          progress,
          lastStudyTime: new Date().toISOString(),
          studyDuration: duration,
          isCompleted: progress >= 100
        })
      }
      return true
    } catch (error) {
      console.error('更新学习进度失败:', error)
      return false
    }
  }

  // 重置状态
  const reset = () => {
    courses.value = []
    currentCourse.value = null
    courseProgress.value = []
    loading.value = false
  }

  return {
    courses,
    currentCourse,
    courseProgress,
    loading,
    totalCourses,
    completedCourses,
    totalStudyDuration,
    fetchCourses,
    fetchCourseDetail,
    fetchCourseProgress,
    updateProgress,
    reset
  }
})
