import type { App, Component } from 'vue'
import EfoHeader from '@/common/components/EfoHeader.vue'

export { EfoHeader }

const components: Record<string, Component> = {
    EfoHeader,
}

export default {
    install(app: App) {
        Object.entries(components).forEach(([name, component]) => {
            app.component(name, component)
        })
    },
}