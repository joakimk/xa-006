class @IntroScene
  constructor: (rootModel) ->
    # Starting values, will be updated by "update" as the demo runs
    rootModel.introScene or=
      camera:
        z: 2.5

      rotation:
        x: 0
        y: 0

    @model = rootModel.introScene
    @resolution = rootModel.resolution

    @_setUpCamera()
    @_setUpScene()

  update: (sync) ->
    @model.rotation.x = sync.rotation.x
    @model.rotation.y = sync.rotation.y
    #console.log(model.camera.z)

  render: (renderer) ->
    @mesh.rotation.x = @model.rotation.x
    @mesh.rotation.y = @model.rotation.y
    @camera.position.z = @model.camera.z

    @uniforms.time.value += 0.05

    # NOTE: this part might change when we add crossfade between scenes
    renderer.render @scene, @camera

  _setUpCamera: ->
    @camera = new THREE.PerspectiveCamera(75, @resolution.aspectRatio, 0.1, 10)

  _setUpScene: ->
    geometry = new THREE.CubeGeometry(2.5, 2.5, 2.5)
    # geometry = new THREE.PlaneBufferGeometry(2, 2)
    # material = new THREE.MeshBasicMaterial(
    #   color: 0x224444
    #   wireframe: false
    #   wireframeLinewidth: 20
    # )

    @uniforms =
      time:
        value: 1.0
      resolution:
        value: new THREE.Vector2(@resolution.width, @resolution.height)

    material = new THREE.ShaderMaterial(
	    uniforms: @uniforms
	    vertexShader: Shaders.labVert
	    fragmentShader: Shaders.labFrag
    )
    @mesh = new THREE.Mesh(geometry, material)

    @scene = new THREE.Scene()
    @scene.add @mesh
