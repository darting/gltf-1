part of orange;


class Loader {
  String _path;
  Uri _uri;
  Scene _scene;
  Map<String, Buffer> _buffers = new Map();
  Map<String, BufferView> _bufferViews = new Map();
  Map<String, html.ImageElement> _images = new Map();
  Map<String, Indices> _indices = new Map();
  Map<String, MeshAttribute> _attributes = new Map();
  Map<String, Mesh> _meshes = new Map();
  Map<String, Node> _nodes = new Map();

  Loader(this._path) {
    _uri = Uri.parse(_path);
  }
  
  Future<Scene> start() {
    var completer = new Completer<Scene>();
    html.HttpRequest.getString(_path)
      .then((rsp){
          if(_parse(JSON.decode(rsp))){
            completer.complete(_scene);
          }else{
            completer.completeError("parse failure");
          }
      })
      .catchError((Error e) => print([e, e.stackTrace]));
    return completer.future;
  }
  
  _parse(json) {
    var categoriesDepsOrder = ["buffers", "bufferViews", "images",  "videos", "samplers", "textures", 
                               "shaders", "programs", "techniques", "materials", "accessors",
                               "meshes", "cameras", "lights", "skins", "nodes", "scenes", "animations"];
    InstanceMirror mirror = reflect(this);
    return categoriesDepsOrder.every((category){
      var description = json[category];
      if(description != null)
        return mirror.invoke(new Symbol("handle${StringHelper.capitalize(category)}"), [description]).reflectee;
      return true;
    });
  }
  
  handleBuffers(Map description) {
    description.forEach((k, v){
      var buffer = new Buffer();
      buffer.path = _uri.resolve(v["path"]).toString();
      buffer.byteLength = v["byteLength"];
      buffer.type = v["type"];
      _buffers[k] = buffer;
    });
    return true;
  }
  
  handleBufferViews(Map description) {
    description.forEach((k, v){
      var bufferView = new BufferView();
      bufferView.buffer = _buffers[v["buffer"]];
      bufferView.byteLength = v["byteLength"];
      bufferView.byteOffset = v["byteOffset"];
      bufferView.target = v["target"];
      _bufferViews[k] = bufferView;
    });
    return true;
  }
  
  handleImages(Map description) {
    description.forEach((k, v){
      var image = new Image();
      image.name = v["name"];
      image.path = _uri.resolve(v["path"]).toString();
      image.generateMipmap = v["generateMipmap"];
      _images[k] = image;
    });
    return true;
  }
  
  handleVideos(description) {
    return true;
  }
  
  handleSamplers(description) {
    return true;
  }
  
  handleTextures(description) {
    return true;
  }
  
  handleShaders(description) {
    return true;
  }
  
  handlePrograms(description) {
    return true;
  }
  
  handleTechniques(description) {
    return true;
  }
  
  handleMaterials(description) {
    return true;  
  }
  
  handleAccessors(description) {
    description.forEach((k, v){
      var attr = new MeshAttribute();
      attr.bufferView = _bufferViews[v["bufferView"]];
      attr.byteOffset = v["byteOffset"];
      attr.byteStride = v["byteStride"];
      attr.count = v["count"];
      attr.type = v["type"];
      attr.max = v["max"];
      attr.min = v["min"];
      attr.normalized = v["normalized"];
      _attributes[k] = attr;
    });
    return true;
  }
  
  handleMeshes(Map description) {
    description.forEach((k, v){
      var mesh = new Mesh();
      mesh.name = v["name"];
      var primitives = v["primitives"];
      mesh.primitives = new List.generate(primitives.length, (i){
        var p = primitives[i];
        var primitive = new Primitive();
        primitive.indicesAttr = _attributes[p["indices"]];
        primitive.primitive = p["primitive"];
        p["attributes"].forEach((ak, av){
          if(ak == "NORMAL") primitive.normalAttr = _attributes[av];
          if(ak == "POSITION") primitive.positionAttr = _attributes[av];
          if(ak == "TEXCOORD_0" || ak == "TEXCOORD") primitive.texCoordAttr = _attributes[av];
          if(ak == "JOINT") primitive.jointAttr = _attributes[av];
          if(ak == "WEIGHT") primitive.weightAttr = _attributes[av];
        });
        return primitive;
      }, growable: false);
      _meshes[k] = mesh;
    });
    return true;
  }
  
  handleCameras(description) {
    return true;
  }
  
  handleLights(description) {
    return true;
  }
  
  handleSkins(description) {
    return true;
  }
  
  handleNodes(Map description) {
    description.forEach((k, v){
      if(v["light"] != null || v["camera"] != null)
        return;
      var node = new Node();
      node.name = v["name"];
      node.childNames = v["children"];
      node.matrix = _newMatrix4FromArray(v["matrix"]);
      var meshes = v["meshes"];
      if(meshes != null) {
        node.meshes = new List.generate(meshes.length, (i){
          return _meshes[meshes[i]];
        }, growable: false);
      }else{
        node.meshes = new List(0);
      }
      _nodes[k] = node;
    });
    return true;
  }
  
  handleScenes(Map description) {
    var json = description.values.first;
    if(json != null) {
      _scene = new Scene();
      _scene.nodes = new List();
      json["nodes"].forEach((name){
        var node = _nodes[name];
        if(node != null) {
          _scene.nodes.add(node);
          _buildNodeHirerachy(node);
        }
      });
      return true;
    }else{
      return false;
    }
  }
  
  handleAnimations(description) {
    return true;
  }
  
  _newMatrix4FromArray(List arr) {
    return new Matrix4(
        arr[0].toDouble(), arr[1].toDouble(), arr[2].toDouble(), arr[3].toDouble(),
        arr[4].toDouble(), arr[5].toDouble(), arr[6].toDouble(), arr[7].toDouble(),
        arr[8].toDouble(), arr[9].toDouble(), arr[10].toDouble(), arr[11].toDouble(),
        arr[12].toDouble(), arr[13].toDouble(), arr[14].toDouble(), arr[15].toDouble());
  }
  
  _buildNodeHirerachy(Node node) {
    if(node.children == null)
      node.children = new List();
    node.childNames.forEach((child){
      node.children.add(_nodes[child]);
      _buildNodeHirerachy(_nodes[child]);
    });
  }
}













