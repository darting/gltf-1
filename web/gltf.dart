import 'dart:html';
import 'package:gltf/orange.dart';

void main() {
  
  var url = "http://127.0.0.1:3030/gltf/web/duck/duck.json";

  var canvas = querySelector("#container");
  var director = new Director(canvas);
  var camera = new PerspectiveCamera(canvas.clientWidth / canvas.clientHeight);
  camera.position.y = 2.0;
  camera.position.z = 10.0;
  
  var loader = new Loader(url);
  loader.start().then((scene) {
    scene.camera = camera;
    director.replace(scene);
    director.startup();
  });
}
