import 'package:flutter/foundation.dart';

enum TodoOrders {
  normalDesc,
  normalAsc,
  dateDesc,
  dateAsc,
  statusDesc,
  statusAsc,
}

extension TodoOrdersExtension on TodoOrders {
  String get name => describeEnum(this);

  bool get isOrderDesc {
    switch (this) {
      case TodoOrders.dateDesc:
        return true;
      case TodoOrders.statusDesc:
        return true;
      case TodoOrders.normalDesc:
        return true;
      default:
        return false;
    }
  }

  bool get isOrderAsc {
    switch (this) {
      case TodoOrders.dateAsc:
        return true;
      case TodoOrders.statusAsc:
        return true;
      case TodoOrders.normalAsc:
        return true;
      default:
        return false;
    }
  }

  get inverse {
    // Asc to Desc
    if (this == TodoOrders.dateAsc) {
      return TodoOrders.dateDesc;
    } else if (this == TodoOrders.normalAsc) {
      return TodoOrders.normalDesc;
    } else if (this == TodoOrders.statusAsc) {
      return TodoOrders.statusDesc;
    } // Desc to Asc
    else if (this == TodoOrders.dateDesc) {
      return TodoOrders.dateAsc;
    } else if (this == TodoOrders.normalDesc) {
      return TodoOrders.normalAsc;
    } else if (this == TodoOrders.statusDesc) {
      return TodoOrders.statusAsc;
    } else {
      return TodoOrders.normalDesc;
    }
  }

  String get displayTitle {
    switch (this) {
      case TodoOrders.normalDesc:
        return 'Normal descendente';
      case TodoOrders.normalAsc:
        return 'Normal ascendente';
      case TodoOrders.dateAsc:
        return 'Data ascendente';
      case TodoOrders.dateDesc:
        return 'Data descendente';
      case TodoOrders.statusAsc:
        return 'Situação ascendente';
      case TodoOrders.statusDesc:
        return 'Situação descendente';
      default:
        return 'Ordem natural';
    }
  }
}
