import '../models/user_login_model.dart';

abstract class UserLoginDatasource {
  Future<List<UserLoginModel>> postLogin(String email, String password);
}
