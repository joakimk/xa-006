# This class talks to "GNU rocket", both getting the latest values
# and updating the tracker based on the current position in the music.
class @MusicSync
  constructor: ->
    @bpm = 140
    @rows_per_beat = 8
    @row_rate = (@bpm / 60) * @rows_per_beat

    @audio = new Audio()

    @syncDevice = new JSRocket.SyncDevice()

    @demoMode = (window.location.href.indexOf("tracker") == -1)

    if @demoMode
      @syncDevice.setConfig rocketXML: window.rocketXML or "sync.rocket"
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

      @audio.src = window.musicData or "/music.ogg"
      @audio.load()
      @audio.preload = true
      window.audio = @audio

      if @demoMode
        @audio.addEventListener "canplay", =>
          @audio.play()
      else
        @audio.addEventListener "ended", =>
          @audio.currentTime = 0
          @audio.play()

    device.on "update", (row) =>
      @row = row

      newTime = @row / @row_rate
      oldTime = @audio.currentTime
      @audio.currentTime = newTime
      console.log(newTime: newTime, oldTime: oldTime, audio: audio)
      @data = @_getDataForCurrentRow()

    device.on "play",  =>
      console.log("play")
      @audio.play()
    device.on "pause", =>
      console.log("pause")
      @audio.pause()

  update: ->
    @data = @_getDataForCurrentRow()

    unless @audio.paused
      @row = @audio.currentTime * @row_rate

      if @audio.currentTime > 15 and window.location.href.indexOf("reset_music") != -1
        console.log "This is as far as we've gotten, resetting music to the start"
        @audio.currentTime = 0

      @syncDevice.update(@row)

    @data

  _setUpTracks: ->
    @tracks.rotationX = @syncDevice.getTrack("rotation.x")
    @tracks.rotationY = @syncDevice.getTrack("rotation.y")
    @tracks.rotationZ = @syncDevice.getTrack("rotation.z")

    @tracks.positionX = @syncDevice.getTrack("position.x")
    @tracks.positionY = @syncDevice.getTrack("position.y")
    @tracks.positionZ = @syncDevice.getTrack("position.z")

    @tracks.group1RotationX = @syncDevice.getTrack("grp1.rotation.x")
    @tracks.group1RotationY = @syncDevice.getTrack("grp1.rotation.y")
    @tracks.group1RotationZ = @syncDevice.getTrack("grp1.rotation.z")

    @tracks.group1PositionX = @syncDevice.getTrack("grp1.position.x")
    @tracks.group1PositionY = @syncDevice.getTrack("grp1.position.y")
    @tracks.group1PositionZ = @syncDevice.getTrack("grp1.position.z")

    @tracks.activeSceneA = @syncDevice.getTrack("activeSceneA")
    @tracks.activeSceneB = @syncDevice.getTrack("activeSceneB")

  _getDataForCurrentRow: ->
    rotation:
      x: @tracks.rotationX?.getValue(@row) or 0
      y: @tracks.rotationY?.getValue(@row) or 0
      z: @tracks.rotationZ?.getValue(@row) or 0
    position:
      x: @tracks.positionX?.getValue(@row) or 0
      y: @tracks.positionY?.getValue(@row) or 0
      z: @tracks.positionZ?.getValue(@row) or 0
    group1Rotation:
      x: @tracks.group1RotationX?.getValue(@row) or 0
      y: @tracks.group1RotationY?.getValue(@row) or 0
      z: @tracks.group1RotationZ?.getValue(@row) or 0
    group1Position:
      x: @tracks.group1PositionX?.getValue(@row) or 0
      y: @tracks.group1PositionY?.getValue(@row) or 0
      z: @tracks.group1PositionZ?.getValue(@row) or 0

    activeScenes: [
      @tracks.activeSceneA?.getValue(@row) or 0
      @tracks.activeSceneB?.getValue(@row) or 0
    ]
