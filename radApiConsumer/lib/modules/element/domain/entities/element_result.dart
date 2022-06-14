import 'package:flutter/rendering.dart';

import 'element_types.dart';

class ElementResult {
  int? index;
  int? id;
  int? root_element;
  ElementType? type;
  String? name;
  String? subtitle;
  String? keywords;
  int? order;
  int? timestamp;
  int? last_change_timestamp;
  bool? selected;
  bool? deleted;
  bool? visible;
  bool? active;
  bool? checked;
  bool? wait;
  bool? refreshApp;
  bool? can_remove;
  bool? can_move;
  bool? can_edit;
  String? icon;
  Color? color;
  String? route;

  ElementResult(
      {this.index,
      this.id,
      this.root_element,
      this.type,
      this.name,
      this.subtitle,
      this.keywords,
      this.order,
      this.timestamp,
      this.last_change_timestamp,
      this.deleted,
      this.visible = true,
      this.selected = false,
      this.active,
      this.checked = false,
      this.refreshApp = false,
      this.wait = false,
      this.can_remove,
      this.can_move,
      this.can_edit,
      this.icon,
      this.color,
      this.route});
}
