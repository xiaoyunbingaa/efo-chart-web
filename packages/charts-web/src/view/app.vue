<template>
	<div class="efo-layout">
		<el-container direction="vertical">
			<EfoHeader />
			<el-container style="height: calc(100vh - 64px);">
				<el-aside width="200px">Aside</el-aside>
				<el-container>
					<el-main>
						<router-view></router-view>
					</el-main>
					<el-footer>Footer</el-footer>
				</el-container>
			</el-container>
		</el-container>
	</div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { EfoHeader } from '@/common/components'

</script>

<style scoped>
.main-view {
	min-height: 100%;
	padding: 2rem;
	box-sizing: border-box;
}
</style>
