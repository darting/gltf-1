part of orange;


class Node {
  String name;
  List<Node> children;
  List<String> childNames;
  Matrix4 matrix;
  List<Mesh> meshes;
  
  Node parent;
  Vector3 position;
  Vector3 _scale;
  Quaternion rotation;
  Matrix4 matrixWorld;
  
  Node() {
    children = new List();
    matrix = new Matrix4.identity();
    matrixWorld = new Matrix4.identity();
    meshes = new List();
    position = new Vector3.zero();
    _scale = new Vector3(1.0, 1.0, 1.0);
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
  
  translate(Vector3 translation) {
    matrix.transform3(translation);
  }
  
  scale(dynamic x, [double y = null, double z = null]) {
    matrix.scale(x, y, z);
  }
  
  rotate(Vector3 axis, double angle) {
    matrix.rotate(axis, angle);
  }
  
  applyMatrix(Matrix4 m) {
    matrix.multiply(m);
    decomposeMatrix(m, _scale, rotation, position);
//    position = matrix.getTranslation();
//    scale = _getScaleFromMatrix(matrix);
//    
//    var v1 = new Vector3.zero();
//    var scaleX = 1.0 / v1.setValues(matrix[0], matrix[1], matrix[2]).length;
//    var scaleY = 1.0 / v1.setValues(matrix[4], matrix[5], matrix[6]).length;
//    var scaleZ = 1.0 / v1.setValues(matrix[8], matrix[9], matrix[10]).length;
//    
//    Matrix3 r = new Matrix3.zero();
//    r.storage[0] = matrix[0] * scaleX;
//    r.storage[1] = matrix[1] * scaleX;
//    r.storage[2] = matrix[2] * scaleX;
//    
//    r.storage[3] = matrix[4] * scaleY;
//    r.storage[4] = matrix[5] * scaleY;
//    r.storage[5] = matrix[6] * scaleY;
//    
//    r.storage[6] = matrix[8] * scaleZ;
//    r.storage[7] = matrix[9] * scaleZ;
//    r.storage[8] = matrix[10] * scaleZ;
//    
//    rotation = new Quaternion.fromRotation(r);
  }
  
  updateMatrixLocal() {
    matrix.setFromTranslationRotation(position, rotation);
    if(_scale.x != 1 || _scale.y != 1 || _scale.z != 1) {
      matrix.scale(_scale);
    }
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
