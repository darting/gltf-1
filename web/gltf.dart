import 'dart:html' as html;
import 'package:gltf/orange.dart';
import 'dart:typed_data';
import 'dart:web_gl' as gl;

void main() {
  
  var url = "http://127.0.0.1:3030/gltf/web/SuperMurdoch/SuperMurdoch.json";
  url = "http://127.0.0.1:3030/gltf/web/wine/wine.json";
//  url = "http://127.0.0.1:3030/gltf/web/duck/duck.json";

  var canvas = html.querySelector("#container");
  var director = new Director(canvas);
  var camera = new PerspectiveCamera(canvas.width / canvas.height);
  camera.position.x = 10.0;
  camera.position.y = 700.0;
  camera.position.z = 1500.0;
//  camera.updateMatrixWorld();
//  camera.lookAt(new Vector3.zero());
  
  var loader = new Loader(url);
  loader.start().then((scene) {
    var s = new TestScene();
    s.resources = scene.resources;
    s.camera = scene.camera;
    s.nodes = scene.nodes;
    if(s.camera == null) 
      s.camera = camera;
    else {
      s.camera.aspect = canvas.width / canvas.height;
      s.camera.updateProjection();
    }
    
    director.replace(s);
    director.startup();
  });
  
//  html.document.onMouseMove.listen((html.MouseEvent e) {
//    Node node = director.scene.nodes.first;
//    var movement = e.movement;
//    var xa = node.rotation.radians + movement.x / 100.0;
//    node.rotation.setAxisAngle(WORLD_UP, xa);
//    node.rotation.setAxisAngle(WORLD_LEFT, node.rotation.radians + movement.y / 100.0);
//  });
  
  
//  var scene = new Scene();
//  scene.nodes = new List();
//  scene.camera = camera;
//  
//  var node = new Node();
//  node.meshes = new List();
//  scene.nodes.add(node);
//  
//  var mesh = new Mesh();
//  mesh.primitives = new List();
//  mesh.primitives.add(mock(director.renderer.ctx));
//  node.meshes.add(mesh);
//  
//  director.replace(scene);
//  director.startup();
  
}



class TestScene extends Scene {
  
  enter() {
    
  }
  
  update(num interval) {
    nodes.forEach((e) {
//      e.rotation.setAxisAngle(WORLD_UP, -Director.shared.elapsed * PI / 5000);
    });
  }
  
}




















mock(gl.RenderingContext ctx) {
  var positionBuffer = ctx.createBuffer();
  ctx.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
  var vertices = new Float32List.fromList([
                                       // Front face
                                       -1.0, -1.0,  1.0,
                                       1.0, -1.0,  1.0,
                                       1.0,  1.0,  1.0,
                                       -1.0,  1.0,  1.0,
                                       
                                       // Back face
                                       -1.0, -1.0, -1.0,
                                       -1.0,  1.0, -1.0,
                                       1.0,  1.0, -1.0,
                                       1.0, -1.0, -1.0,
                                       
                                       // Top face
                                       -1.0,  1.0, -1.0,
                                       -1.0,  1.0,  1.0,
                                       1.0,  1.0,  1.0,
                                       1.0,  1.0, -1.0,
                                       
                                       // Bottom face
                                       -1.0, -1.0, -1.0,
                                       1.0, -1.0, -1.0,
                                       1.0, -1.0,  1.0,
                                       -1.0, -1.0,  1.0,
                                       
                                       // Right face
                                       1.0, -1.0, -1.0,
                                       1.0,  1.0, -1.0,
                                       1.0,  1.0,  1.0,
                                       1.0, -1.0,  1.0,
                                       
                                       // Left face
                                       -1.0, -1.0, -1.0,
                                       -1.0, -1.0,  1.0,
                                       -1.0,  1.0,  1.0,
                                       -1.0,  1.0, -1.0
                                       ]);
  ctx.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);
  
  
  var indicesBuffer = ctx.createBuffer();
  ctx.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
  var cubeVertexIndices = [
                           0, 1, 2,      0, 2, 3,    // Front face
                           4, 5, 6,      4, 6, 7,    // Back face
                           8, 9, 10,     8, 10, 11,  // Top face
                           12, 13, 14,   12, 14, 15, // Bottom face
                           16, 17, 18,   16, 18, 19, // Right face
                           20, 21, 22,   20, 22, 23  // Left face
                           ];
  ctx.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(cubeVertexIndices), gl.STATIC_DRAW);
  
  var vertexNormals = [
                       // Front
                       0.0,  0.0,  1.0,
                       0.0,  0.0,  1.0,
                       0.0,  0.0,  1.0,
                       0.0,  0.0,  1.0,
                       
                       // Back
                       0.0,  0.0, -1.0,
                       0.0,  0.0, -1.0,
                       0.0,  0.0, -1.0,
                       0.0,  0.0, -1.0,
                       
                       // Top
                       0.0,  1.0,  0.0,
                       0.0,  1.0,  0.0,
                       0.0,  1.0,  0.0,
                       0.0,  1.0,  0.0,
                       
                       // Bottom
                       0.0, -1.0,  0.0,
                       0.0, -1.0,  0.0,
                       0.0, -1.0,  0.0,
                       0.0, -1.0,  0.0,
                       
                       // Right
                       1.0,  0.0,  0.0,
                       1.0,  0.0,  0.0,
                       1.0,  0.0,  0.0,
                       1.0,  0.0,  0.0,
                       
                       // Left
                       -1.0,  0.0,  0.0,
                       -1.0,  0.0,  0.0,
                       -1.0,  0.0,  0.0,
                       -1.0,  0.0,  0.0
                       ];
  var normalBuffer = ctx.createBuffer();
  ctx.bindBuffer(gl.ARRAY_BUFFER, normalBuffer);
  ctx.bufferData(gl.ARRAY_BUFFER, new Float32List.fromList(vertexNormals), gl.STATIC_DRAW);
  
  var primitive = new Primitive();
  primitive.primitive = gl.TRIANGLES;
  primitive.indices = new MeshAttribute();
  primitive.indices.count = 36;
  primitive.indices.byteOffset = 0;
  primitive.indices.buffer = indicesBuffer;
  primitive.positions = new MeshAttribute();
  primitive.positions.count = 24;
  primitive.positions.byteOffset = 0;
  primitive.positions.buffer = positionBuffer;
  primitive.normals = new MeshAttribute();
  primitive.normals.buffer = normalBuffer;
  primitive.shader = new ProgramShader();
  primitive.shader.init(ctx);
  return primitive;
}
















