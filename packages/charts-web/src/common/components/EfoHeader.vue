<template>
	<div class="efo-header">
		<el-header>
			<slot name="left"></slot>
			<slot name="default"></slot>
			<slot name="right"></slot>
		</el-header>
	</div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const title = ref('Charts Web')
const description = ref('Welcome to the charts application.')
</script>

<style scoped>
.efo-header {
	padding: 12px 24px;
	box-sizing: border-box;
}
</style>
