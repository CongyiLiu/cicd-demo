<script setup>
import { toggleTask, deleteTask } from '../api/tasks'

const props = defineProps({
  tasks: {
    type: Array,
    required: true,
  },
})

const emit = defineEmits(['task-toggled', 'task-deleted'])

const handleToggle = async (task) => {
  const updated = await toggleTask(task.id)
  emit('task-toggled', updated)
}

const handleDelete = async (task) => {
  await deleteTask(task.id)
  emit('task-deleted', task.id)
}
</script>

<template>
  <div class="task-list">
    <p v-if="tasks.length === 0" class="empty">タスクがありません</p>

    <div
      v-for="task in tasks"
      :key="task.id"
      class="task-item"
      :class="{ completed: task.completed }"
      data-testid="task-item"
    >
      <span class="task-title">{{ task.title }}</span>
      <div class="task-actions">
        <button
          class="btn-complete"
          data-testid="complete-button"
          :aria-label="task.completed ? '未完了に戻す' : '完了にする'"
          @click="handleToggle(task)"
        >
          {{ task.completed ? '↩' : '✓' }}
        </button>
        <button
          class="btn-delete"
          data-testid="delete-button"
          aria-label="削除"
          @click="handleDelete(task)"
        >
          ✕
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.task-list { display: flex; flex-direction: column; gap: 0.5rem; }

.empty { text-align: center; color: #999; padding: 2rem; }

.task-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: white;
  border-radius: 8px;
  padding: 1rem 1.2rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  transition: opacity 0.2s;
}

.task-item.completed .task-title {
  text-decoration: line-through;
  color: #999;
}

.task-actions { display: flex; gap: 0.5rem; }

button {
  border: none;
  border-radius: 6px;
  padding: 0.4rem 0.8rem;
  cursor: pointer;
  font-size: 0.9rem;
  transition: background 0.2s;
}

.btn-complete { background: #e8f5e9; color: #388e3c; }
.btn-complete:hover { background: #c8e6c9; }

.btn-delete { background: #fce4ec; color: #c62828; }
.btn-delete:hover { background: #f8bbd0; }
</style>
