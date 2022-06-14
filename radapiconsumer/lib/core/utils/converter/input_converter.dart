import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToInt(String str) {
    try {
      return Right(int.parse(str));
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
