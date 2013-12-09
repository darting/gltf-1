part of orange;


class Renderer {
  html.CanvasElement _canvas;
  gl.RenderingContext ctx;
  
  Renderer(this._canvas) {
    ctx = _canvas.getContext3d(preserveDrawingBuffer: true);
    ctx.enable(gl.DEPTH_TEST);
    ctx.frontFace(gl.CCW);
    ctx.cullFace(gl.BACK);
    ctx.enable(gl.CULL_FACE);
  }
  
  prepare() {
    ctx.viewport(0, 0, _canvas.width, _canvas.height);
    ctx.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    ctx.clearColor(0.40784313725490196, 0.6431372549019608, 0.9607843137254902, 1.0);
  }
  
  render(Scene scene) {
    scene.nodes.forEach((node) => _renderNode(node));
  }
  
  _renderNode(Node node) {
    node.meshes.forEach((mesh) => _renderMesh(mesh));
  }
  
  _renderMesh(Mesh mesh) {
    mesh.primitives.forEach((primitive) => _renderPrimitive(primitive));
  }
  
  _renderPrimitive(Primitive primitive) {
    
  }
  
}