part of orange;


Material DebugMaterial = makeDebugMaterial();

Material makeDebugMaterial() {
  var material = new Material();
  material.technique = new Technique();
  material.technique.parameters = {
                                   "modelViewMatrix": {"semantic": "MODELVIEW", "type": 35676},
                                   "projectionMatrix": {"semantic": "PROJECTION", "type": 35676},
                                   "position": {"semantic": "POSITION", "type": 35665},
                                   "normal": {"semantic": "NORMAL", "type": 35665},
                                   "normalMatrix": {"semantic": "MODELVIEWINVERSETRANSPOSE", "type": 35675},
  };
  material.technique.pass = "defaultPass";
  var pass = new Pass();
  pass.program = _makeDebugProgram();
  pass.details = {};
  pass.instanceProgram = {
                 "attributes": {
                  "a_position": "position",
                  "a_normal": "normal"
                 },
                 "program": "debugProgram",
                 "uniforms": {
                   "u_modelViewMatrix": "modelViewMatrix",
                   "u_projectionMatrix": "projectionMatrix",
                   "u_normalMatrix": "normalMatrix"
                 }
  };
  pass.states = {
                 "blendEnable": 0,
                 "cullFaceEnable": 1,
                 "depthMask": 1,
                 "depthTestEnable": 1
  };
  material.technique.passes = {
                               "defaultPass": pass
  };
  return material;
}

_makeDebugProgram() {
  var program = new Program();
  program.vertexShader = new Shader();
  program.vertexShader.source = 
"""
  precision highp float;
  attribute vec3 a_position;
  attribute vec3 a_normal;
  uniform mat4 u_modelViewMatrix;
  uniform mat4 u_projectionMatrix;
  uniform mat3 u_normalMatrix;
  
  varying highp vec3 vLighting;
  void main(void) { 
    gl_Position = u_projectionMatrix * u_modelViewMatrix * vec4(a_position,1.0); 

    highp vec3 ambientLight = vec3(0.6, 0.6, 0.6);
    highp vec3 directionalLightColor = vec3(0.5, 0.5, 0.75);
    highp vec3 directionalVector = vec3(0.85, 0.8, 0.75);
    highp vec3 transformedNormal = u_normalMatrix * a_normal;
    highp float directional = max(dot(transformedNormal, directionalVector), 0.0);
    vLighting = ambientLight + (directionalLightColor * directional);
  }
""";
  
  program.fragmentShader = new Shader();
  program.fragmentShader.source = 
"""
  precision highp float;
  varying highp vec3 vLighting;
  void main(void) {
    gl_FragColor = vec4(vec3(1.0, 0.0, 0.0) * vLighting, 1.0); 
  }
""";
  
  program.attributes = ["", "", ""];
  
  return program;
}