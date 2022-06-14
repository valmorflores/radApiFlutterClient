import '/modules/todo/domain/utils/enum_todo_filters.dart';
import '/modules/todo/domain/utils/enum_todo_groups.dart';
import '/modules/todo/domain/utils/enum_todo_orders.dart';

class TodoOptionsModel {
  TodoFilters? filter;
  TodoGroups? group;
  TodoOrders? order;

  TodoOptionsModel({this.filter, this.group, this.order});
}
