// バックエンドAPIとの通信モジュール
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080'

export const fetchTasks = () =>
  fetch(`${API_URL}/api/tasks`).then(r => r.json())

export const createTask = (title) =>
  fetch(`${API_URL}/api/tasks`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ title }),
  }).then(r => r.json())

export const toggleTask = (id) =>
  fetch(`${API_URL}/api/tasks/${id}/toggle`, { method: 'PUT' }).then(r => r.json())

export const deleteTask = (id) =>
  fetch(`${API_URL}/api/tasks/${id}`, { method: 'DELETE' })
