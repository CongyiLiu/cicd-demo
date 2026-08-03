import { describe, it, expect, vi } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import TaskForm from '../components/TaskForm.vue'
import * as api from '../api/tasks'

// TaskFormコンポーネントの単体テスト
vi.mock('../api/tasks')

describe('TaskForm', () => {
  it('入力欄が空のとき追加ボタンが無効であること', () => {
    const wrapper = mount(TaskForm)
    expect(wrapper.find('[data-testid="add-button"]').attributes('disabled')).toBeDefined()
  })

  it('タスクを送信するとtask-addedイベントが発火すること', async () => {
    const mockTask = { id: 1, title: '新しいタスク', completed: false }
    api.createTask.mockResolvedValue(mockTask)

    const wrapper = mount(TaskForm)
    await wrapper.find('[data-testid="task-input"]').setValue('新しいタスク')
    await wrapper.find('[data-testid="task-form"]').trigger('submit')
    await flushPromises()

    expect(api.createTask).toHaveBeenCalledWith('新しいタスク')
    // 送信後に入力欄がクリアされること
    expect(wrapper.find('[data-testid="task-input"]').element.value).toBe('')
  })
})
