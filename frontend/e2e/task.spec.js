import { test, expect } from '@playwright/test'

// タスク管理のE2Eテスト（バックエンドとフロントエンドが起動済みの状態で実行）
test.describe('タスク管理システム', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
  })

  test('タスクの追加・完了・削除の一連の操作ができること', async ({ page }) => {
    // タスクを追加
    await page.fill('[data-testid="task-input"]', 'E2Eテストタスク')
    await page.click('[data-testid="add-button"]')

    // タスクが表示されること
    await expect(page.locator('[data-testid="task-item"]').first()).toContainText('E2Eテストタスク')

    // 完了にする
    await page.locator('[data-testid="complete-button"]').first().click()
    await expect(page.locator('[data-testid="task-item"]').first()).toHaveClass(/completed/)

    // 削除する
    await page.locator('[data-testid="delete-button"]').first().click()
    await expect(page.locator('[data-testid="task-item"]')).toHaveCount(0)
  })

  test('空のタイトルではタスクを追加できないこと', async ({ page }) => {
    await expect(page.locator('[data-testid="add-button"]')).toBeDisabled()
  })
})
