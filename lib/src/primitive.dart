part of orange;


class Primitive {
  MeshAttribute indicesAttr;
  MeshAttribute normalAttr;
  MeshAttribute positionAttr;
  MeshAttribute texCoordAttr;
  MeshAttribute jointAttr;
  MeshAttribute weightAttr;
  Material material;
  int primitive;
  String semantics;
  
  gl.Buffer indicesBuffer;
  gl.Buffer normalBuffer;
  gl.Buffer positionBuffer;
  gl.Buffer texCoordBuffer;
  gl.Buffer jointBuffer;
  gl.Buffer weightBuffer;
  
  Shader shader;
  
  bool get ready => indicesBuffer != null && positionBuffer != null;
  
  bool _checkAttributeState(MeshAttribute attr) => attr == null || attr.bufferView.buffer.ready;
  
  setupBuffer(gl.RenderingContext ctx) {
    if(indicesBuffer == null) {
      if(indicesAttr.bufferView.buffer.ready) {
        indicesBuffer = ctx.createBuffer();
        ctx.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
        ctx.bufferDataTyped(gl.ELEMENT_ARRAY_BUFFER, indicesAttr.bufferView.createUint16List(), gl.STATIC_DRAW);
      } else {
        indicesAttr.bufferView.buffer.load();
      }
    }
    if(positionBuffer == null) {
      if(positionAttr.bufferView.buffer.ready) {
        positionBuffer = ctx.createBuffer();
        ctx.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
        ctx.bufferDataTyped(gl.ARRAY_BUFFER, positionAttr.bufferView.createFloat32List(), gl.STATIC_DRAW);
      } else {
        positionAttr.bufferView.buffer.load();
      }
    }
    if(normalAttr != null && normalBuffer == null) {
      if(normalAttr.bufferView.buffer.ready) {
        normalBuffer = ctx.createBuffer();
        ctx.bindBuffer(gl.ARRAY_BUFFER, normalBuffer);
        ctx.bufferDataTyped(gl.ARRAY_BUFFER, normalAttr.bufferView.createFloat32List(), gl.STATIC_DRAW);
      } else {
        normalAttr.bufferView.buffer.load();
      }
    }
  }
}















