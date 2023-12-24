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
		Float32BufferAttribute,
		LineBasicMaterial,
		Color,
		LineSegments,
		BufferGeometry,
		DoubleSide,
		AdditiveBlending
	} from 'three';
	import { useLoader, useThrelte } from '@threlte/core';
	import { T, useFrame } from '@threlte/core';
	import { interactivity, useGltf, GLTF, useTexture } from '@threlte/extras';
	import { spring, tweened } from 'svelte/motion';

	import coneFragment from '$lib/shaders/coneFragment.glsl?raw';
	import coneVertex from '$lib/shaders/coneVertex.glsl?raw';
	import manFragment from '$lib/shaders/manFragment.glsl?raw';
	import manVertex from '$lib/shaders/manVertex.glsl?raw';
	import { writable } from 'svelte/store';
	import { cubicInOut, elasticInOut } from 'svelte/easing';

	export let navData;
	$: console.log(navData);

	const sphereGLTF = useGltf('models/Portfolio Sphere.glb');
	const coneGLTF = useGltf('models/Portfolio Cone.glb');
	const manGLTF = useGltf('models/Portfolio Man.glb');
	let manMesh;
	// $: {
	// 	if ($manGLTF)
	// 		manMesh = $manGLTF.scene.children[0].children[0].children[0].children[0].children[0].geometry;
	// }
	$: console.log(manMesh);

	interactivity();

	const minScale = 3;
	const maxScale = 4;

	const scale = spring(minScale);
	const camera = writable();

	let iTime = writable(0);

	// Frame update
	useFrame((state, delta) => {
		iTime.update((n) => n + delta);
		// console.log($camera);
		// if ($coneGLTF) console.log($coneGLTF);
		if ($coneGLTF) $coneGLTF.scene.lookAt($camera.position);
	});

	let cubeCamera;
	// $: console.log(cubeCamera);

	let renderTarget;
	// $: console.log(renderTarget);

	let rainbowShader;
	// $: console.log(rainbowShader);

	const zoomOut = 16;
	const zoomIn = 8;
	const traverseDist = 5;

	let cameraPosition = tweened({ x: 0, y: 0, z: 0 }, { duration: 500, easing: cubicInOut });
	$: {
		switch (navData.pathname) {
			case '/':
				cameraPosition.set({ x: 0, y: 0, z: zoomOut });
				break;
			case '/about':
				cameraPosition.set({ x: -traverseDist, y: traverseDist, z: zoomIn });
				break;
			case '/contact':
				cameraPosition.set({ x: traverseDist, y: -traverseDist, z: zoomIn });
				break;
			case '/projects':
				cameraPosition.set({ x: -traverseDist, y: -traverseDist, z: zoomIn });
				break;
			case '/other':
				cameraPosition.set({ x: traverseDist, y: traverseDist, z: zoomIn });
				break;
		}
	}
</script>

<!-- 
	Cameras
 -->

<T.PerspectiveCamera
	makeDefault
	position={[$cameraPosition.x, $cameraPosition.y, $cameraPosition.z]}
	on:create={({ ref }) => {
		ref.lookAt(0, 0, 0);
		$camera = ref;
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

<!-- Sphere -->

<GLTF
	bind:gltf={$sphereGLTF}
	url="models/Portfolio Sphere.glb"
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

<!-- Man -->

<GLTF
	bind:gltf={$manGLTF}
	url="models/Portfolio Man.glb"
	on:create={(ref) => {
		ref.ref.traverse((child) => {
			if (child.isMesh) {
				child.material.envMapIntensity = 0.3;
				// child.material = wireFrameMaterial;
				child.material.wireframe = true;
			}
		});
	}}
/>

<!-- Wireframe man -->
<!-- <T.LineSegments scale={10} position.y={-4} position.z={-1} rotation.x={Math.PI / 2}>
	<T.WireframeGeometry args={[manMesh]} />
	<T.ShaderMaterial
		fragmentShader={manFragment}
		vertexShader={manVertex}
		uniforms={{
			iTime: { value: 0 }
		}}
		uniforms.iTime.value={$iTime}
		transparent={true}
	/>
</T.LineSegments> -->

<!-- 
		CONE MESH
 -->

<GLTF
	bind:gltf={$coneGLTF}
	url="models/Portfolio Cone.glb"
	on:create={(ref) => {
		ref.ref.traverse((child) => {
			if (child.isMesh) {
				child.material = rainbowShader;
			}
		});
	}}
>
	<T.ShaderMaterial
		side={BackSide}
		bind:ref={rainbowShader}
		fragmentShader={coneFragment}
		vertexShader={coneVertex}
		uniforms={{
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
