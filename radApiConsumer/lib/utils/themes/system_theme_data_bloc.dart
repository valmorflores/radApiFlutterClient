import 'package:bloc/bloc.dart';
import 'system_theme_data_bloc_state.dart';
import 'package:rxdart/rxdart.dart';

class SystemThemeDataBloc extends Bloc<String, SystemThemeDataState> {
  final String result;

  SystemThemeDataBloc(this.result) : super(const StartState());

  @override
  Stream<SystemThemeDataState> mapEventToState(String textSearch) async* {
    if (textSearch.isEmpty) {
      yield StartState();
      return;
    }

    yield const LoadingState();

    //var result = await searchByText(textSearch);
    // put selected in
    var result = '1';
    /*yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    );*/
  }

  @override
  void dispose() {
    this.close();
  }
}
