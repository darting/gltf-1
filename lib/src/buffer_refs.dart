part of orange;


class BufferRefs {
  String path;
  int byteLength;
  String type;
  ByteBuffer bytes;
  
  bool _isLoading = false;
  
  load() {
    if(!ready && !_isLoading) {
      _isLoading = true;
      html.HttpRequest.request(path, responseType: "arraybuffer").then((r){
        bytes = r.response;
        _isLoading = false;
      }).catchError((_) => _isLoading = false);
    }
  }
  
  bool get ready => bytes != null;
}