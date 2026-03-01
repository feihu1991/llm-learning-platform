import service from './index'

// 获取考试试卷
export function getExamPaper(examPaperId: number) {
  return service.get(`/exam/paper/${examPaperId}`)
}

// 提交考试答案
export function submitExam(data: { examPaperId: number; answers: any[]; duration: number }) {
  return service.post('/exam/submit', data)
}

// 获取考试结果
export function getExamResult(resultId: number) {
  return service.get(`/exam/result/${resultId}`)
}

// 获取用户考试记录
export function getUserExams(userId: number) {
  return service.get(`/exam/user/${userId}`)
}

// 获取试卷列表
export function getExamPapers(params?: any) {
  return service.get('/exam/papers', { params })
}

// 创建试卷
export function createExamPaper(data: any) {
  return service.post('/exam/paper', data)
}

// 更新试卷
export function updateExamPaper(examPaperId: number, data: any) {
  return service.put(`/exam/paper/${examPaperId}`, data)
}

// 删除试卷
export function deleteExamPaper(examPaperId: number) {
  return service.delete(`/exam/paper/${examPaperId}`)
}
