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

<svelte:head>
	<title>Dare</title>
	<meta name="About" content="About me" />
</svelte:head>

<!-- {#key data.pathname} -->
<div class="app">
	<!-- <img src='/images/space-background.jpg' /> -->
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
		/* background-image: '/images/space-background.jpg'; */
	}

	img {
		position: absolute;
		width: 100%;
		/* height: 100%; */
		/* z-index: -1; */
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
