abstract class SystemThemeDataState {}

class StartState implements SystemThemeDataState {
  const StartState();
}

class LoadingState implements SystemThemeDataState {
  const LoadingState();
}

class SuccessState implements SystemThemeDataState {
  final String theme;
  const SuccessState(this.theme);
}

class ErrorState implements SystemThemeDataState {
  final String error;
  const ErrorState(this.error);
}
