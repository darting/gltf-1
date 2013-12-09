import 'dart:html';
import 'package:gltf/orange.dart';

void main() {
  
  var url = "http://127.0.0.1:3030/gltf/web/wine/wine.json";

  var canvas = querySelector("#container");
  var director = new Director(canvas);
  
  var loader = new Loader(url);
  loader.start().then((scene) {
    director.replace(scene);
    director.startup();
  });
}
