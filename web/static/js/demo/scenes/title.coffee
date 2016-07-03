class @TitleScene
  constructor: (rootModel) ->
    # Starting values, will be updated by "update" as the demo runs
    rootModel.labScene or=
      rotation:
        x: 0
        y: 0
        z: 0
      position:
        x: 0
        y: 0
        z: 0

    quickFix = =>
      window.enableTitleScene = true

    setTimeout quickFix, 3000

    @model = rootModel.labScene
    @resolution = rootModel.resolution

    @_setUpCamera()
    @_setUpScene()

  update: (sync) ->
    @grid.update(sync, sync.rotation.z)

    @model.rotation.z = sync.rotation.z

    @group2.rotation.x = sync.rotation.x
    @group2.rotation.y = sync.rotation.y
    @group2.position.x = sync.position.x
    @group2.position.y = sync.position.y
    @group2.position.z = sync.position.z

    @group1.rotation.x = sync.group1Rotation.x
    @group1.rotation.y = sync.group1Rotation.y
    @group1.rotation.z = sync.group1Rotation.z
    @group1.position.x = sync.group1Position.x
    @group1.position.y = sync.group1Position.y
    @group1.position.z = sync.group1Position.z

    # @light1.position.x = sync.group1Position.x + 3
    # @light1.position.y = sync.group1Position.y + -3
    # @light2.position.x = sync.group1Position.x + -3
    # @light2.position.y = sync.group1Position.y + 3
    # console.log(lightX: @light2.position.x, lightY: @light2.position.y, lightZ: @light2.position.z)
    # console.log(grpX: @group1.position.x, grpY: @group1.position.y, grpZ: @group1.position.z)

  render: (renderer) ->
    return unless window.enableTitleScene

    @grid.render()
    @_renderImageGroup(group) for k, group of @animationGroup
    renderer.render @scene, @camera

  _renderImageGroup: (imageGroup) ->
    @index = 0
    @_renderImage(image) for image in imageGroup

  _renderImage: (image) ->
    @index -= 1
    image.rotation.x = @model.rotation.x
    image.rotation.y = @model.rotation.y
    image.rotation.z = @index * (Math.cos(@model.rotation.z) * 0.01)
    image.position.z = -@index * (0.03 * @model.rotation.z * 0.1)
    image.position.x = @model.position.x
    image.position.y = @model.position.y
    image.scale.set(1 + -(@index * 0.03) * @model.rotation.z * 0.5, 1 + -(@index * 0.03) * @model.rotation.z * 2.3, 1)

  _setUpCamera: ->
    @camera = new THREE.PerspectiveCamera(90, @resolution.aspectRatio, 1, 100)
    @camera.position.z = 10
    # @camera.position.x = 80

  _setUpScene: ->
    @scene = new THREE.Scene()

    @light1 = new THREE.PointLight(0x00AA22, 2, 30)
    @light1.position.set(6, -3, 5)

    @light2 = new THREE.PointLight(0xFF0000, 2, 30)
    @light2.position.set(-6, 3, 5)

    @grid = new GridEffect(@scene, false)

    @scene.add(@light1)
    @scene.add(@light2)
    # @scene.add(new THREE.AmbientLight(0x44FF22))

    @group1 = new THREE.Group()
    @group2 = new THREE.Group()
    # @group2.position.x = 120
    # @group2.position.y = -10
    @animationGroup = {}
    @scene.add(@group1)
    @scene.add(@group2)

    group = new THREE.Group()
    @group1.add(group)
    identifier = window.textures.xAngle or "textures/xAngle.png"
    @images = []
    @_addImage(i, identifier, group) for i in [0..10]
    @animationGroup.xAngle = @images

    group = new THREE.Group()
    group.position.x = 80
    group.position.y = 5
    @group1.add(group)
    identifier = window.textures.proudly or "textures/proudly.png"
    @images = []
    @_addImage(i, identifier, group) for i in [0..10]
    @animationGroup.proudly = @images

    group = new THREE.Group()
    group.position.x = 160
    @group1.add(group)
    identifier = window.textures.title or "textures/title.png"
    @images = []
    @_addImage(i, identifier, group, 10, 5) for i in [0..10]
    @animationGroup.title = @images

    group = new THREE.Group()
    @group2.add(group)
    identifier = window.textures.presents or "textures/presents.png"
    @images = []
    @_addImage(i, identifier, group) for i in [0..10]
    @animationGroup.presents = @images

    group = new THREE.Group()
    group.position.x = 80
    @group2.add(group)
    identifier = window.textures.twoDays or "textures/twoDays.png"
    @images = []
    @_addImage(i, identifier, group, 10, 5) for i in [0..10]
    @animationGroup.twoDays = @images

    group = new THREE.Group()
    group.position.x = 160
    @group2.add(group)
    identifier = window.textures.edison2014logo or "textures/edison2014logo.png"
    @images = []
    @_addImage(i, identifier, group) for i in [0..10]
    @animationGroup.edison = @images

    group = new THREE.Group()
    group.position.x = 150
    @group2.add(group)
    identifier = window.textures.at or "textures/at.png"
    @images = []
    @_addImage(i, identifier, group) for i in [0..10]
    @animationGroup.at = @images

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
