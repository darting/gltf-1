part of orange;


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
//  m3.transpose();
  
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