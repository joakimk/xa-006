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
    @group.rotation.x = sync.group1Rotation.x;
    @group.rotation.y = sync.group1Rotation.y;
    @group.rotation.z = sync.group1Rotation.z;

    @light1.position.x = sync.group1Position.x;
    @light1.position.y = sync.group1Position.y;

    @light2.position.x = sync.position.x
    @light2.position.y = sync.position.y

    @distanceMultiplier = sync.group1Position.z
    @camera.position.z = sync.position.z

    @blueCloud.update(@light1.position)
    @greenCloud.update(@light2.position)

    @_updateSquare(square) for square in @squares

  render: (renderer) ->
    # quickfix, end the demo
    if window.audio.volume == 0
      @camera.position.z = -1000000

    @blueCloud.render()
    @greenCloud.render()
    renderer.render @scene, @camera

  _updateSquare: (square) ->
    distanceToLight1 = @_distance(square, @light1)
    distanceToLight2 = @_distance(square, @light2)

    # This was closest, but furthest looks much better
    # and causes a nice flickering effect.
    furthestDistance =
      if distanceToLight1 > distanceToLight2
        distanceToLight1
      else
        distanceToLight2

    square.position.z = furthestDistance * @distanceMultiplier
    #console.log(closestDistance)

  _distance: (a, b) ->
    xd = Math.abs(a.position.x - b.position.x)
    yd = Math.abs(a.position.y - b.position.y)
    zd = Math.abs(a.position.z - b.position.z)
    Math.sqrt(xd * yd * zd)

  _setUpCamera: ->
    @camera = new THREE.PerspectiveCamera(90, @resolution.aspectRatio, 1, 100)
    @camera.position.z = 10

  _setUpScene: ->
    @scene = new THREE.Scene()
    @blueCloud = new CloudEffect(@scene, @camera, 0x0000FF)
    @greenCloud = new CloudEffect(@scene, @camera, 0x00FF00)
    #@scene.add(new THREE.AmbientLight(0x111111))

    @light1 = new THREE.PointLight(0x0000FF, 5, 30)
    @light1.position.set(1, 1, 2)

    @light2 = new THREE.PointLight(0x00FF00, 5, 30)
    @light2.position.set(-5, 3, 2)

    @scene.add(@light1)
    @scene.add(@light2)

    @group = new THREE.Group()
    @scene.add(@group)

    @squares = []
    @group.rotation.x = -0.3
    (@_addSquare(x, y, 0, 1) for x in [-20..20]) for y in [-20..20]

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
