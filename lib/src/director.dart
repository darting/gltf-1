part of orange;


class Director {
  
  static Director _shared;
  
  html.CanvasElement _canvas;
  Renderer _renderer;
  Scene _scene;
  double _lastElapsed;
  
  factory Director(html.CanvasElement canvas) {
    if(_shared == null){
      _shared = new Director._internal(canvas);
    }
    return _shared;
  }
  
  Director._internal(this._canvas) {
    _renderer = new Renderer(_canvas);
    _lastElapsed = 0.0;
  }
  
  replace(Scene scene) {
    _scene = scene;
  }
  
  startup() {
    html.window.requestAnimationFrame(_animate);
  }
  
  _animate(num elapsed) {
    html.window.requestAnimationFrame(_animate);
    var interval = elapsed - _lastElapsed;
    _renderer.prepare();
    _renderer.render(_scene);
    _lastElapsed = elapsed;
  }
  
  double get elapsed => _lastElapsed;
  Renderer get renderer => _renderer;
  Scene get scene => _scene;
  html.CanvasElement get canvas => _canvas;
}






