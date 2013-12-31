part of orange;


class Quaternion {
  final Float32List storage = new Float32List(4);
  
  Quaternion(double x, double y, double z, double w) {
    storage[0] = x;
    storage[1] = y;
    storage[2] = z;
    storage[3] = w;
  }
  
  Quaternion.identity() {
    storage[3] = 1.0;
  }
  
  Quaternion.fromRotation(Matrix3 m) {
    // Algorithm in Ken Shoemake's article in 1987 SIGGRAPH course notes
    // article "Quaternion Calculus and Fast Animation".
    var fTrace = m[0] + m[4] + m[8];
    var fRoot;

    if ( fTrace > 0.0 ) {
        // |w| > 1/2, may as well choose w > 1/2
        fRoot = math.sqrt(fTrace + 1.0);  // 2w
        storage[3] = 0.5 * fRoot;
        fRoot = 0.5/fRoot;  // 1/(4w)
        storage[0] = (m[7]-m[5])*fRoot;
        storage[1] = (m[2]-m[6])*fRoot;
        storage[2] = (m[3]-m[1])*fRoot;
    } else {
        // |w| <= 1/2
        var i = 0;
        if ( m[4] > m[0] )
          i = 1;
        if ( m[8] > m[i*3+i] )
          i = 2;
        var j = (i+1)%3;
        var k = (i+2)%3;

        fRoot = math.sqrt(m[i*3+i]-m[j*3+j]-m[k*3+k] + 1.0);
        storage[i] = 0.5 * fRoot;
        fRoot = 0.5 / fRoot;
        storage[3] = (m[k*3+j] - m[j*3+k]) * fRoot;
        storage[j] = (m[j*3+i] + m[i*3+j]) * fRoot;
        storage[k] = (m[k*3+i] + m[i*3+k]) * fRoot;
    }
  }
  
  Quaternion inverse() {
    var a0 = storage[0], a1 = storage[1], a2 = storage[2], a3 = storage[3],
        dot = a0*a0 + a1*a1 + a2*a2 + a3*a3,
        invDot = dot ? 1.0/dot : 0;
    // TODO: Would be faster to return [0,0,0,0] immediately if dot == 0
    storage[0] = -a0*invDot;
    storage[1] = -a1*invDot;
    storage[2] = -a2*invDot;
    storage[3] = a3*invDot;
    return this;
  }
  
  double operator[](int i) => storage[i];
  void operator[]=(int i, double v) {
    storage[i] = v;
  }
  
  String toString() {
    return 'quat(${storage[0]}, ${storage[1]}, ${storage[2]}, ${storage[3]})';
  }
  
}