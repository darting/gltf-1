part of orange;



class Matrix3 {
  final Float32List storage = new Float32List(9);
  
  Matrix3 transpose() {
    var a01 = storage[1], a02 = storage[2], a12 = storage[5];
    storage[1] = storage[3];
    storage[2] = storage[6];
    storage[3] = a01;
    storage[5] = storage[7];
    storage[6] = a02;
    storage[7] = a12;
    return this;
  }
  
  double operator[](int i) => storage[i];
}