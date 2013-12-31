part of orange;


class Node {
  String name;
  List<Node> children;
  List<String> childNames;
  Matrix4 matrix;
  List<Mesh> meshes;
  
  Node parent;
  Matrix4 matrixWorld;
  
  Node() {
    children = new List();
    matrix = new Matrix4.identity();
    matrixWorld = new Matrix4.identity();
    meshes = new List();
  }
  
  add(Node child) {
    child.removeFromParent();
    child.parent = this;
    children.add(child);
  }
  
  removeFromParent() {
    if(parent != null) {
      parent.children.remove(this);
      parent = null;
    }
  }
  
  translate(Vector3 translation) {
    matrix.translate(translation);
  }
  
  scale(dynamic x, [double y = null, double z = null]) {
    matrix.scale(x, y, z);
  }
  
  rotate(double angle, Vector3 axis) {
    matrix.rotate(angle, axis);
  }
  
  applyMatrix(Matrix4 m) {
    matrix.multiply(m);
  }
  
  updateMatrixWorld() {
    if(parent != null) {
      matrixWorld = parent.matrixWorld * matrix;
    } else {
      matrixWorld = matrix.clone();
    }
    children.forEach((c) => c.updateMatrixWorld());
  }
  
  Vector3 get position => matrix.getTranslation();
}
