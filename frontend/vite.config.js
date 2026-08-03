import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  // GitHub Pagesデプロイ時のサブパス（環境変数で上書き可能）
  base: process.env.VITE_BASE_URL || '/',
  test: {
    environment: 'jsdom',
    globals: true,
    // e2eディレクトリはPlaywrightが担当するため除外
    exclude: ['e2e/**', 'node_modules/**'],
  },
})
