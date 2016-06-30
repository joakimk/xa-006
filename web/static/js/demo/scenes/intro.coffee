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
    @model.rotation.x = sync.rotation.x + 1.0
    @model.rotation.y = sync.rotation.y + 1.0
    #console.log(model.camera.z)

  render: (renderer) ->
    @_renderCube(cube) for cube in @cubes

    @camera.position.z = @model.camera.z
    @uniforms.time.value += 0.05

    # NOTE: this part might change when we add crossfade between scenes
    renderer.render @scene, @camera

  _renderCube: (cube) ->
    #window.cube = cube
    cube.rotation.x = @model.rotation.x
    cube.rotation.y = @model.rotation.y
    cube.position.z = (Math.cos(@model.rotation.x) + Math.sin(@model.rotation.y)) * 2

  _setUpCamera: ->
    @camera = new THREE.PerspectiveCamera(60, @resolution.aspectRatio, 0.1, 10)

  _setUpScene: ->
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

    @cubes = []
    @scene = new THREE.Scene()
    @_addCube(i, 2.0) for i in [0..43]
    @_addCube(i, 1.9) for i in [0..43]
    @_addCube(i, 1.8) for i in [0..43]

    @_addCube(i, 1.2) for i in [0..43]
    @_addCube(i, 1.1) for i in [0..43]
    @_addCube(i, 1.0) for i in [0..43]

    @_addCube(i, 0.4) for i in [0..43]
    @_addCube(i, 0.3) for i in [0..43]
    @_addCube(i, 0.2) for i in [0..43]

  _addCube: (i, offset) ->
    geometry = new THREE.CubeGeometry(0.1 * offset, 0.1 * offset, 0.1 * offset)

    material = new THREE.ShaderMaterial(
      uniforms: @uniforms
      vertexShader: Shaders.labVert
      fragmentShader: Shaders.labFrag
    )

    mesh = new THREE.Mesh(geometry, material)

    mesh.position.x = Math.cos(i) * 2 * offset
    mesh.position.y = Math.sin(i) * 2 * offset
    mesh.position.z = offset * 5
    @cubes.push(mesh)

    @scene.add mesh
