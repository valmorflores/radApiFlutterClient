import 'dart:convert';

import '/modules/todo/domain/entities/todo_result.dart';
import '/modules/todo/infra/constants/enum_staterecords.dart';
import 'package:flutter/foundation.dart';

class TodoModel extends TodoResult {
  int? index;
  int? todoid;
  String? description;
  int? staffid;
  String? dateadded;
  String? timeadded;
  bool? finished;
  String? datefinished;
  String? timefinished;
  int? itemOrder;
  int? relId;
  String? relType;
  StatusRecord? status;

  TodoModel(
      {this.index,
      this.todoid,
      this.description,
      this.staffid,
      this.dateadded,
      this.finished,
      this.timeadded,
      this.datefinished,
      this.timefinished,
      this.itemOrder,
      this.relId,
      this.relType,
      this.status});

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'todoid': todoid,
      'description': description,
      'dateadded': dateadded,
      'timeadded': timeadded,
      'datefinished': datefinished,
      'timefinished': timefinished,
      'finisehd': finished,
      'item_order': itemOrder,
      'rel_id': relId,
      'rel_type': relType,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      index: map['index'],
      todoid: map['todoid'],
      description: map['description'],
      dateadded: map['dateadded'],
      timeadded: map['timeadded'],
      datefinished: map['datefinished'],
      timefinished: map['timefinished'],
      itemOrder: map['item_order'],
      relId: map['rel_id'],
      relType: map['rel_type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TodoModel(index: $index, id: $todoid, '
        'description: $description, dateadded: $dateadded, '
        'timeadded: $timeadded, finished: $finished, '
        'datefinished: $datefinished, timefinished: $timefinished, '
        'rel_type: $relType, rel_id: $relId, item_order: $itemOrder )';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TodoModel &&
        o.index == index &&
        o.todoid == todoid &&
        o.description == description &&
        o.finished == finished &&
        o.dateadded == dateadded &&
        o.timeadded == timeadded &&
        o.datefinished == datefinished &&
        o.timefinished == timefinished &&
        o.relId == relId;
  }

  @override
  int get hashCode {
    return index.hashCode ^
        todoid.hashCode ^
        description.hashCode ^
        dateadded.hashCode ^
        timeadded.hashCode ^
        finished.hashCode ^
        datefinished.hashCode ^
        timefinished.hashCode;
  }
}
