<script>
	import { TextureLoader, SRGBColorSpace } from 'three';
	import { useLoader } from '@threlte/core';
	import { T, useFrame } from '@threlte/core';
	import { interactivity, useGltf, GLTF } from '@threlte/extras';
	import { spring } from 'svelte/motion';

	// import COLOR from '$lib/images/gold raw_baseColor.jpeg';
	// import ROUGHNESS from '$lib/images/gold raw_roughness.jpeg';
	// import NORMAL from '$lib/images/gold raw_normal.jpeg';
	// import DISPLACEMENT from '$lib/images/gold raw_height.jpeg';
	// import METALNESS from '$lib/images/gold raw_metallic.jpeg';
	// import AMBIENTOCCLUSION from '$lib/images/gold raw_ambientOcclusion.jpeg';
	// import GLOSSINESS from '$lib/images/gold raw_glossiness.jpeg';

	// Loading Textures
	// const textures = useLoader(TextureLoader).load({
	// 	map: COLOR,
	//     roughnessMap: ROUGHNESS,
	//     normalMap: NORMAL,
	//     displacementMap: DISPLACEMENT,
	//     metalnessMap: METALNESS,
	//     aoMap: AMBIENTOCCLUSION
	// });

	// const { load } = useLoader(TextureLoader);

	const gltf = useGltf('models/Golden Sphere.glb');

	interactivity();
	const minScale = 3;
	const maxScale = 4;

	const scale = spring(minScale);

	let rotation = 0;
	useFrame((state, delta) => {
		rotation += delta / 4;
	});
</script>

<T.PerspectiveCamera
	makeDefault
	position={[20, 0, 0]}
	on:create={({ ref }) => {
		ref.lookAt(0, 0, 0);
	}}
/>

<T.DirectionalLight position={[20, 0, 0]} intensity={100} castShadow />
<T.DirectionalLight position={[20, 0, 0]} castShadow />
<!-- <T.AmbientLight color={0xd7681c} intensity={0.1} /> -->

<!-- {#if $gltf}
	<T is={$gltf.nodes['node-name']}/>
{/if} -->

<GLTF
	bind:gltf={$gltf}
	url="models/Golden Sphere.glb"
	scale={$scale}
	on:pointerenter={() => scale.set(maxScale)}
	on:pointerleave={() => scale.set(minScale)}
	rotation.y={rotation}
	position={[0,0,0]}
	castShadow
/>

<!-- <T.Mesh
	scale={$scale}
	on:pointerenter={() => scale.set(maxScale)}
	on:pointerleave={() => scale.set(minScale)}
	rotation.y={rotation}
	position.y={1}
	castShadow
>
	<T.SphereGeometry />
	{#if $textures}
		<T.MeshStandardMaterial {...$textures} displacementBias=0 displacementScale=0 />
	{/if}
</T.Mesh> -->

<!-- <T.Mesh rotation.x={-Math.PI / 2} receiveShadow>
	<T.CircleGeometry args={[4, 40]} />
	<T.MeshStandardMaterial color="white" />
</T.Mesh> -->
