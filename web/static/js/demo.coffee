# This is intended to be a example of demo using GNU rocket (https://github.com/kusma/rocket)
# to drive the visuals to be in sync with the music.

Demo =
  init: ->
    camera = null
    scene = null
    renderer = null
    geometry = null
    material = null
    mesh = null
    clock = null
    syncTracker = null

    # This model is only used on first page load, after that you will
    # retain the data from previous versions of the code.
    defaultModel =
      camera:
        z: 2.5

      rotation:
        x: 0
        y: 0

    model = window.previousModelData or defaultModel
    currentCodeVersion = window.liveCodeVersion

    start = ->
      clock = new THREE.Clock()
      renderer = new THREE.CanvasRenderer()
      renderer.setSize window.innerWidth, window.innerHeight

      camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 10)

      geometry = new THREE.CubeGeometry(1, 1, 1)
      material = new THREE.MeshBasicMaterial(
        color: 0x224444
        wireframe: true
        wireframeLinewidth: 20
      )

      mesh = new THREE.Mesh(geometry, material)

      scene = new THREE.Scene()
      scene.add mesh

      # Set up syncTracker on first load so it does not break on code updates
      unless window.syncTracker
        syncTracker = new DemoSyncTracker()
        syncTracker.start()
        window.syncTracker = syncTracker
      syncTracker = window.syncTracker

      animate()
      renderer.domElement

    animate = ->
      # Stop animating if a new live updated code version has arrived
      return if currentCodeVersion != window.liveCodeVersion
      requestAnimationFrame animate

      try
        update()
        render()
      catch error
        window.previousModelData = defaultModel
        console.log error
        window.location.reload()

      window.previousModelData = model

    update = ->
      data = syncTracker.update()

      #delta = clock.getDelta()
      model.rotation.x = data.rotation.x
      model.rotation.y = data.rotation.y
      #model.camera.z = 2.5
      #model.camera.z += 1 * delta
      #console.log(model.camera.z)

    render = ->
      mesh.rotation.x = model.rotation.x
      mesh.rotation.y = model.rotation.y
      camera.position.z = model.camera.z

      renderer.render scene, camera

    start()

window.Demo = Demo
