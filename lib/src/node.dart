part of orange;


class Node {
  String name;
  List<Node> children;
  List<String> childNames;
  Matrix4 matrix;
  List<Mesh> meshes;
  
  Node parent;
  Vector3 position;
  Vector3 scale;
  Quaternion rotation;
  Matrix4 matrixWorld;
  
  Node() {
    children = new List();
    matrix = new Matrix4.identity();
    matrixWorld = new Matrix4.identity();
    meshes = new List();
    position = new Vector3.zero();
    scale = new Vector3(1.0, 1.0, 1.0);
    rotation = new Quaternion.identity();
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
  
  applyMatrix(Matrix4 m) {
    position = m.getTranslation();
    scale = _getScaleFromMatrix(m);
    rotation = new Quaternion.fromRotation(m.getRotation());
  }
  
  _getScaleFromMatrix(Matrix4 m) {
    var vec = new Vector3.zero();
    var sx = vec.setValues(m[0], m[4], m[8]).length;
    var sy = vec.setValues(m[1], m[5], m[9]).length;
    var sz = vec.setValues(m[2], m[6], m[10]).length;
    return vec.setValues(sx, sy, sz);
  }
  
  updateMatrixLocal() {
    matrix.setFromTranslationRotation(position, rotation);
    if(scale.x != 1 || scale.y != 1 || scale.z != 1)
      matrix.scale(scale);
  }
  
  updateMatrixWorld() {
    updateMatrixLocal();
    if(parent != null) {
      matrixWorld = parent.matrixWorld * matrix;
    } else {
      matrixWorld = matrix.clone();
    }
    children.forEach((c) => c.updateMatrixWorld());
  }
}
