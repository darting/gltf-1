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
  

  TypedData createTypedData() {
    var offset = byteOffset + bufferView.byteOffset;
    switch(type) {
      case gl.FLOAT_VEC3:
        return new Float32List.view(bufferView.buffer.bytes, offset, count * byteStride ~/ 4);
      case gl.UNSIGNED_SHORT:
        return new Uint16List.view(bufferView.buffer.bytes, offset, count);
      default:
        throw new Exception("Not support yet");
    }
  }
}