<script>
</script>

<div id="frame">
	<a class="button-container home middle" href="/" draggable="false">
		<div>Home</div>
	</a>
	<a class="button-container other top right" href="/other" draggable="false">
		<div>Home</div>
	</a>
	<a class="button-container about top left" href="/about" draggable="false">
		<div>About Me</div>
	</a>
	<a class="button-container contact bot right" href="/contact" draggable="false">
		<div>Contact</div>
	</a>
	<a class="button-container projects bot left" href="/projects" draggable="false">
		<div>Projects</div>
	</a>
</div>

<style>
	#frame {
		position: fixed;
		display: grid;
		grid-template-columns: 1fr 1fr 1fr;
		grid-template-rows: 1fr 1fr 1fr;
		grid-template-areas:
			'about top-middle other'
			'middle-left home middle-right'
			'projects bot-middle contact';
		width: 100%;
		height: 100%;
		/* pointer-events: none; */
		/* background-color: blue; */
		/* opacity: 0.2; */
	}

	.button-container {
		flex: 1;
		margin: 1em;
		display: flex;
		/* flex-grow: 1; */
		padding: 1em;
		/* border: solid white 3px; */
		/* justify-content: center;
		align-items: center; */
		transition: all 0.1s linear;
		/* background-color: rgba(255,255,255,0.2); */
	}

	.button-container .active {
		flex: 4;
	}

	.button-container:hover {
		scale: 1.05;
	}

	.top {
		border-top: solid white 3px;
		align-items: start;
	}
	.bot {
		border-bottom: solid white 3px;
		align-items: end;
	}
	.left {
		border-left: solid white 3px;
		justify-content: start;
	}
	.right {
		border-right: solid white 3px;
		justify-content: end;
	}

	.middle {
		border: solid white 3px;
		justify-content: center;
		align-items: center;
	}

	.home {
		grid-area: home;
	}
	.about {
		grid-area: about;
	}
	.projects {
		grid-area: projects;
	}
	.contact {
		grid-area: contact;
	}
	.other {
		grid-area: other;
	}

	a {
		color: white;
		font-size: xx-large;
	}
</style>
