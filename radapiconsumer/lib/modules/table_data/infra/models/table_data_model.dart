import '../../domain/entities/table_data_result.dart';

class TableDataModel extends TableDataResult {
  int? id;
  String? name;
  String? type;
  int? size;
  String? default_data;

  TableDataModel({
    this.id,
    this.name,
    this.type,
    this.size,
    this.default_data,
  });

  TableDataModel.fromJson(Map<String, dynamic> json) {
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
