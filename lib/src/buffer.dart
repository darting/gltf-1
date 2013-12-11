part of orange;


class Buffer {
  String path;
  int byteLength;
  String type;
  ByteBuffer bytes;
  Completer _completer;
  
  Future load(){
    if(_completer == null) {
      _completer = new Completer();
      if(bytes == null) {
        html.HttpRequest.request(path, responseType: "arraybuffer").then((r){
          bytes = r.response;
          _completer.complete();
        });
      } else {
        _completer.complete();
      }
    }
    return _completer.future;
  }
  
  bool get ready => bytes != null;
}