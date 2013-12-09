part of orange;


class MeshAttribute {
  BufferView bufferView;
  int byteOffset;
  int byteStride;
  int count;
  String type;
  bool normalized;
  List<double> max;
  List<double> min;
}