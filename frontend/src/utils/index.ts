import dayjs from 'dayjs'

// 格式化日期
export const formatDate = (date: string | Date, format: string = 'YYYY-MM-DD HH:mm:ss') => {
  return dayjs(date).format(format)
}

// 格式化时长（分钟）
export const formatDuration = (minutes: number) => {
  if (minutes < 60) {
    return `${minutes}分钟`
  }
  const hours = Math.floor(minutes / 60)
  const mins = minutes % 60
  return `${hours}小时${mins > 0 ? mins + '分钟' : ''}`
}

// 格式化文件大小
export const formatFileSize = (bytes: number) => {
  if (bytes === 0) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

// 防抖函数
export const debounce = <T extends (...args: any[]) => any>(
  func: T,
  wait: number
): ((...args: Parameters<T>) => void) => {
  let timeout: NodeJS.Timeout | null = null
  return (...args: Parameters<T>) => {
    if (timeout) clearTimeout(timeout)
    timeout = setTimeout(() => {
      func(...args)
    }, wait)
  }
}

// 节流函数
export const throttle = <T extends (...args: any[]) => any>(
  func: T,
  limit: number
): ((...args: Parameters<T>) => void) => {
  let inThrottle = false
  return (...args: Parameters<T>) => {
    if (!inThrottle) {
      func(...args)
      inThrottle = true
      setTimeout(() => (inThrottle = false), limit)
    }
  }
}

// 验证邮箱
export const validateEmail = (email: string): boolean => {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return re.test(email)
}

// 验证手机号
export const validatePhone = (phone: string): boolean => {
  const re = /^1[3-9]\d{9}$/
  return re.test(phone)
}

// 验证密码强度
export const validatePassword = (password: string): { valid: boolean; message: string } => {
  if (password.length < 8) {
    return { valid: false, message: '密码长度至少8位' }
  }
  if (!/[A-Z]/.test(password)) {
    return { valid: false, message: '密码必须包含大写字母' }
  }
  if (!/[a-z]/.test(password)) {
    return { valid: false, message: '密码必须包含小写字母' }
  }
  if (!/\d/.test(password)) {
    return { valid: false, message: '密码必须包含数字' }
  }
  return { valid: true, message: '密码强度足够' }
}

// 生成随机ID
export const generateId = (): string => {
  return Math.random().toString(36).substring(2, 15)
}

// 复制到剪贴板
export const copyToClipboard = async (text: string): Promise<boolean> => {
  try {
    await navigator.clipboard.writeText(text)
    return true
  } catch (error) {
    console.error('复制失败:', error)
    return false
  }
}

// 下载文件
export const downloadFile = (content: string, filename: string, contentType: string) => {
  const blob = new Blob([content], { type: contentType })
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  URL.revokeObjectURL(url)
}

// 获取URL参数
export const getUrlParams = (): Record<string, string> => {
  const params: Record<string, string> = {}
  const searchParams = new URLSearchParams(window.location.search)
  searchParams.forEach((value, key) => {
    params[key] = value
  })
  return params
}

// 设置URL参数
export const setUrlParams = (params: Record<string, string>) => {
  const searchParams = new URLSearchParams()
  Object.entries(params).forEach(([key, value]) => {
    if (value) searchParams.set(key, value)
  })
  const newUrl = `${window.location.pathname}?${searchParams.toString()}`
  window.history.replaceState({}, '', newUrl)
}

// 清除URL参数
export const clearUrlParams = () => {
  window.history.replaceState({}, '', window.location.pathname)
}