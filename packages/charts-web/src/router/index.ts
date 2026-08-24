import { createRouter, createWebHistory } from "vue-router";
import { routes } from "@/router/main.ts";
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'

// 配置：关闭右上角转圈spinner，和官网效果一致
NProgress.configure({
  showSpinner: false, // 不显示旋转图标（官网没有那个转圈）
  minimum: 0.2,       // 初始最小进度
  speed: 300
})

const router = createRouter({
  history: createWebHistory(),
  routes: [
    ...routes
  ],
})

// 路由跳转前：启动进度条
router.beforeEach((to, from) => {
  NProgress.start()
  return true;
})

// 路由跳转完成：结束进度条
router.afterEach(() => {
  NProgress.done()
})


export default router