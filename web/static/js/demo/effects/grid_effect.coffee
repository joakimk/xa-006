class @GridEffect
  constructor: (@scene, lights = true) ->
    @group = new THREE.Group()
    @scene.add(@group)
    @squares = []
    (@_addSquare(x, y, 0, 1) for x in [-20..20]) for y in [-20..20]

    @light1 = new THREE.PointLight(0x00AA22, 2, 30)
    @light1.position.set(1, 1, 5)

    @light2 = new THREE.PointLight(0xFF0000, 4, 30)
    @light2.position.set(-5, 3, 5)

    if lights
      @scene.add(@light1)
      @scene.add(@light2)

  update: (sync, centerScaling = null) ->
    @light1.position.x = sync.group1Position.x
    @light1.position.y = sync.group1Position.y

    @light2.position.x = sync.position.x
    @light2.position.y = sync.position.y

    @group.rotation.x = sync.group1Rotation.x
    @group.rotation.y = sync.group1Rotation.y
    @group.rotation.z = sync.group1Rotation.z
    @distanceMultiplier = sync.group1Position.z

    if centerScaling
      square.position.z = -(centerScaling / (Math.abs(square.position.x + 0.3) + Math.abs(square.position.y + 0.3))) for square in @squares
    else
      @_updateSquare(square) for square in @squares

  light1: ->
    @light1

  light2: ->
    @light2

  render: ->

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
