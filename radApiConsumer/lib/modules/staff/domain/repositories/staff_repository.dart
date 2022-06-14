import 'package:dartz/dartz.dart';
import '/modules/staff/domain/entities/staff_key_result.dart';
import '/modules/staff/domain/errors/errors.dart';
import '/modules/staff/domain/entities/staff_result.dart';

abstract class StaffRepository {
  Future<Either<Failure, List<StaffResult>>> getStaffById(int id);
  Future<Either<Failure, List<StaffResult>>> getStaffAll();
  Future<Either<Failure, List<StaffResult>>> addStaff(StaffResult staff);
  Future<Either<Failure, List<StaffResult>>> updateById(StaffResult staff);
  Future<Either<Failure, List<StaffResult>>> getMe();
  Future<Either<Failure, List<StaffResult>>> patchStaffImage(StaffResult staff);
  Future<Either<Failure, List<StaffResult>>> patchStaffName(StaffResult staff);
  Future<Either<Failure, List<StaffKeyResult>>> getMyKeys();
  Future<Either<Failure, List<StaffKeyResult>>> addKey(StaffKeyResult staffkey);
}
