import type { RouteRecordRaw } from 'vue-router'
import App from '@/view/app.vue'
import { defineAsyncComponent } from "vue";

const guideView = defineAsyncComponent(() => import('@/view/guide/index.vue'))
const chartsView = defineAsyncComponent(() => import('@/view/charts/index.vue'))
const notFoundView = defineAsyncComponent(() => import('@/view/notFound/index.vue'))

export const routes: RouteRecordRaw[] = [
    { path: '/:pathMatch(.*)*', name: 'NotFound', component: notFoundView },
    {
        path: '/',
        name: 'app',
        component: guideView,
    },
    {
        path: '/charts',
        name: 'charts',
        component: chartsView,
        meta: {
            descript: 'technology by web canvas.'
        }
    },
]
