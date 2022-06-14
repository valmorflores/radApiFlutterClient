import '../../../modules/staff/infra/models/staff_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ApplicationController extends GetxController {
  List<StaffModel> app_staffModelList = [];
  var count = 0.obs;

  void clearStaff() {
    app_staffModelList.clear();
    app_staffModelList = [];
    update();
  }

  void addStaffs(List<StaffModel> staffs) {
    debugPrint('f6700 - Add staff to list (into applicationController)');
    clearStaff();
    app_staffModelList.addAll(staffs);
    update();
    debugPrint('f6700 - done');
  }

  void increment() {
    count++;
    update();
  }
}
