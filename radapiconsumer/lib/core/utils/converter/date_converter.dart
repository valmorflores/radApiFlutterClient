import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import 'package:intl/intl.dart';

class DateConverter {
  Either<Failure, DateTime> today() {
    try {
      final DateTime now = DateTime.now();
      return Right(now);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }

  String todayDB() {
    DateTime dateTime = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String str = formatter.format(dateTime);
    return str;
  }
}

class InvalidInputFailure extends Failure {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
