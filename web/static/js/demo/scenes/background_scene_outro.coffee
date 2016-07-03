class @BackgroundSceneOutro
  constructor: (rootModel) ->
    # Starting values, will be updated by "update" as the demo runs
    rootModel.backgroundScene or=
      temp: 0

    @model = rootModel.backgroundScene
    @resolution = rootModel.resolution

    @_setUpCamera()
    @_setUpScene()

  update: (sync) ->
    @camera.position.z = sync.position.z

    @grid.update(sync)

    @blueCloud.update(@grid.light1.position)
    @greenCloud.update(@grid.light2.position)

    @authors.position.x = sync.rotation.x
    @authors.position.y = sync.rotation.y
    @authors.position.z = sync.rotation.z

  render: (renderer) ->


    # quickfix, end the demo
    if window.audio.volume == 0
      @camera.position.z = -1000000

    @blueCloud.render()
    @greenCloud.render()
    @grid.render()
    renderer.render @scene, @camera

  _setUpCamera: ->
    @camera = new THREE.PerspectiveCamera(90, @resolution.aspectRatio, 1, 100)
    @camera.position.z = 10

  _setUpScene: ->
    @scene = new THREE.Scene()
    @blueCloud = new CloudEffect(@scene, @camera, 0x00FF00)
    @greenCloud = new CloudEffect(@scene, @camera, 0xFF0000)
    @scene.add(new THREE.AmbientLight(0x888833))

    @grid = new GridEffect(@scene)

    @authors = new THREE.Group()

    @animationGroup = {}
    @scene.add(@authors)

    group = new THREE.Group()
    group.position.x = -4.5
    group.position.y = 2
    @authors.add(group)
    identifier = window.textures.code or "textures/code.png"
    @images = []
    @_addImage(i, identifier, group, 1, .5) for i in [0..10]
    @animationGroup.code = @images

    group = new THREE.Group()
    group.position.x = -3.7
    group.position.y = 2
    @authors.add(group)
    identifier = window.textures.and or "textures/and.png"
    @images = []
    @_addImage(i, identifier, group, .5, .5) for i in [0..10]
    @animationGroup.and1 = @images

    group = new THREE.Group()
    group.position.x = -2.3
    group.position.y = 2
    @authors.add(group)
    identifier = window.textures.graphics or "textures/graphics.png"
    @images = []
    @_addImage(i, identifier, group, 2, .5) for i in [0..10]
    @animationGroup.graphics = @images

    group = new THREE.Group()
    group.position.x = -3.8
    group.position.y = 1.4
    @authors.add(group)
    identifier = window.textures.trejs or "textures/trejs.png"
    @images = []
    @_addImage(i, identifier, group, 1, .4) for i in [0..10]
    @animationGroup.trejs = @images

    group = new THREE.Group()
    group.position.x = -3
    group.position.y = 1.4
    @authors.add(group)
    identifier = window.textures.and or "textures/and.png"
    @images = []
    @_addImage(i, identifier, group, .4, .4) for i in [0..10]
    @animationGroup.and2 = @images

    group = new THREE.Group()
    group.position.x = -2.0
    group.position.y = 1.4
    @authors.add(group)
    identifier = window.textures.danter or "textures/danter.png"
    @images = []
    @_addImage(i, identifier, group, 1.2, .4) for i in [0..10]
    @animationGroup.danter = @images

    group = new THREE.Group()
    group.position.x = -4.3
    group.position.y = 0
    @authors.add(group)
    identifier = window.textures.music or "textures/music.png"
    @images = []
    @_addImage(i, identifier, group, 1.3, .5) for i in [0..10]
    @animationGroup.music = @images

    group = new THREE.Group()
    group.position.x = -3.8
    group.position.y = -.5
    @authors.add(group)
    identifier = window.textures.yirsi or "textures/yirsi.png"
    @images = []
    @_addImage(i, identifier, group, 1, .4) for i in [0..10]
    @animationGroup.yirsi = @images

    group = new THREE.Group()
    group.position.x = -3
    group.position.y = -.5
    @authors.add(group)
    identifier = window.textures.at or "textures/at.png"
    @images = []
    @_addImage(i, identifier, group, .5, .5) for i in [0..10]
    @animationGroup.at = @images

    group = new THREE.Group()
    group.position.x = -1.8
    group.position.y = -.5
    @authors.add(group)
    identifier = window.textures.soundcloud or "textures/soundcloud.png"
    @images = []
    @_addImage(i, identifier, group, 1.8, .4) for i in [0..10]
    @animationGroup.soundcloud = @images

  _buildMesh: (texture, width = 10, height = 10) ->
    textureLoader = new THREE.TextureLoader()
    texture = textureLoader.load texture
    material = new THREE.MeshPhongMaterial(color: 0xffffff, map: texture, transparent: true, opacity: 1)
    geometry = new THREE.PlaneBufferGeometry(width, height)
    mesh = new THREE.Mesh(geometry, material)

  _addImage: (i, identifier, group, width, height) ->
    mesh = @_buildMesh(identifier, width, height)
    group.add(mesh)
    @images.push(mesh)
