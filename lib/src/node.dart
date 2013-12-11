part of orange;


class Node {
  String name;
  List<Node> children;
  List<String> childNames;
  Matrix4 matrix;
  List<Mesh> meshes;
  Camera camera;
  
  Vector3 position;
  Vector3 scale;
  Quaternion rotation;
  
  updateTransform() {
    matrix.setFromTranslationRotation(position, rotation);
    matrix.scale(scale);
  }
}
