library orange;

// Make it robust
// 1) detecting WebGL support in the browser
// 2) detecting a lost context


import 'dart:html' as html;
import 'dart:convert' show JSON;
import 'dart:web_gl' as gl;
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'dart:mirrors';
import 'dart:async';


part 'src/node.dart';
part 'src/camera.dart';
part 'src/mesh.dart';
part 'src/primitive.dart';
part 'src/buffer_refs.dart';
part 'src/buffer_view.dart';
part 'src/indices.dart';
part 'src/material.dart';
part 'src/mesh_attribute.dart';
part 'src/loader.dart';
part 'src/string_helper.dart';
part 'src/image.dart';
part 'src/scene.dart';
part 'src/renderer.dart';
part 'src/director.dart';
part 'src/technique.dart';
part 'src/program.dart';
part 'src/pass.dart';
part 'src/sampler.dart';
part 'src/texture.dart';
part 'src/shader.dart';
part 'src/only_once.dart';
part 'src/resources.dart';
part 'src/light.dart';
part 'src/trackball_controls.dart';
part 'src/debug.dart';
part 'src/color.dart';

part 'src/event/eventdispatcher.dart';
part 'src/event/events.dart';
part 'src/event/eventsubscription.dart';


final Vector3 WORLD_UP = new Vector3(0.0, 1.0, 0.0);
final Vector3 WORLD_LEFT = new Vector3(-1.0, 0.0, 0.0);
final Vector3 WORLD_RIGHT = new Vector3(1.0, 0.0, 0.0);
final Vector3 WORLD_DOWN = new Vector3(0.0, -1.0, 0.0);

final Vector3 UNIT_X = new Vector3(1.0, 0.0, 0.0);
final Vector3 UNIT_Y = new Vector3(0.0, 1.0, 0.0);
final Vector3 UNIT_Z = new Vector3(0.0, 0.0, 1.0);



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



_newMatrix4FromArray(List arr) {
  return new Matrix4(
      arr[0].toDouble(), arr[1].toDouble(), arr[2].toDouble(), arr[3].toDouble(),
      arr[4].toDouble(), arr[5].toDouble(), arr[6].toDouble(), arr[7].toDouble(),
      arr[8].toDouble(), arr[9].toDouble(), arr[10].toDouble(), arr[11].toDouble(),
      arr[12].toDouble(), arr[13].toDouble(), arr[14].toDouble(), arr[15].toDouble());
}




