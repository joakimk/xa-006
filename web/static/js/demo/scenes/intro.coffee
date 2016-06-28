class @IntroScene

  constructor: (rootModel) ->
    @fragmentShaderSript =
    """
    uniform vec2 resolution;
    uniform float time;
    void main()	{
    	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    	float a = time*40.0;
    	float d,e,f,g=1.0/40.0,h,i,r,q;
    	e=400.0*(p.x*0.5+0.5);
    	f=400.0*(p.y*0.5+0.5);
    	i=200.0+sin(e*g+a/150.0)*20.0;
    	d=200.0+cos(f*g/2.0)*18.0+cos(e*g)*7.0;
    	r=sqrt(pow(abs(i-e),2.0)+pow(abs(d-f),2.0));
    	q=f/r;
    	e=(r*cos(q))-a/2.0;f=(r*sin(q))-a/2.0;
    	d=sin(e*g)*176.0+sin(e*g)*164.0+r;
    	h=((f+d)+a/2.0)*g;
    	i=cos(h+r*p.x/1.3)*(e+e+a)+cos(q*g*6.0)*(r+h/3.0);
    	h=sin(f*g)*144.0-sin(e*g)*212.0*p.x;
    	h=(h+(f-e)*q+sin(r-(a+h)/7.0)*10.0+i/4.0)*g;
    	i+=cos(h*2.3*sin(a/350.0-q))*184.0*sin(q-(r*4.3+a/12.0)*g)+tan(r*g+h)*184.0*cos(r*g+h);
    	i=mod(i/5.6,256.0)/64.0;
    	if(i<0.0) i+=4.0;
    	if(i>=2.0) i=4.0-i;
    	d=r/350.0;
    	d+=sin(d*d*8.0)*0.52;
    	f=(sin(a*g)+1.0)/2.0;
    	gl_FragColor=vec4(vec3(f*i/1.6,i/2.0+d/13.0,i)*d*p.x+vec3(i/1.3+d/8.0,i/2.0+d/18.0,i)*d*(1.0-p.x),1.0);
    }
    """
    @vertexShaderSript =
    """
    void main()	{
    	gl_Position = vec4( position, 1.0 );
    }
    """
    # Starting values, will be updated by "update" as the demo runs
    rootModel.introScene or=
      camera:
        z: 2.5

      rotation:
        x: 0
        y: 0

    @model = rootModel.introScene
    @resolution = rootModel.resolution

    @_setUpCamera()
    @_setUpScene()

  update: (sync) ->
    @model.rotation.x = sync.rotation.x
    @model.rotation.y = sync.rotation.y
    #console.log(model.camera.z)

  render: (renderer) ->
    @mesh.rotation.x = @model.rotation.x
    @mesh.rotation.y = @model.rotation.y
    @camera.position.z = @model.camera.z

    @uniforms.time.value += 0.05;

    # NOTE: this part might change when we add crossfade between scenes
    renderer.render @scene, @camera

  _setUpCamera: ->
    @camera = new THREE.PerspectiveCamera(75, @resolution.aspectRatio, 0.1, 10)

  _setUpScene: ->
    # geometry = new THREE.CubeGeometry(2.5, 2.5, 2.5)
    geometry = new THREE.PlaneBufferGeometry(2, 2)
    # material = new THREE.MeshBasicMaterial(
    #   color: 0x224444
    #   wireframe: false
    #   wireframeLinewidth: 20
    # )

    @uniforms =
      time:
        value: 1.0
      resolution:
        value: new THREE.Vector2(@resolution.width, @resolution.height)

    material = new THREE.ShaderMaterial(
	    uniforms: @uniforms
	    vertexShader: @vertexShaderSript
	    fragmentShader: @fragmentShaderSript
    )
    @mesh = new THREE.Mesh(geometry, material)

    @scene = new THREE.Scene()
    @scene.add @mesh
