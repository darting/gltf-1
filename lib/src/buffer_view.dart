part of orange;


class BufferView {
  Buffer buffer;
  int byteOffset;
  int byteLength;
  int target;
  
  createUint16List() => new Uint16List.view(buffer.bytes, byteOffset, byteLength);
  createFloat32List() => new Float32List.view(buffer.bytes, byteOffset, byteLength);
}