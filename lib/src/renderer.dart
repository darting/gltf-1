part of orange;


class Renderer {
  html.CanvasElement _canvas;
  gl.RenderingContext ctx;
  int _lastMaxEnabledArray = -1;
  
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
      _renderNode(scene, node);
    });
  }
  
  _renderNode(Scene scene, Node node) {
    var camera = scene.camera;
    node.meshes.forEach((mesh) {
      mesh.primitives.forEach((primitive) {
        if(primitive.ready) {
          var material = primitive.material;
          var technique = material.technique;
          var pass = technique.passes[material.technique.pass];
          var program = pass.program;
          program.setup(ctx);
          
          if(program.ready) {
            var currentTexture = 0;
            var newMaxEnabledArray = -1;
            // bind uniforms
            program.uniformSymbols.forEach((symbol) {
              var value;
              var parameterName = pass.instanceProgram["uniforms"][symbol];
              var parameter = technique.parameters[parameterName];
              if(parameter != null) {
                var semantic = parameter["semantic"];
                if(semantic != null) {
                  if(semantic == "PROJECTION") {
                    value = camera.projectionMatrix;
                  } else if (semantic == "MODELVIEW") {
                    value = node.matrixWorld;
                  } else if (semantic == "MODELVIEWINVERSETRANSPOSE") {
                    value = mat4ToInverseMat3(camera.matrixWorld * node.matrixWorld);
                    value.transpose();
                  }
                }
              }
              if(value == null && parameter != null) {
                // find the node be named {source}
                if(parameter["source"] != null) {
                  var node = scene.resources[parameter["source"]];
                  value = node.matrixWorld;
                } else if(parameter["value"] != null) {
                  value = parameter["value"];
                } else {
                  value = material.instanceTechnique["values"][parameterName];
                }
              }
              
              if(value != null) {
                var type = program.getTypeForSymbol(symbol);
                if(type == gl.SAMPLER_CUBE || type == gl.SAMPLER_2D) {
                  Texture texture = scene.resources[value];
                  if(texture.ready) {
                    ctx.activeTexture(gl.TEXTURE0 + currentTexture);
                    ctx.bindTexture(texture.target, texture.texture);
                    var location = program.symbolToLocation[symbol];
                    if(location != null) {
                      program.setValueForSymbol(ctx, symbol, currentTexture);
                      currentTexture++;
                    }
                  } else {
                    texture.setup(ctx);
                  }
                } else {
                  program.setValueForSymbol(ctx, symbol, value);
                }
              }
            });     
            
            // bind attributes
            var attributes = pass.instanceProgram["attributes"];
            program.attributeSymbols.forEach((symbol) {
              var parameter = technique.parameters[attributes[symbol]];
              var semantic = parameter["semantic"];
              
              var accessor = primitive.semantics[semantic];
              
              ctx.bindBuffer(accessor.bufferView.target, accessor.buffer);
              var location = program.symbolToLocation[symbol];
              if(location != null) {
                if(location > newMaxEnabledArray) {
                  newMaxEnabledArray = location;
                }
                ctx.enableVertexAttribArray(location);
                ctx.vertexAttribPointer(location, accessor.byteStride ~/ 4, gl.FLOAT, false, 0, 0);
              }
            });
            
            for(var i = (newMaxEnabledArray + 1); i < _lastMaxEnabledArray; i++) {
              ctx.disableVertexAttribArray(i);              
            }
            _lastMaxEnabledArray = newMaxEnabledArray;
            
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
    node.children.forEach((n) => _renderNode(scene, n));
  }
}

Matrix3 mat4ToInverseMat3(Matrix4 mat) {
  var a00 = mat[0], a01 = mat[1], a02 = mat[2],
      a10 = mat[4], a11 = mat[5], a12 = mat[6],
      a20 = mat[8], a21 = mat[9], a22 = mat[10],
      b01 = a22 * a11 - a12 * a21,
      b11 = -a22 * a10 + a12 * a20,
      b21 = a21 * a10 - a11 * a20,
      d = a00 * b01 + a01 * b11 + a02 * b21,
      id;
  if (d == 0.0) { return null; }
  id = 1 / d;
  var dest = new Matrix3.zero();
  dest[0] = b01 * id;
  dest[1] = (-a22 * a01 + a02 * a21) * id;
  dest[2] = (a12 * a01 - a02 * a11) * id;
  dest[3] = b11 * id;
  dest[4] = (a22 * a00 - a02 * a20) * id;
  dest[5] = (-a12 * a00 + a02 * a10) * id;
  dest[6] = b21 * id;
  dest[7] = (-a21 * a00 + a01 * a20) * id;
  dest[8] = (a11 * a00 - a01 * a10) * id;
  return dest;
}












