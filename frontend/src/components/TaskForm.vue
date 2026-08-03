<script setup>
import { ref } from 'vue'
import { createTask } from '../api/tasks'

const emit = defineEmits(['task-added'])
const title = ref('')
const submitting = ref(false)

const handleSubmit = async () => {
  if (!title.value.trim()) return
  submitting.value = true
  const task = await createTask(title.value.trim())
  emit('task-added', task)
  title.value = ''
  submitting.value = false
}
</script>

<template>
  <form class="task-form" data-testid="task-form" @submit.prevent="handleSubmit">
    <input
      v-model="title"
      type="text"
      placeholder="新しいタスクを入力..."
      data-testid="task-input"
      :disabled="submitting"
      aria-label="タスク名"
    />
    <button
      type="submit"
      data-testid="add-button"
      :disabled="!title.trim() || submitting"
    >
      追加
    </button>
  </form>
</template>

<style scoped>
.task-form {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1.5rem;
}

input {
  flex: 1;
  padding: 0.75rem 1rem;
  border: 2px solid #ddd;
  border-radius: 8px;
  font-size: 1rem;
  outline: none;
  transition: border-color 0.2s;
}

input:focus { border-color: #1565c0; }

button {
  padding: 0.75rem 1.5rem;
  background: #1565c0;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s;
}

button:hover:not(:disabled) { background: #0d47a1; }
button:disabled { opacity: 0.5; cursor: not-allowed; }
</style>
