<script>
	import Header from './Header.svelte';
	import Counter from './Counter.svelte';
	import Menu from './Menu.svelte';
	import './styles.css';

	import { fly } from 'svelte/transition';
	import { cubicIn, cubicOut } from 'svelte/easing';

	import { Canvas } from '@threlte/core';
	import Scene from './Scene.svelte';
	import { Environment } from '@threlte/extras';

	export let data;
	$: console.log(data);
</script>

<!-- {#key data.pathname} -->
<div class="app">
	<!-- <Header /> -->
	<!-- <Counter /> -->

	<Canvas>
		<Environment
			path="images/"
			files="Indoor Environment.hdr"
			isBackground={false}
		/>
		<!-- <Environment path="images/" files="Bright Sky.hdr" isBackground={false} /> -->
		<Scene navData={data} />
	</Canvas>

	<main>
		<slot />
	</main>

	<Menu />

	<!-- <footer>
			<p>visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to learn SvelteKit</p>
		</footer> -->
</div>

<!-- {/key} -->

<style>
	.app {
		display: flex;
		flex-direction: column;
		width: 100vw;
		height: 100vh;
		/* background-color: red; */
	}

	main {
		position: absolute;
		flex: 1;
		display: flex;
		flex-direction: column;
		width: 100%;
		/* max-width: 64rem; */
		margin: 0 auto;
		box-sizing: border-box;
		padding: 20%;
		/* background-color: green; */
	}
</style>
