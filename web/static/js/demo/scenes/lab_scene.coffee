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
    @model.rotation.z = sync.rotation.z

  render: (renderer) ->
    @index = 0
    @_renderImage(image) for image in @images
    renderer.render @scene, @camera

  _renderImage: (image) ->
    @index -= 1
    image.rotation.z = @index * (0.01 * @model.rotation.z)
    image.position.z = -@index * (0.03 * @model.rotation.z * 0.1)

  _setUpCamera: ->
    @camera = new THREE.PerspectiveCamera(90, @resolution.aspectRatio, 1, 100)
    @camera.position.z = 5

  _setUpScene: ->
    @scene = new THREE.Scene()
    @scene.add(new THREE.AmbientLight(0xAAFF55))

    @images = []
    @_addImage(i) for i in [0..10]

  _addImage: (i) ->
    textureLoader = new THREE.TextureLoader()
    texture = textureLoader.load "textures/xA.png"
    material = new THREE.MeshPhongMaterial(color: 0xffffff, map: texture, transparent: true, opacity: 1)

    geometry = new THREE.PlaneBufferGeometry(10, 10)

    mesh = new THREE.Mesh(geometry, material)
    @scene.add(mesh)
    @images.push(mesh)

