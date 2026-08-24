import { defineConfig } from 'vite'
import proxy from './config/dev.proxy.ts'

export default defineConfig(() => ({
  server: {
    host: '0.0.0.0',
    port: 8080,
    open: true,
    proxy,
    hmr: {
      overlay: true,
    }
  },
}))
