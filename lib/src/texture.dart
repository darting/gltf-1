part of orange;


class Texture {
  Sampler sampler;
  String path;
  html.ImageElement source;
  int format;
  int internalFormat;
  int target;
  
  bool get ready => texture != null;
  
  gl.Texture texture;
  
  setup(gl.RenderingContext ctx) {
    if(source == null) {
      source = new html.ImageElement(src : path);
      source.onLoad.listen((_){
        texture = ctx.createTexture();
        ctx.bindTexture(target, texture);
//        ctx.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, 1);
        ctx.texParameteri(target, gl.TEXTURE_WRAP_S, sampler.wrapS);
        ctx.texParameteri(target, gl.TEXTURE_WRAP_T, sampler.wrapT);
        ctx.texParameteri(target, gl.TEXTURE_MIN_FILTER, sampler.minFilter);
        ctx.texParameteri(target, gl.TEXTURE_MAG_FILTER, sampler.magFilter);
        ctx.texImage2D(target, 0, internalFormat, format, gl.UNSIGNED_BYTE, source);
        ctx.bindTexture(target, null);
      });
    }
  }
}