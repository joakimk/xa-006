# This class talks to "GNU rocket", both getting the latest values
# and updating the tracker based on the current position in the music.
class @DemoSyncTracker
  constructor: ->
    @bpm = 170
    @rows_per_beat = 8
    @row_rate = (@bpm / 60) * @rows_per_beat

    @audio = new Audio()

    @syncDevice = new JSRocket.SyncDevice()

    @demoMode = (window.location.href.indexOf("tracker") == -1)

    if @demoMode
      @syncDevice.setConfig rocketXML: "demo/demo.rocket"
    else
      @syncDevice.setConfig socketURL: "ws://#{window.location.hostname}:1339"

    @row = "not yet set"
    @tracks = {}

  start: ->
    device = @syncDevice

    if @demoMode
      device.init("demo")
    else
      device.init()

    device.on "ready", =>
      @_setUpTracks()

      @audio.src = "/music/alpha_c_-_euh.ogg"
      @audio.load()
      @audio.preload = true

      if @demoMode
        @audio.addEventListener "canplay", =>
          @audio.play()
      else
        @audio.addEventListener "ended", =>
          @audio.currentTime = 0
          @audio.play()

    device.on "update", (row) =>
      @row = row
      @audio.currentTime = @row / @row_rate
      @data = @_getDataForCurrentRow()

    device.on "play",  => @audio.play()
    device.on "pause", => @audio.pause()

  update: ->
    @data = @_getDataForCurrentRow()

    unless @audio.paused
      @row = @audio.currentTime * @row_rate
      @syncDevice.update(@row)

    @data

  _setUpTracks: ->
    @tracks.rotationX = @syncDevice.getTrack("rotation.x")
    @tracks.rotationY = @syncDevice.getTrack("rotation.y")

  _getDataForCurrentRow: ->
    rotation:
      x: @tracks.rotationX?.getValue(@row) or 0
      y: @tracks.rotationY?.getValue(@row) or 0
