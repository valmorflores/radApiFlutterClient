import '../../domain/entities/connection_result.dart';

class ConnectionModel extends ConnectionResult {
  int? id;
  String? description;
  String? url;

  ConnectionModel({
    this.id,
    this.description,
    this.url,
  });

  ConnectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}
