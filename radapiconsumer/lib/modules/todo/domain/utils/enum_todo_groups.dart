import 'package:flutter/foundation.dart';

enum TodoGroups { groupAll, groupStatus, groupDate, groupDateFinished }

extension TodoGroupsExtension on TodoGroups {
  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case TodoGroups.groupAll:
        return 'Sem agrupamento';
      case TodoGroups.groupStatus:
        return 'Agrupado por situação';
      case TodoGroups.groupDate:
        return 'Agrupado por data';
      case TodoGroups.groupDateFinished:
        return 'Agrupado por data de finalização';
      default:
        return 'Sem agrupamento';
    }
  }
}
