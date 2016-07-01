class @LabScene
  constructor: (rootModel) ->
    # Starting values, will be updated by "update" as the demo runs
    rootModel.labScene or=
      rotation:
        z: 0

    @model = rootModel.labScene
    @resolution = rootModel.resolution

    @_setUpCamera()
    @_setUpScene()

  update: (sync) ->
    @model.rotation.z -= 0.01

  render: (renderer) ->
    @mesh.rotation.z = @model.rotation.z
    renderer.render @scene, @camera

  _setUpCamera: ->
    @camera = new THREE.PerspectiveCamera(90, @resolution.aspectRatio, 1, 100)
    @camera.position.z = 10

  _setUpScene: ->
    @scene = new THREE.Scene()
    @scene.add(new THREE.AmbientLight(0xAAFF55))

    textureLoader = new THREE.TextureLoader()
    texture = textureLoader.load "textures/xA.png"
    material = new THREE.MeshPhongMaterial(color: 0xffffff, map: texture)

    geometry = new THREE.PlaneBufferGeometry(10, 10)

    @mesh = new THREE.Mesh(geometry, material)

    @scene.add(@mesh)

