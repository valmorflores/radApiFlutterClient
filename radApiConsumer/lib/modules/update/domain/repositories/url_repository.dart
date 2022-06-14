import 'package:dartz/dartz.dart';
import '/modules/update/domain/errors/errors.dart';
import '/modules/update/domain/entities/url_result.dart';

abstract class UrlRepository {
  Future<Either<Failure, UrlResult>> getAll();
}
