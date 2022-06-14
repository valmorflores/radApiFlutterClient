import 'package:dartz/dartz.dart';
import '/modules/update/domain/errors/errors.dart';
import '/modules/update/domain/entities/url_result.dart';
import '/modules/update/domain/repositories/url_repository.dart';

mixin GetUrlAll {
  Future<Either<Failure, UrlResult>> call();
}

//? @Injectable(singleton: false)
class GetUrlAllImpl implements GetUrlAll {
  final UrlRepository repository;

  GetUrlAllImpl(this.repository);

  @override
  Future<Either<Failure, UrlResult>> call() async {
    var option = optionOf(0);

    return option.fold(() => Left(InvalidSearchText()), (i) async {
      var result = await repository.getAll();
      return result.fold(
          (l) => left(l), (r) => r == null ? left(EmptyList()) : right(r));
    });
  }
}
