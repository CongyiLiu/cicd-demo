import { describe, it, expect, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import TaskList from '../components/TaskList.vue'
import * as api from '../api/tasks'

// TaskListコンポーネントの単体テスト
vi.mock('../api/tasks')

describe('TaskList', () => {
  it('タスクが空のとき「タスクがありません」を表示すること', () => {
    const wrapper = mount(TaskList, { props: { tasks: [] } })
    expect(wrapper.text()).toContain('タスクがありません')
  })

  it('タスク一覧を表示できること', () => {
    const tasks = [
      { id: 1, title: 'タスクA', completed: false },
      { id: 2, title: 'タスクB', completed: true },
    ]
    const wrapper = mount(TaskList, { props: { tasks } })
    expect(wrapper.findAll('[data-testid="task-item"]')).toHaveLength(2)
    expect(wrapper.text()).toContain('タスクA')
  })

  it('完了済みタスクにcompletedクラスが付くこと', () => {
    const tasks = [{ id: 1, title: '完了タスク', completed: true }]
    const wrapper = mount(TaskList, { props: { tasks } })
    expect(wrapper.find('[data-testid="task-item"]').classes()).toContain('completed')
  })

  it('削除ボタンクリックでtask-deletedイベントが発火すること', async () => {
    api.deleteTask.mockResolvedValue({})
    const tasks = [{ id: 1, title: 'タスク', completed: false }]
    const wrapper = mount(TaskList, { props: { tasks } })
    await wrapper.find('[data-testid="delete-button"]').trigger('click')
    expect(wrapper.emitted('task-deleted')).toBeTruthy()
  })
})
