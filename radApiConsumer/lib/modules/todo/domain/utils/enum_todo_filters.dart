import 'package:flutter/foundation.dart';

enum TodoFilters { filterAll, filterFinished, filterUnfinished }

extension TodoFiltersExtension on TodoFilters {
  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case TodoFilters.filterAll:
        return 'Lista completa';
      case TodoFilters.filterFinished:
        return 'Lista finalizados';
      case TodoFilters.filterUnfinished:
        return 'Lista não finalizados';
      default:
        return 'Lista completa';
    }
  }
}
