import '@/common/styles/index.less'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import zhCn from 'element-plus/es/locale/lang/zh-cn'
import 'element-plus/dist/index.css'
import App from '@/view/main.vue'
import router from '@/router/index.ts'
import {useGlobalStore} from '@/store/globalStore.ts'



const bootstrap = async () => {
    
}

bootstrap().then(() => {
    const app = createApp(App)
    const pinia = createPinia()
    app.use(router)
    app.use(pinia)
    app.mount('#vue-app')
})