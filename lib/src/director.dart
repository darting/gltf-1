part of orange;


class Director {
  html.CanvasElement _canvas;
  Renderer _renderer;
  Scene _scene;
  double _lastElapsed;
  
  Director(this._canvas) {
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






