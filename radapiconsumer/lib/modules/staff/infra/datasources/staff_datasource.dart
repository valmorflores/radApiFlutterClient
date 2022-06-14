import '/modules/staff/domain/usecases/patch_staff_key.dart';
import '/modules/staff/infra/models/staff_model.dart';

abstract class StaffDatasource {
  Future<List<StaffModel>> searchText(String textSearch);
  Future<List<StaffModel>> getAll();
  Future<List<StaffModel>> getById(int id);
  Future<List<StaffModel>> addStaff(StaffModel staff);
  Future<List<StaffModel>> getMe();
  Future<List<StaffModel>> updateById(StaffModel clientModel);
  Future<List<StaffModel>> patchStaffImage(StaffModel staffModel);
  Future<List<StaffModel>> patchStaffName(StaffModel staffModel);
}
