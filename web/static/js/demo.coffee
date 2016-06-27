class @Demo
  constructor: ->
    @codeVersionAtLoad = window.codeVersion

    @_setUpModel()
    @_setUpRendering()
    @_setUpScene()
    @_setUpMusicSync()

  start: ->
    @_animate()
    @renderer.domElement

  _setUpModel: ->
    # This model is only used on first page load, after that you will
    # retain the data from previous versions of the code.
    @defaultModel =
      camera:
        z: 2.5

      rotation:
        x: 0
        y: 0

    @model = window.previousModelData or @defaultModel

  _setUpRendering: ->
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 10)
    @renderer = new THREE.CanvasRenderer()
    @renderer.setSize window.innerWidth, window.innerHeight

  _setUpScene: ->
    geometry = new THREE.CubeGeometry(1, 1, 1)
    material = new THREE.MeshBasicMaterial(
      color: 0x224444
      wireframe: true
      wireframeLinewidth: 20
    )
    @mesh = new THREE.Mesh(geometry, material)

    @scene = new THREE.Scene()
    @scene.add @mesh

  _setUpMusicSync: ->
    # Set up music sync on first load so it does not break on code updates
    unless window.musicSync
      window.musicSync = new MusicSync()
      window.musicSync.start()
    @musicSync = window.musicSync

  _animate: ->
    # Stop animating if a new live updated code version has arrived
    return if @codeVersionAtLoad != window.codeVersion
    requestAnimationFrame => @_animate()

    try
      @_update()
      @_render()
    catch error
      window.previousModelData = @defaultModel
      console.log error
      #window.location.reload()

    window.previousModelData = @model

  _update: ->
    data = @musicSync.update()

    @model.rotation.x = data.rotation.x
    @model.rotation.y = data.rotation.y
    #model.camera.z = 2.5
    #model.camera.z += 1 * delta
    #console.log(model.camera.z)

  _render: ->
    @mesh.rotation.x = @model.rotation.x
    @mesh.rotation.y = @model.rotation.y
    @camera.position.z = @model.camera.z

    @renderer.render @scene, @camera
