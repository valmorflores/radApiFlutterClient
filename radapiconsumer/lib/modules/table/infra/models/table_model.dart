import '../../domain/entities/table_result.dart';

class TableModel extends TableResult {
  int? id;
  String? name;

  TableModel({
    this.id,
    this.name,
  });

  TableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
