<script setup>
import { ref, onMounted } from 'vue'
import TaskForm from './components/TaskForm.vue'
import TaskList from './components/TaskList.vue'
import { fetchTasks } from './api/tasks'

const tasks = ref([])
const loading = ref(false)
const error = ref(null)

const loadTasks = async () => {
  loading.value = true
  error.value = null
  try {
    tasks.value = await fetchTasks()
  } catch {
    error.value = 'バックエンドに接続できませんでした'
  } finally {
    loading.value = false
  }
}

const onTaskAdded = (task) => tasks.value.push(task)

const onTaskToggled = (updated) => {
  const index = tasks.value.findIndex(t => t.id === updated.id)
  if (index !== -1) tasks.value[index] = updated
}

const onTaskDeleted = (id) => {
  tasks.value = tasks.value.filter(t => t.id !== id)
}

onMounted(loadTasks)
</script>

<template>
  <div class="app">
    <header>
      <h1>タスク管理システム</h1>
      <p class="subtitle">GitHub Actions CI/CD デモ</p>
    </header>

    <main>
      <TaskForm @task-added="onTaskAdded" />
      <p v-if="loading" class="loading">読み込み中...</p>
      <p v-else-if="error" class="error">{{ error }}</p>
      <TaskList
        v-else
        :tasks="tasks"
        @task-toggled="onTaskToggled"
        @task-deleted="onTaskDeleted"
      />
    </main>
  </div>
</template>

<style>
* { box-sizing: border-box; margin: 0; padding: 0; }

body {
  font-family: 'Helvetica Neue', Arial, 'Hiragino Kaku Gothic ProN', sans-serif;
  background: #f0f2f5;
  color: #333;
}

.app {
  max-width: 700px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

header {
  text-align: center;
  margin-bottom: 2rem;
}

h1 { font-size: 1.8rem; color: #1a237e; }

.subtitle { color: #666; font-size: 0.9rem; margin-top: 0.3rem; }

.loading { text-align: center; color: #999; padding: 2rem; }

.error { text-align: center; color: #c62828; padding: 1rem; background: #fce4ec; border-radius: 8px; }
</style>
