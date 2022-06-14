import 'package:dartz/dartz.dart';
import '/modules/element/domain/entities/element_result.dart';
import '/modules/element/domain/errors/erros.dart';
import '/modules/element/domain/repositories/elements_repository.dart';

mixin GetByIndex {
  Future<Either<Failure, List<ElementResult>>> call(int index);
}

//? @Injectable(singleton: false)
class GetByIndexImpl implements GetByIndex {
  final ElementsRepository repository;

  GetByIndexImpl(this.repository);

  @override
  Future<Either<Failure, List<ElementResult>>> call(int index) async {
    var option = optionOf(index);

    return option.fold(() => Left(InvalidSearchText()), (idx) async {
      var result = await repository.getByIndex(idx);
      return result.fold(
          (l) => left(l), (r) => r.isEmpty ? left(EmptyList()) : right(r));
    });
  }
}
