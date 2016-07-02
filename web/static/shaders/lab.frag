uniform float time;
varying vec2 vUv;

void main()	{
    vec2 p = -1.0 + 2.0 * vUv;
    float a = time*30.0;
    float d,e,f,g=1.0/5.0,h,i,r,q;
    e=400.0*(p.x*0.4+0.25);
    f=400.0*(p.y*0.4+0.9);
    i=200.0+sin(e*g+a/150.0)*10.0;
    d=200.0+cos(f*g/2.0)*18.0+cos(e*g)*1.0;
    r=sqrt(pow(abs(i-e),2.0)+pow(abs(d-f),2.0));
    q=f/r;
    e=(r*cos(q))-a/2.0;f=(r*sin(q))-a/1.0;
    d=sin(e*g)*176.0+sin(e*g)*164.0+r;
    h=((f+d)+a/2.0)*g;
    i=cos(h+r*p.x/0.3)*(e+e+a)+cos(q*g*6.0)*(r+h/0.1);
    h=sin(f*g)*44.0-sin(e*g)*212.0*p.x;
    h=(h+(f-e)*q+sin(r-(a+h)/7.0)*10.0+i/3.0)*g;
    i=mod(i/7.6,256.0)/64.0;
    if(i<0.0) i+=4.0;
    if(i>=2.0) i=4.0-i;
    d=r/440.0;
    d+=sin(d*d*8.0)*0.92;
    f=(sin(a*g)+3.0)/2.0;
    gl_FragColor=vec4(
        vec3(
          0,
          0,
          0
        ) *d*p.x +
        vec3(0,
          i/2.0+d/18.0,
          i) * d * (0.9-p.x),
          0.3
        );
}
