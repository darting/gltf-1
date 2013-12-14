part of orange;


class Primitive {
  MeshAttribute indices;
  Map<String, MeshAttribute> semantics;
  Material material;
  int primitive;
  
  bool get ready => indices.buffer != null && semantics.keys.every((k) => semantics[k].buffer != null);
  
  setupBuffer(gl.RenderingContext ctx) {
    indices.setupBuffer(ctx);
    semantics.forEach((k, v){
      v.setupBuffer(ctx);
    });
  }
}















