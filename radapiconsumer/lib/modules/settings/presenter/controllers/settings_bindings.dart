import '/modules/settings/presenter/controllers/settings_local_data_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<SettingsLocalDataController>(
        () => SettingsLocalDataController());
  }
}
