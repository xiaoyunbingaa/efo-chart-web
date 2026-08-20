import { defineConfig } from 'vite'
import path from 'node:path'
import pluginLegacy from '@vitejs/plugin-legacy'
import pluginVue from '@vitejs/plugin-vue'
import pluginVueJsx from '@vitejs/plugin-vue-jsx'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

export default defineConfig(() => ({
  root: path.resolve(process.cwd()),
  plugins: [
    pluginLegacy(),
    pluginVue(),
    pluginVueJsx(),
    AutoImport({ resolvers: [ElementPlusResolver()] }),
    Components({ resolvers: [ElementPlusResolver()] }),
  ],
  publicDir: path.resolve(process.cwd(), './assets'),
  resolve: {
    alias: {
      '@': path.resolve(process.cwd(), './src'),
    },
  },
  envDir: path.resolve(process.cwd(), './env'),
}))
