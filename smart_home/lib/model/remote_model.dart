class RemoteModel {
  String key;
  dynamic params;
  String parentId;

  RemoteModel(this.key, this.params);

  Map<String, dynamic> toJson() {
    return {"method": key, "params": params};
  }
}
