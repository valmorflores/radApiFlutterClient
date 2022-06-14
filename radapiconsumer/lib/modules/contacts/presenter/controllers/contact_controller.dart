import 'package:dartz/dartz.dart';
import '/modules/contacts/domain/repositories/contacts_repository.dart';
import '/modules/contacts/domain/usecases/delete_by_id.dart';
import '/modules/contacts/domain/usecases/get_all.dart';
import '/modules/contacts/domain/usecases/get_by_id.dart';
import '/modules/contacts/external/api/eiapi_contact_datasource.dart';
import '/modules/contacts/infra/datasources/contact_datasource.dart';
import '/modules/contacts/infra/repositories/contact_repository_impl.dart';
import '/utils/wks_custom_dio.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ContactController extends GetxController {
  final dio = WksCustomDio.withAuthentication().instance;
  late ContactDatasource datasource;
  late ContactsRepository repository;
  late GetAll search;
  late GetById getById;
  late DeleteById deleteById;

  bool delete(int id) {
    try {
      bool _deleted = false;
      var result = deleteById.call(id);
      var info = (result as Right).value;
      _deleted = info ?? false;
      return _deleted;
    } catch (e) {
      return false;
    }
  }

  @override
  void onInit() {
    datasource = EIAPIContactDatasource(dio);
    repository = ContactRepositoryImpl(datasource);
    deleteById = DeleteByIdImpl(repository);
    // TODO: implement onInit
    super.onInit();
  }
}
