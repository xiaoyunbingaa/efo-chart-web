import { defineConfig, mergeConfig } from 'vite'
import commonConfig from './vite.common.config.ts'
import devConfig from './vite.dev.config.ts'
import prodConfig from './vite.prod.config.ts'

export default defineConfig(async ({ command, mode }) => {
  const environmentConfig = command === 'serve' ? devConfig : prodConfig

  return mergeConfig(
    await commonConfig({ command, mode }),
    await environmentConfig({ command, mode }),
  )
})