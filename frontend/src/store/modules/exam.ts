import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { getExamPaper, submitExam, getExamResult } from '@/api/exam'

export interface Question {
  id: number
  type: number
  content: string
  options: string[]
  correctAnswer: string
  difficulty: number
  score: number
  explanation: string
  tags: string[]
}

export interface ExamPaper {
  id: number
  title: string
  courseId: number
  courseName: string
  difficulty: number
  duration: number
  totalScore: number
  questionCount: number
  questions: Question[]
  createTime: string
}

export interface UserAnswer {
  questionId: number
  answer: string
  score: number
  isCorrect: boolean
}

export interface ExamResult {
  id: number
  examPaperId: number
  userId: number
  totalScore: number
  userScore: number
  passScore: number
  isPassed: boolean
  duration: number
  startTime: string
  endTime: string
  userAnswers: UserAnswer[]
  createTime: string
}

export const useExamStore = defineStore('exam', () => {
  // 状态
  const currentExam = ref<ExamPaper | null>(null)
  const userAnswers = ref<Map<number, string>>(new Map())
  const examResult = ref<ExamResult | null>(null)
  const examStartTime = ref<Date | null>(null)
  const examEndTime = ref<Date | null>(null)
  const loading = ref(false)

  // 计算属性
  const currentScore = computed(() => {
    if (!currentExam.value) return 0
    let score = 0
    currentExam.value.questions.forEach(q => {
      const userAnswer = userAnswers.value.get(q.id)
      if (userAnswer === q.correctAnswer) {
        score += q.score
      }
    })
    return score
  })

  const progress = computed(() => {
    if (!currentExam.value) return 0
    const answeredCount = userAnswers.value.size
    const totalCount = currentExam.value.questions.length
    return totalCount > 0 ? Math.round((answeredCount / totalCount) * 100) : 0
  })

  const timeRemaining = computed(() => {
    if (!examStartTime.value || !currentExam.value) return 0
    const elapsed = Date.now() - examStartTime.value.getTime()
    const total = currentExam.value.duration * 60 * 1000
    const remaining = total - elapsed
    return Math.max(0, Math.floor(remaining / 1000))
  })

  // 获取考试试卷
  const fetchExamPaper = async (examPaperId: number) => {
    loading.value = true
    try {
      const res = await getExamPaper(examPaperId)
      if (res.code === 200) {
        currentExam.value = res.data
        userAnswers.value.clear()
        examStartTime.value = new Date()
        examEndTime.value = null
        return res.data
      }
      return null
    } catch (error) {
      console.error('获取考试试卷失败:', error)
      return null
    } finally {
      loading.value = false
    }
  }

  // 提交答案
  const submitAnswer = async (questionId: number, answer: string) => {
    userAnswers.value.set(questionId, answer)
    return true
  }

  // 提交考试
  const submitExamAction = async () => {
    if (!currentExam.value || !examStartTime.value) {
      return null
    }

    examEndTime.value = new Date()
    const duration = Math.floor((examEndTime.value.getTime() - examStartTime.value.getTime()) / 1000)

    try {
      const answers = Array.from(userAnswers.value.entries()).map(([questionId, answer]) => ({
        questionId,
        answer
      }))

      const res = await submitExam({
        examPaperId: currentExam.value.id,
        answers,
        duration
      })

      if (res.code === 200) {
        examResult.value = res.data
        return res.data
      }
      return null
    } catch (error) {
      console.error('提交考试失败:', error)
      return null
    }
  }

  // 获取考试结果
  const fetchExamResult = async (resultId: number) => {
    loading.value = true
    try {
      const res = await getExamResult(resultId)
      if (res.code === 200) {
        examResult.value = res.data
        return res.data
      }
      return null
    } catch (error) {
      console.error('获取考试结果失败:', error)
      return null
    } finally {
      loading.value = false
    }
  }

  // 重置考试状态
  const resetExam = () => {
    currentExam.value = null
    userAnswers.value.clear()
    examResult.value = null
    examStartTime.value = null
    examEndTime.value = null
  }

  return {
    currentExam,
    userAnswers,
    examResult,
    examStartTime,
    examEndTime,
    loading,
    currentScore,
    progress,
    timeRemaining,
    fetchExamPaper,
    submitAnswer,
    submitExamAction,
    fetchExamResult,
    resetExam
  }
})
