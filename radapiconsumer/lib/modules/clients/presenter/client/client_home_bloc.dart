import 'package:bloc/bloc.dart';
import '/modules/clients/domain/usecases/get_client_all.dart';
import '/modules/clients/presenter/client/states/clients_state.dart';
import 'package:rxdart/rxdart.dart';

class ClientHomeBloc extends Bloc<int, ClientsState> {
  final GetClientAll searchById;

  ClientHomeBloc(this.searchById) : super(const StartState());

  @override
  Stream<ClientsState> mapEventToState(int textSearch) async* {
    if (textSearch <= 0) {
      yield StartState();
      return;
    }

    yield const LoadingState();

    var result = await searchById();
    yield result.fold(
      (failure) => ErrorState(failure),
      (success) => SuccessState(success),
    );
  }

  @override
  void dispose() {
    this.close();
  }
}
