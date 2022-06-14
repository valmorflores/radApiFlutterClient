import '/modules/staff/infra/models/staff_key_model.dart';

abstract class StaffKeyDatasource {
  Future<List<StaffKeyModel>> getAll();
  Future<List<StaffKeyModel>> addKey(StaffKeyModel staffKeyModel);
  Future<List<StaffKeyModel>> getLastKey(StaffKeyModel staffKeyModel);
  Future<List<StaffKeyModel>> getMy(int staffid);
  Future<List<StaffKeyModel>> patchStaffKey(StaffKeyModel staffKeyModel);
}
