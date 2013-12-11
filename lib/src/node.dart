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
  
  Node() {
    children = new List();
    matrix = new Matrix4.identity();
    meshes = new List();
    position = new Vector3.zero();
    scale = new Vector3(1.0, 1.0, 1.0);
    rotation = new Quaternion.identity();
  }
  
  updateTransform() {
    matrix.setFromTranslationRotation(position, rotation);
    matrix.scale(scale);
  }
}
