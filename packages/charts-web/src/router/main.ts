import type { RouteRecordRaw } from 'vue-router'
import Main from '@/view/main.vue'

export const routes: RouteRecordRaw[] = [
    {
        path: '/',
        name: 'main',
        component: Main
    }
]
