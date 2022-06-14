import '/modules/setup/infra/models/setup_install_vars.dart';
import 'package:flutter/cupertino.dart';

class SetupUtil {
  setupEmail() {
    String email = setup_app_device!.email;
    if (email == null || email == '') {
      email = setup_app_device!.alias;
      debugPrint('f8825 - ' + email);
      email = email.substring(0, email.length - 32);
      debugPrint('f8825 - ' + email);
      email = email.substring(5);
      debugPrint('f8825 - ' + email);
      //email = email.substring(5)
    }
    return email;
  }
}
