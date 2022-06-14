import 'dart:convert';

import '/modules/update/domain/entities/update_result.dart';

class UpdateModel extends UpdateResult {
  String? operation;
  String? result;

  UpdateModel({
    this.operation,
    this.result,
  });

  UpdateModel copyWith({
    String? operation,
    String? result,
  }) {
    return UpdateModel(
      operation: operation ?? this.operation,
      result: result ?? this.result,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'operation': operation,
      'result': result,
    };
  }

  factory UpdateModel.fromMap(Map<String, dynamic> map) {
    return UpdateModel(
      operation: map['operation'],
      result: map['result'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateModel.fromJson(String source) =>
      UpdateModel.fromMap(json.decode(source));

  @override
  String toString() => 'UpdateModel(operation: $operation, result: $result)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdateModel &&
        other.operation == operation &&
        other.result == result;
  }

  @override
  int get hashCode => operation.hashCode ^ result.hashCode;
}
