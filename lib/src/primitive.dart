part of orange;


class Primitive {
  MeshAttribute indices;
  MeshAttribute normals;
  MeshAttribute positions;
  MeshAttribute texCoord;
  MeshAttribute joints;
  MeshAttribute weights;
  Material material;
  int primitive;
  String semantics;
  
  Shader shader;
  
  bool get ready => indices.buffer != null && positions.buffer != null && normals.buffer != null;
  
  setupBuffer(gl.RenderingContext ctx) {
    indices.setupBuffer(ctx);
    normals.setupBuffer(ctx);
    positions.setupBuffer(ctx);
    
    if(ready) {
      var a = 1;
      var b = 2;
    }
  }
}















