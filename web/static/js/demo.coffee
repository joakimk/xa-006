class @Demo
  constructor: ->
    @codeVersionAtLoad = window.codeVersion

    window.textures or= {}

    @_setUpModel()
    @_setUpRendering()
    @_setUpScenes()
    @_setUpMusicSync()

  start: ->
    @_animate()
    @renderer.domElement

  _setUpModel: ->
    @_setUpDefaultModel()
    @model = window.previousModelData or @defaultModel

  # On the first page load all scenes (in _setUpScenes) add initial
  # data to this model. All data for the current state of the demo
  # is stored in this model so that we can do live code updates
  # and retain the current state while doing so.
  _setUpDefaultModel: ->
    aspectRatio = 16 / 9

    # set up width and height according to aspect ratio
    width = window.innerWidth
    height = (window.innerWidth / aspectRatio)

    # scale to fit window and add some borders to make the edges more clear
    usedHeight = window.innerHeight - 50
    if usedHeight < height
      scaling = usedHeight / height
      width = width * scaling
      height = height * scaling

    @defaultModel =
      resolution:
        aspectRatio: aspectRatio
        width: width
        height: height

  _setUpScenes: ->
    @scenes = [
      new IntroScene(@model)
      new LabScene(@model)
      new BackgroundScene(@model)
    ]

  _setUpRendering: ->
    @renderer = new THREE.WebGLRenderer antialias: true
    @renderer.setSize @model.resolution.width, @model.resolution.height

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
      @_setUpScenes()
      console.log error

    window.previousModelData = @model

  _update: ->
    sync = @musicSync.update()
    @model.activeScenes = sync.activeScenes

    scene.update(sync) for scene in @scenes when @_isActive(scene)

  _render: ->
    scene.render(@renderer) for scene in @scenes when @_isActive(scene)

  _isActive: (scene) ->
    sceneNumber = @scenes.indexOf(scene) + 1
    if window.location.href.indexOf("scene") != -1
      sceneNumber == parseInt(window.location.href.split("scene=")[1])
    else
      @model.activeScenes.indexOf(sceneNumber) != -1
