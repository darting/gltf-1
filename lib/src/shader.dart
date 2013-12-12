part of orange;



final String _shader_normal_vertex_source = 
"""
precision mediump float;

attribute vec3 aVertexPosition;
attribute highp vec3 aVertexNormal;

uniform mat4 uProjectionMatrix;
uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uNormalMatrix;

varying vec3 vPosition;
//varying vec3 vNormal;
varying highp vec3 vLighting;

void main(void) {
  vec4 pos = uModelMatrix * vec4(aVertexPosition, 1.0);
  gl_Position = uProjectionMatrix * uViewMatrix * pos;
  vPosition = pos.xyz;
  //vNormal = normalize((uNormalMatrix * vec4(aVertexNormal, 0.0)).xyz);
  highp vec3 ambientLight = vec3(0.6, 0.6, 0.6);
  highp vec3 directionalLightColor = vec3(0.5, 0.5, 0.75);
  highp vec3 directionalVector = vec3(0.85, 0.8, 0.75);
  highp vec4 transformedNormal = uNormalMatrix * vec4(aVertexNormal, 1.0);
  highp float directional = max(dot(transformedNormal.xyz, directionalVector), 0.0);
  vLighting = ambientLight + (directionalLightColor * directional);
}
""";

final String _shader_normal_fragment_source = 
"""
precision mediump float;

uniform vec3 uColor;

varying vec3 vPosition;
//varying vec3 vNormal;
varying highp vec3 vLighting;

void main(void) {
  //float lambert = max(dot(vNormal,vec3(0.,0.,1.)), 0.);
  //gl_FragColor = vec4(lambert * uColor, 1.0);
  gl_FragColor = vec4(uColor * vLighting, 1.0);
}
""";



class Shader {
  final int MAX_LIGHTS = 4;
  
  String vertexSource;
  String fragmentSource;
  gl.Program program;
  
  int vertexPositionAttribute;
  int vertexNormalAttribute;
  gl.UniformLocation projectionMatrixUniform;
  gl.UniformLocation modelMatrixUniform;
  gl.UniformLocation viewMatrixUniform;
  gl.UniformLocation normalMatrixUniform;
  gl.UniformLocation cameraPositionUniform;
  gl.UniformLocation colorUniform;
  gl.UniformLocation shininessUniform;
  List<Map<String, gl.UniformLocation>> lightsUniform;
  
  Shader() {
    vertexSource = _shader_normal_vertex_source;
    fragmentSource = _shader_normal_fragment_source;
  }
  
  init(gl.RenderingContext ctx) {
    gl.Shader vertexShader = ctx.createShader(gl.VERTEX_SHADER);
    ctx.shaderSource(vertexShader, vertexSource);
    ctx.compileShader(vertexShader);

    gl.Shader fragmentShader = ctx.createShader(gl.FRAGMENT_SHADER);
    ctx.shaderSource(fragmentShader, fragmentSource);
    ctx.compileShader(fragmentShader);
    
    program = ctx.createProgram();
    ctx.attachShader(program, vertexShader);
    ctx.attachShader(program, fragmentShader);
    ctx.linkProgram(program);
    
    var linkedStatus = ctx.getProgramParameter(program, gl.LINK_STATUS);
    if(!linkedStatus) {
      print(ctx.getShaderInfoLog(vertexShader));
      print(ctx.getShaderInfoLog(fragmentShader));
      print(ctx.getProgramInfoLog(program));
    }
    
    vertexPositionAttribute = ctx.getAttribLocation(program, "aVertexPosition");
    ctx.enableVertexAttribArray(vertexPositionAttribute);
    
    vertexNormalAttribute = ctx.getAttribLocation(program, "aVertexNormal");
    ctx.enableVertexAttribArray(vertexNormalAttribute);

    projectionMatrixUniform = ctx.getUniformLocation(program, "uProjectionMatrix");
    modelMatrixUniform = ctx.getUniformLocation(program, "uModelMatrix");
    viewMatrixUniform = ctx.getUniformLocation(program, "uViewMatrix");
    normalMatrixUniform = ctx.getUniformLocation(program, "uNormalMatrix");
    colorUniform = ctx.getUniformLocation(program, "uColor");
  }
  
  bind(Renderer renderer, Camera camera, Primitive primitive, Matrix4 transform) {
    var ctx = renderer.ctx;
    
    ctx.useProgram(program);
    
    ctx.bindBuffer(primitive.positions.bufferView.target, primitive.positions.buffer);
    ctx.vertexAttribPointer(vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);
    
    ctx.bindBuffer(primitive.positions.bufferView.target, primitive.normals.buffer);
    ctx.vertexAttribPointer(vertexNormalAttribute, 3, gl.FLOAT, false, 0, 0);
    
    var tmp = new Float32List.fromList(new List.filled(16, 0.0));
    
    camera.projectionMatrix.copyIntoArray(tmp);
    ctx.uniformMatrix4fv(projectionMatrixUniform, false, tmp);
    
    camera.matrix.copyIntoArray(tmp);
    ctx.uniformMatrix4fv(viewMatrixUniform, false, tmp);
    
    var cp = camera.matrix * camera.position;
    cp = camera.position;
    ctx.uniform3fv(cameraPositionUniform, vector3ToFloat32List(cp));
    
    transform.copyIntoArray(tmp);
    ctx.uniformMatrix4fv(modelMatrixUniform, false, tmp);
    
    ctx.uniform3fv(colorUniform, new Float32List.fromList([1.0, 0.0, 0.0]));
    
    var normalMatrix = new Matrix4.zero();
    normalMatrix.copyInverse(transform);
    normalMatrix.transpose();
    normalMatrix.copyIntoArray(tmp);
    ctx.uniformMatrix4fv(normalMatrixUniform, false, tmp);
  }
  
  vector3ToFloat32List(Vector3 vec) {
    return new Float32List.fromList([vec.x, vec.y, vec.z]);
  }
}