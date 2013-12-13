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
    ctx.viewport(0, 0, _canvas.width, _canvas.height);
    ctx.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    scene.nodes.forEach((node) {
      node.updateMatrixWorld();
      _renderNode(scene.camera, node);
    });
  }
  
  _renderNode(Camera camera, Node node) {
    node.meshes.forEach((mesh) {
      mesh.primitives.forEach((primitive) {
        if(primitive.ready) {
          primitive.shader.bind(this, camera, primitive, node.matrixWorld);
          ctx.bindBuffer(primitive.indices.bufferView.target, primitive.indices.buffer);
          ctx.drawElements(primitive.primitive, primitive.indices.count, primitive.indices.type, 0);
        } else {
          primitive.setupBuffer(ctx);
          if(primitive.ready) {
            var shader = new Shader();
            shader.init(ctx);
            primitive.shader = shader;
          }
        }
      });
    });
    node.children.forEach((n) => _renderNode(camera, n));
  }
}












