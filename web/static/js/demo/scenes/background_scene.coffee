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
    @camera.position.z = sync.position.z

    @grid.update(sync)

    @blueCloud.update(@grid.light1.position)
    @greenCloud.update(@grid.light2.position)

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
    @blueCloud = new CloudEffect(@scene, @camera, 0x0000FF)
    @greenCloud = new CloudEffect(@scene, @camera, 0x00FF00)
    #@scene.add(new THREE.AmbientLight(0x111111))

    @grid = new GridEffect(@scene)
