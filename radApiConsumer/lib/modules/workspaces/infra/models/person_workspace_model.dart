import 'dart:convert';

import '/modules/workspaces/domain/entities/person_workspace_result.dart';

class PersonWorkspaceModel extends PersonWorkspaceResult {
  int? index;
  int? id;
  int? workspaceId;
  int? paperId;
  String? name;
  bool? isConfirmed;
  String? workspaceKeyValue;

  PersonWorkspaceModel({
    this.index,
    this.id,
    this.workspaceId,
    this.paperId,
    this.name,
    this.isConfirmed,
    this.workspaceKeyValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'index': index.toString(),
      'id': id.toString(),
      'workspaceId': workspaceId,
      'name': name,
      'isConfirmed': isConfirmed,
      'workspaceKeyValue': workspaceKeyValue,
    };
  }

  static PersonWorkspaceModel fromMap(Map<String, dynamic> map) {
    return PersonWorkspaceModel(
      index: map['index'],
      id: map['id'],
      workspaceId: map['id'],
      name: map['name'],
      isConfirmed: map['isConfirmed'],
      workspaceKeyValue: map['workspaceKeyValue'],
    );
  }

  String toJson() => json.encode(toMap());

  static PersonWorkspaceModel fromJson(String source) =>
      fromMap(json.decode(source));
}
