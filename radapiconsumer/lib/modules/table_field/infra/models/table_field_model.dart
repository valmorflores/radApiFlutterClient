import '../../domain/entities/table_field_result.dart';

class TableFieldModel extends TableFieldResult {
  int? id;
  String? name;
  String? type;
  int? size;
  String? default_data;

  TableFieldModel({
    this.id,
    this.name,
    this.type,
    this.size,
    this.default_data,
  });

  TableFieldModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    size = json['size'];
    default_data = json['desult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['size'] = this.size;
    data['desult'] = this.default_data;
    return data;
  }
}
