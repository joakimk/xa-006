class @CloudEffect
  constructor: (@scene, @camera, @color) ->
    @previousParticleCount = 50
    @_setUpScene()

  update: (position, particleCount = @previousParticleCount) ->
    @mesh.position.x = position.x
    @mesh.position.y = position.y
    @mesh.position.z = position.z

    if particleCount != @previousParticleCount
      @_setParticleCount(@geometry, particleCount)

  render: ->
    time = performance.now() * 0.0005
    @material.uniforms.time.value = time

    r = (@color & 0xFF0000) >> 16
    g =  (@color & 0xFF00) >> 8
    b = (@color & 0xFF)
    @material.uniforms.r.value = r
    @material.uniforms.g.value = g
    @material.uniforms.b.value = b

    @mesh.rotation.x = time * 0.2
    @mesh.rotation.y = time * 0.4

  _setUpScene: ->
    @geometry = new THREE.InstancedBufferGeometry()
    @geometry.copy(new THREE.CircleBufferGeometry(1, 6))

    @_setParticleCount(@geometry, @previousParticleCount)

    @material = new THREE.RawShaderMaterial(
      uniforms:
        map:
          value: new THREE.TextureLoader().load(window.textures.xAngle or "textures/xAngle.png")
        r:
          value: 1
        g:
          value: 1
        b:
          value: 1

        time:
          value: 0.0

      vertexShader: Shaders.lab2Vert
      fragmentShader: Shaders.lab2Frag
      depthTest: true
      depthWrite: true
    )

    @mesh = new THREE.Mesh(@geometry, @material)
    @mesh.scale.set(0.5, 0.5, 0.5)
    @scene.add(@mesh)

  _setParticleCount: (geometry, particleCount) ->
    translateArray = new Float32Array(particleCount * 3)

    i = 0
    i3 = 0
    l = particleCount
    while i < l
      translateArray[i3 + 0] = Math.random() * 2 - 1
      translateArray[i3 + 1] = Math.random() * 2 - 1
      translateArray[i3 + 2] = Math.random() * 2 - 1
      i++
      i3 += 3

    geometry.addAttribute("translate", new THREE.InstancedBufferAttribute(translateArray, 3, 1))

    @previousParticleCount = particleCount
