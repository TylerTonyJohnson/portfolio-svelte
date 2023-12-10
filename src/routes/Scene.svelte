<script>
	import {
		TextureLoader,
		SRGBColorSpace,
		SphereGeometry,
		BoxGeometry,
		MeshStandardMaterial,
		BackSide,
		Vector4,
		LinearMipMapLinearFilter,
		WebGLRenderTarget,
		FrontSide,
		HalfFloatType,
		CubeCamera,
		ShaderMaterial,
		PointsMaterial,
		Float32BufferAttribute
	} from 'three';
	import { useLoader, useThrelte } from '@threlte/core';
	import { T, useFrame } from '@threlte/core';
	import { interactivity, useGltf, GLTF, useTexture } from '@threlte/extras';
	import { spring, tweened } from 'svelte/motion';

	import fragmentShader from '$lib/shaders/fragment.glsl?raw';
	import vertexShader from '$lib/shaders/vertex.glsl?raw';
	import { writable } from 'svelte/store';
	import { cubicInOut, elasticInOut } from 'svelte/easing';

	export let navData;
	$: console.log(navData);

	const sphereGLTF = useGltf('models/Golden Sphere.glb');
	const coneGLTF = useGltf('models/Cone.glb');

	interactivity();

	const minScale = 3;
	const maxScale = 4;

	const scale = spring(minScale);

	let iTime = writable(0);

	// Frame update
	useFrame((state, delta) => {
		iTime.update((n) => n + delta);
		if (cubeCamera);
	});

	let cubeCamera;
	// $: console.log(cubeCamera);

	let renderTarget;
	// $: console.log(renderTarget);

	let rainbowShader;
	// $: console.log(rainbowShader);

	let cameraPosition = tweened({ x: 0, y: 0 }, { duration: 500, easing: cubicInOut });
	$: {
		switch (navData.pathname) {
			case '/':
				cameraPosition.set({ x: 0, y: 0 });
				break;
			case '/about':
				cameraPosition.set({ x: 1, y: 1 });
				break;
			case '/contact':
				cameraPosition.set({ x: -1, y: -1 });
				break;
			case '/projects':
				cameraPosition.set({ x: 1, y: -1 });
				break;
			case '/':
				cameraPosition.set({ x: 0, y: 0 });
				break;
		}
	}
</script>

<!-- 
	Cameras
 -->

<T.PerspectiveCamera
	makeDefault
	position={[$cameraPosition.x, $cameraPosition.y, 8]}
	on:create={({ ref }) => {
		ref.lookAt(0, 0, 0);
	}}
/>

<!-- <T.CubeCamera
	position={[0, 0, 0]}
	bind:ref={cubeCamera}
	{renderTarget}
	on:create={(ref) => {
		ref.ref.layers.set(2);
	}}
>
	<T.WebGLCubeRenderTarget args={[256, { type: HalfFloatType }]} bind:ref={renderTarget} />
</T.CubeCamera> -->

<!-- <T.DirectionalLight position={[20, 0, 0]} intensity={1} /> -->

<!-- <T.DirectionalLight position={[20, 0, 0]} castShadow /> -->
<!-- <T.AmbientLight color={0xd7681c} intensity={0.1} /> -->
<GLTF
	bind:gltf={$sphereGLTF}
	url="models/Golden Sphere.glb"
	scale={0.75}
	rotation.x={$iTime * 0.05}
	rotation.y={$iTime * 0.1}
	rotation.z={$iTime * 0.2}
	on:create={(ref) => {
		ref.ref.traverse((child) => {
			if (child.isMesh) {
				child.material.envMapIntensity = 0.3;
			}
		});
	}}
/>

<!-- 
		CONE MESH
 -->

<GLTF
	bind:gltf={$coneGLTF}
	url="models/Cone.glb"
	scale={1}
	on:create={(ref) => {
		ref.ref.traverse((child) => {
			if (child.isMesh) {
				console.log(child);
				child.material = rainbowShader;
			}
		});
	}}
>
	<T.ShaderMaterial
		bind:ref={rainbowShader}
		{fragmentShader}
		{vertexShader}
		uniforms={{
			color1: { value: new Vector4(1, 1, 0, 1) },
			color2: { value: new Vector4(0, 1, 1, 1) },
			iTime: { value: 0 }
		}}
		uniforms.iTime.value={$iTime}
		transparent={true}
	/>
</GLTF>

<!-- <T.Mesh
	scale={6}
	rotation.z={Math.PI / 2}
	rotation.x={Math.PI / 2}
	position.x={1}
	on:create={(ref) => {
		ref.ref.layers.enable(2);
	}}
>
	<T.ConeGeometry args={[1, 1, 128, 1]} /> -->

<!-- </T.Mesh> -->

<!-- 
	Stars
 -->

<T.Points>
	<T.BufferGeometry
		on:create={(ref) => {
			const vertices = [];
			for (let i = 0; i < 5000; i++) {
				const x = Math.random() * 100 - 50;
				const y = Math.random() * 100 - 50;
				const z = Math.random() * 50 - 50;
				vertices.push(x, y, z);
			}
			ref.ref.setAttribute('position', new Float32BufferAttribute(vertices, 3));
		}}
	/>
	<T.PointsMaterial size={1} sizeAttenuation={false} color={0x888888} />
</T.Points>
