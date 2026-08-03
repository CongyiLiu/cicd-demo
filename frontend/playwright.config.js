import { defineConfig } from '@playwright/test'

export default defineConfig({
  testDir: './e2e',
  use: {
    baseURL: 'http://localhost:5173',
  },
  // CI環境でバックエンドとフロントエンドを自動起動してからテストを実行
  webServer: [
    {
      command: 'java -jar ../backend/target/task-manager.jar',
      port: 8080,
      timeout: 60000,
      reuseExistingServer: !process.env.CI,
    },
    {
      command: 'npm run dev',
      port: 5173,
      reuseExistingServer: !process.env.CI,
    },
  ],
})
