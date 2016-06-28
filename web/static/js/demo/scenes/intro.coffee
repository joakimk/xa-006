class @IntroScene
  constructor: (rootModel) ->
    # Starting values, will be updated by "_update" as the demo runs
    rootModel.introScene or=
      camera:
        z: 2.5

      rotation:
        x: 0
        y: 0

    @model = rootModel.introScene

    @_setUpCamera(rootModel.resolution)
    @_setUpScene()

  _setUpCamera: (resolution) ->
    @camera = new THREE.PerspectiveCamera(75, resolution.aspectRatio, 0.1, 10)

  _setUpScene: ->
    geometry = new THREE.CubeGeometry(2.5, 2.5, 2.5)
    material = new THREE.MeshBasicMaterial(
      color: 0x224444
      wireframe: true
      wireframeLinewidth: 1
    )
    @mesh = new THREE.Mesh(geometry, material)

    @scene = new THREE.Scene()
    @scene.add @mesh

  update: (sync) ->
    @model.rotation.x = sync.rotation.x
    @model.rotation.y = sync.rotation.y
    #console.log(model.camera.z)

  render: (renderer) ->
    @mesh.rotation.x = @model.rotation.x
    @mesh.rotation.y = @model.rotation.y
    @camera.position.z = @model.camera.z

    # NOTE: this part might change when we add crossfade between scenes
    renderer.render @scene, @camera
