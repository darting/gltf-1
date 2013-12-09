part of orange;


class Buffer {
  String path;
  int byteLength;
  String type;
  ByteBuffer bytes;
  
  load(){
    var completer = new Completer();
    if(bytes == null) {
      html.HttpRequest.request(path, responseType: "arraybuffer").then((data){
        bytes = data;
        completer.complete();
      });
    }else{
      completer.complete();
    }
    return completer.future;
  }
  
  bool get ready => bytes != null;
}