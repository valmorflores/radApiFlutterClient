import '../../../../modules/profile/infra/models/profile_model.dart';

abstract class ProfileDatasource {
  Future<List<ProfileModel>> getAll();
  Future<List<ProfileModel>> getById(int id);
  Future<List<ProfileModel>> getDetailById(int id);
  Future<int> getIdByEmail(String email);
}
