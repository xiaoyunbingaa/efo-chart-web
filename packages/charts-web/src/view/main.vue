<template>
	<div class="common-layout">
		<el-container>
			<el-header>Header</el-header>
			<el-container>
				<el-aside width="200px">Aside</el-aside>
				<el-container>
					<el-main>Main</el-main>
					<el-footer>Footer</el-footer>
				</el-container>
			</el-container>
		</el-container>
	</div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const title = ref('Charts Web')
const description = ref('Welcome to the charts application.')
</script>

<style scoped>
.main-view {
	min-height: 100%;
	padding: 2rem;
	box-sizing: border-box;
}
</style>
