import '../../../../modules/profile/domain/entities/profile_result.dart';
import '../../../../modules/profile/domain/errors/erros.dart';
import '../../../../modules/profile/infra/models/profile_model.dart';

abstract class ProfileState {}

class StartState implements ProfileState {
  const StartState();
}

class LoadingState implements ProfileState {
  const LoadingState();
}

class ErrorState implements ProfileState {
  final Failure error;
  const ErrorState(this.error);
}

class ErrorDeleteState implements ProfileState {
  final Failure error;
  const ErrorDeleteState(this.error);
}

class SuccessState implements ProfileState {
  final List<ProfileResult> list;
  const SuccessState(this.list);
}

class SuccessDeleteState implements ProfileState {
  final bool result;
  const SuccessDeleteState(this.result);
}
