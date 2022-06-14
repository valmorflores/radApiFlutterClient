import 'package:dartz/dartz.dart';
import '/modules/staff/domain/entities/staff_key_result.dart';
import '/modules/staff/domain/errors/staff_key_errors.dart';
import '/modules/staff/infra/models/staff_key_model.dart';

abstract class StaffKeyRepository {
  Future<Either<Failure, List<StaffKeyResult>>> getMy();
  Future<Either<Failure, List<StaffKeyResult>>> addKey(
      StaffKeyResult staffKeyModel);
  Future<Either<Failure, List<StaffKeyResult>>> getLastKey(
      StaffKeyResult staffKeyModel);
  Future<Either<Failure, List<StaffKeyResult>>> patchStaffKey(
      StaffKeyResult staffKeyModel);
}
