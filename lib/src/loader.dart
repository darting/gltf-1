part of orange;


class Loader {
  String _path;
  Uri _uri;
  Scene _scene;
  Map<String, BufferRefs> _buffers = new Map();
  Map<String, BufferView> _bufferViews = new Map();
  Map<String, html.ImageElement> _images = new Map();
  Map<String, Indices> _indices = new Map();
  Map<String, MeshAttribute> _attributes = new Map();
  Map<String, Mesh> _meshes = new Map();
  Map<String, Node> _nodes = new Map();
  Map<String, Camera> _cameras = new Map();

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
      var buffer = new BufferRefs();
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
      bufferView.bufferRefs = _buffers[v["buffer"]];
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
        primitive.indices = _attributes[p["indices"]];
        primitive.primitive = p["primitive"];
        p["attributes"].forEach((ak, av){
          if(ak == "NORMAL") primitive.normals = _attributes[av];
          if(ak == "POSITION") primitive.positions = _attributes[av];
          if(ak == "TEXCOORD_0" || ak == "TEXCOORD") primitive.texCoord = _attributes[av];
          if(ak == "JOINT") primitive.joints = _attributes[av];
          if(ak == "WEIGHT") primitive.weights = _attributes[av];
        });
        return primitive;
      }, growable: false);
      _meshes[k] = mesh;
    });
    return true;
  }
  
  handleCameras(description) {
    description.forEach((k, v) {
      var camera = new PerspectiveCamera(0.0);
      camera.fov = v["perspective"]["yfov"].toDouble();
      camera.far = v["perspective"]["zfar"].toDouble();
      camera.near = v["perspective"]["znear"].toDouble();
      _cameras[k] = camera;
    });
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
      if(v["light"] != null)
        return;
      if(v["camera"] != null) {
        var camera = _cameras[v["camera"]];
        camera.applyMatrix(_newMatrix4FromArray(v["matrix"]));
      } else {
        var node = new Node();
        node.name = v["name"];
        node.childNames = v["children"];
        node.applyMatrix(_newMatrix4FromArray(v["matrix"]));
        var meshes = v["meshes"];
        if(meshes != null) {
          node.meshes = new List.generate(meshes.length, (i){
            return _meshes[meshes[i]];
          }, growable: false);
        }else{
          node.meshes = new List(0);
        }
        _nodes[k] = node;
      }
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
        }else if(_cameras[name] != null) {
          _scene.camera = _cameras[name];
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
        arr[0].toDouble(), arr[4].toDouble(), arr[8].toDouble(), arr[12].toDouble(),
        arr[1].toDouble(), arr[5].toDouble(), arr[9].toDouble(), arr[13].toDouble(),
        arr[2].toDouble(), arr[6].toDouble(), arr[10].toDouble(), arr[14].toDouble(),
        arr[3].toDouble(), arr[7].toDouble(), arr[11].toDouble(), arr[15].toDouble());
  }
  
  _buildNodeHirerachy(Node node) {
    if(node.children == null)
      node.children = new List();
    node.childNames.forEach((child){
      _nodes[child].parent = node;
      node.children.add(_nodes[child]);
      _buildNodeHirerachy(_nodes[child]);
    });
  }
}













