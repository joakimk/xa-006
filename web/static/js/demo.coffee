class @Demo
  constructor: ->
    @codeVersionAtLoad = window.codeVersion

    @_setUpModel()
    @_setUpScenes()
    @_setUpRendering()
    @_setUpMusicSync()

  start: ->
    @_animate()
    @renderer.domElement

  _setUpModel: ->
    # On the first page load all scenes (in _setUpScenes) add initial
    # data to this model. All data for the current state of the demo
    # is stored in this model so that we can do live code updates
    # and retain the current state while doing so.
    @defaultModel = {}

    @model = window.previousModelData or @defaultModel

  _setUpScenes: ->
    @scenes = [
      new IntroScene(@model)
    ]

  _setUpRendering: ->
    @renderer = new THREE.WebGLRenderer()
    @renderer.setSize window.innerWidth, window.innerHeight

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

    # TODO: only update or render scehens the sync says should be visible
    scene.update(sync) for scene in @scenes

  _render: ->
    scene.render(@renderer) for scene in @scenes

    @renderer.domElement
