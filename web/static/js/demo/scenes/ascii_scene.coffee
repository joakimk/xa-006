class @AsciiScene
  constructor: (rootModel) ->
    # Starting values, will be updated by "update" as the demo runs
    rootModel.asciiScene or=
      temp: 0

    @model = rootModel.asciiScene
    @resolution = rootModel.resolution

    @_setUpCamera()
    @_setUpScene()

  update: (sync) ->

  render: (renderer) ->
    renderer.render @scene, @camera

  _setUpCamera: ->
    @camera = new THREE.PerspectiveCamera(90, @resolution.aspectRatio, 1, 100)
    @camera.position.z = 5

  _setUpScene: ->
    @scene = new THREE.Scene()
    @scene.add(new THREE.AmbientLight(0xFFFFFF))
