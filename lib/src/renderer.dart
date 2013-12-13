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
          var material = primitive.material;
          var technique = material.technique;
          var pass = technique.passes[material.technique.pass];
          var program = pass.program;
          program.setup(ctx);
          
          if(program.ready) {
            // bind uniforms
            program.uniformSymbols.forEach((symbol) {
              var value;
              var parameter = pass.instanceProgram["uniforms"][symbol];
              parameter = technique.parameters[parameter];
              if(parameter != null) {
                var semantic = parameter["semantic"];
                if(semantic != null) {
                  if(semantic == "PROJECTION") {
                    value = camera.projectionMatrix;
                  } else if (semantic == "MODELVIEW") {
                    value = node.matrixWorld;
                  } else if (semantic == "MODELVIEWINVERSETRANSPOSE") {
                    value = new Matrix4.zero();
                    value.copyInverse(node.matrixWorld);
                    value.transpose();
                    
                  }
                }
              }
              if(value == null && parameter != null) {
                // find the node be named {source}
                if(parameter["source"] != null) {
                  
                } else {
                  value = parameter["value"];
                }
              }
              
              var texture;
              if(value != null) {
                var type = program.getTypeForSymbol(symbol);
                if(type == gl.SAMPLER_CUBE) {
                  
                } else if(type == gl.SAMPLER_2D) {
                  
                } else {
                  program.setValueForSymbol(ctx, symbol, value);
                }
              }
            });     
            
            // bind attributes
            var attributes = pass.instanceProgram["attributes"];
            program.attributeSymbols.forEach((symbol) {
              var parameter = attributes[symbol];
              parameter = technique.parameters[parameter];
              var semantic = parameter["semantic"];
              
              var accessor = primitive.semantics[semantic];
              
              ctx.bindBuffer(accessor.bufferView.target, accessor.buffer);
              var location = program.symbolToLocation[symbol];
              if(location != null) {
                ctx.enableVertexAttribArray(location);
                ctx.vertexAttribPointer(location, 3, gl.FLOAT, false, 0, 0);
              }
            });
            
            ctx.bindBuffer(primitive.indices.bufferView.target, primitive.indices.buffer);
            ctx.drawElements(primitive.primitive, primitive.indices.count, primitive.indices.type, 0);
            
          }
          
//          primitive.shader.bind(this, camera, primitive, node.matrixWorld);
//          ctx.bindBuffer(primitive.indices.bufferView.target, primitive.indices.buffer);
//          ctx.drawElements(primitive.primitive, primitive.indices.count, primitive.indices.type, 0);
          
        } else {
          primitive.setupBuffer(ctx);
          if(primitive.ready) {
//            var shader = new ProgramShader();
//            shader.init(ctx);
//            primitive.shader = shader;
          }
        }
      });
    });
    node.children.forEach((n) => _renderNode(camera, n));
  }
}












