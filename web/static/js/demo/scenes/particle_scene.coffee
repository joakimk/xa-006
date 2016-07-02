class @ParticleScene
  constructor: (rootModel) ->
    @resolution = rootModel.resolution

    @_setUpCamera()
    @_setUpScene()

  update: (sync) ->

  render: (renderer) ->
    time = performance.now() * 0.0005
    @material.uniforms.time.value = time
    @mesh.rotation.x = time * 0.2
    @mesh.rotation.y = time * 0.4
    renderer.render @scene, @camera

  _setUpCamera: ->
    @camera = new THREE.PerspectiveCamera(50, @resolution.aspectRatio, 1, 5000)
    @camera.position.z = 1400

  _setUpScene: ->
    @scene = new THREE.Scene()

    geometry = new THREE.InstancedBufferGeometry()
    geometry.copy(new THREE.CircleBufferGeometry(1, 6))

    particleCount = 500
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

    @material = new THREE.RawShaderMaterial(
      uniforms:
        map:
          value: new THREE.TextureLoader().load(window.textures.xAngle2 or "textures/xAngle2.png")
        time:
          value: 0.0

      vertexShader: Shaders.lab2Vert
      fragmentShader: Shaders.lab2Frag
      depthTest: true
      depthWrite: true
    )

    @mesh = new THREE.Mesh(geometry, @material)
    @mesh.scale.set(500, 500, 500)
    @scene.add(@mesh)

