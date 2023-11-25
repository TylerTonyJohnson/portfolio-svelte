<script>
	import Header from './Header.svelte';
	import './styles.css';

	import { fly } from 'svelte/transition';
	import { cubicIn, cubicOut } from 'svelte/easing';

	import { Canvas } from '@threlte/core';
	import Scene from './Scene.svelte';
	import { Environment } from '@threlte/extras';

	export let data;
</script>

{#key data.pathname}
	<div class="app">
		<!-- <Header /> -->

		<main
			in:fly={{ easing: cubicOut, y: 10, duration: 300, delay: 400 }}
			out:fly={{ easing: cubicIn, y: -10, duration: 300 }}
		>
			<Canvas>
				<Environment path="images/" files="Space 4k.png" isBackground={true} />
				<Scene />
			</Canvas>
			<slot />
		</main>

		<footer>
			<p>visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to learn SvelteKit</p>
		</footer>
	</div>
{/key}

<style>
	.app {
		display: flex;
		flex-direction: column;
		min-height: 100vh;
		/* background-color: red; */
	}

	main {
		flex: 1;
		display: flex;
		flex-direction: column;
		padding: 1rem;
		width: 100%;
		max-width: 64rem;
		margin: 0 auto;
		box-sizing: border-box;
	}

	footer {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		padding: 12px;
	}

	footer a {
		font-weight: bold;
	}

	@media (min-width: 480px) {
		footer {
			padding: 12px 0;
		}
	}
</style>
