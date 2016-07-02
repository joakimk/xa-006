class @BackgroundScene
  constructor: (rootModel) ->
    # Starting values, will be updated by "update" as the demo runs
    rootModel.backgroundScene or=
      temp: 0

    @model = rootModel.backgroundScene
    @resolution = rootModel.resolution

    @_setUpCamera()
    @_setUpScene()

  update: (sync) ->
    @cloud.update(@light1.position)

  render: (renderer) ->
    #@group.rotation.z -= -0.01
    #@light1.position.x -= 0.1
    #@light1.position.y += 0.1
    #@light2.position.x += 0.1
    #@light2.position.y -= 0.1

    @cloud.render()
    renderer.render @scene, @camera

  _setUpCamera: ->
    @camera = new THREE.PerspectiveCamera(90, @resolution.aspectRatio, 1, 100)
    @camera.position.z = 5

  _setUpScene: ->
    @scene = new THREE.Scene()
    @cloud = new CloudEffect(@scene, @camera)
    #@scene.add(new THREE.AmbientLight(0x111111))

    @light1 = new THREE.PointLight(0x0000FF, 3, 80)
    @light1.position.set(1, 1, 1)

    @light2 = new THREE.PointLight(0x00FF00, 1, 80)
    @light2.position.set(-10, 5, 5)

    @scene.add(@light1)
    @scene.add(@light2)

    @group = new THREE.Group()
    @scene.add(@group)

    @squares = []
    @group.rotation.x = -0.3
    (@_addSquare(x, y, 0, 1) for x in [-20..20]) for y in [-2..20]

  _addSquare: (x, y, z, opacity) ->
    color = Math.abs(Math.sin(y) * Math.cos(x)) + 0.2
    material = new THREE.MeshPhongMaterial(color: 0x2222ff * color, transparent: true, opacity: opacity)
    geometry = new THREE.PlaneBufferGeometry(1, 1)
    mesh = new THREE.Mesh(geometry, material)
    mesh.position.x = x * 1.1
    mesh.position.y = y * 1.1
    mesh.position.z = z

    @squares.push(mesh)
    @group.add(mesh)
