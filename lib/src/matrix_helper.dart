part of orange;




Matrix4 _newMatrix4FromArray(List arr) {
  return new Matrix4(
      arr[0].toDouble(), arr[1].toDouble(), arr[2].toDouble(), arr[3].toDouble(),
      arr[4].toDouble(), arr[5].toDouble(), arr[6].toDouble(), arr[7].toDouble(),
      arr[8].toDouble(), arr[9].toDouble(), arr[10].toDouble(), arr[11].toDouble(),
      arr[12].toDouble(), arr[13].toDouble(), arr[14].toDouble(), arr[15].toDouble());
}

decomposeMatrix(Matrix4 matrix, Vector3 scale, Quaternion rotation, Vector3 position) {
  var x = new Vector3.zero();
  var y = new Vector3.zero();
  var z = new Vector3.zero();
  var m3 = new Matrix3.zero();
  
  x.setValues(matrix[0], matrix[1], matrix[2]);
  y.setValues(matrix[4], matrix[5], matrix[6]);
  z.setValues(matrix[8], matrix[9], matrix[10]);
  
  scale.x = x.length;
  scale.y = y.length;
  scale.z = z.length;
  
  position.setValues(matrix[12], matrix[13], matrix[14]);
  
  m3 = matrix.getRotation();
  m3.transpose();
  
  m3[0] /= scale.x;
  m3[1] /= scale.x;
  m3[2] /= scale.x;
  
  m3[3] /= scale.y;
  m3[4] /= scale.y;
  m3[5] /= scale.y;
  
  m3[6] /= scale.z;
  m3[7] /= scale.z;
  m3[8] /= scale.z;
  
  rotation = new Quaternion.fromRotation(m3);
  rotation.normalize();
}


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

Vector3 _getScaleFromMatrix(Matrix4 m) {
  var vec = new Vector3.zero();
  var sx = vec.setValues(m[0], m[1], m[2]).length;
  var sy = vec.setValues(m[4], m[5], m[6]).length;
  var sz = vec.setValues(m[8], m[9], m[10]).length;
  return vec.setValues(sx, sy, sz);
}