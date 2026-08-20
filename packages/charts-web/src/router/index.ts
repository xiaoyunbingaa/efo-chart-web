import { createRouter, createWebHistory } from "vue-router";
import { routes } from "@/router/main.ts";

const router = createRouter({
  history: createWebHistory(),
  routes: [
    ...routes
  ],
})

export default router