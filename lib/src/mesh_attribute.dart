part of orange;


class MeshAttribute {
  BufferView bufferView;
  int byteOffset;
  int byteStride;
  int count;
  int type;
  bool normalized;
  List<double> max;
  List<double> min;
  
  Uint16List createUint16List() {
    var offset = byteOffset + bufferView.byteOffset;
    return new Uint16List.view(bufferView.buffer.bytes, offset, count);
  }
  Float32List createFloat32List() {
    var offset = byteOffset + bufferView.byteOffset;
    return new Float32List.view(bufferView.buffer.bytes, offset, count);
  }
}