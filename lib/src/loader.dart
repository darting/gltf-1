part of orange;


class Loader {
  
  Map<String, Buffer> _buffers = new Map();
  Map<String, BufferView> _bufferViews = new Map();
  Map<String, html.ImageElement> _images = new Map();
  Map<String, Indices> _indices = new Map();
  Map<String, MeshAttribute> _attributes = new Map();
  Map<String, Mesh> _meshes = new Map();
  Map<String, Node> _nodes = new Map();

  Loader(String path) {
    html.HttpRequest.getString(path)
      .then((rsp) => _parse(JSON.decode(rsp)))
        .catchError((e) => print(e));
  }
  
  _parse(json) {
    var categoriesDepsOrder = ["buffers", "bufferViews", "images",  "videos", "samplers", "textures", 
                               "shaders", "programs", "techniques", "materials", "indices", "attributes", "accessors",
                               "meshes", "cameras", "lights", "skins", "nodes", "scenes", "animations"];
    InstanceMirror mirror = reflect(this);
    categoriesDepsOrder.every((category){
      var description = json[category];
      return mirror.invoke(new Symbol("handle${StringHelper.capitalize(category)}"), [description]);
    });
    
  }
  
  handleBuffers(Map description) {
    description.forEach((k, v){
      var buffer = new Buffer();
      buffer.path = v["path"];
      buffer.byteLength = v["byteLength"];
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
      image.path = v["path"];
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
  
  handleIndices(Map description) {
    description.forEach((k, v){
      var indices = new MeshAttribute();
      indices.bufferView = _bufferViews[v["bufferView"]];
      indices.byteOffset = v["byteOffset"];
      indices.count = v["count"];
      indices.type = v["type"];
      _attributes[k] = indices;
    });
    return true;
  }
  
  handleAttributes(description) {
    description.forEach((k, v){
      var attr = new MeshAttribute();
      attr.bufferView = _bufferViews[v["bufferView"]];
      attr.byteOffset = v["byteOffset"];
      attr.count = v["count"];
      attr.type = v["type"];
      attr.max = v["max"];
      attr.min = v["min"];
      attr.normalized = v["normalized"];
      _attributes[k] = attr;
    });
    return true;
  }
  
  handleAccessors(description) {
    description.forEach((k, v){
      var attr = new MeshAttribute();
      attr.bufferView = _bufferViews[v["bufferView"]];
      attr.byteOffset = v["byteOffset"];
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
        var primitive = new Primitive();
        primitive.indices = _attributes[v["indices"]];
        primitive.semantics = v["semantics"];
        return primitive;
      }, growable: false);
      _meshes[k] = mesh;
    });
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
      var node = new Node();
      node.name = v["name"];
      node.childNames = new List();
      node.matrix = _newMatrix4FromArray(v["matrix"]);
      var meshes = v["meshes"];
      if(meshes != null) {
        node.meshes = new List.generate(meshes.length, (i){
          return _meshes[meshes[i]];
        }, growable: false);
      }
      _nodes[k] = node;
    });
  }
  
  handleScenes(description) {
    
  }
  
  handleAnimations(description) {
    return true;
  }
  
  _newMatrix4FromArray(List arr) {
    return new Matrix4(arr[0], arr[1], arr[2], arr[3],
        arr[4], arr[5], arr[6], arr[7],
        arr[8], arr[9], arr[10], arr[11],
        arr[12], arr[13], arr[14], arr[15]);
  }
}













