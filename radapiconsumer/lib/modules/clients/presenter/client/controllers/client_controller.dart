import 'package:dartz/dartz.dart';
import '../../../../../modules/clients/domain/repositories/client_repository.dart';
import '../../../../../modules/clients/domain/usecases/add_client.dart';
import '../../../../../modules/clients/domain/usecases/delete_client_by_id.dart';
import '../../../../../modules/clients/domain/usecases/get_client_all.dart';
import '../../../../../modules/clients/domain/usecases/get_client_by_id.dart';
import '../../../../../modules/clients/domain/usecases/update_client.dart';
import '../../../../../modules/clients/external/api/eiapi_clients_datasource.dart';
import '../../../../../modules/clients/infra/datasources/clients_datasource.dart';
import '../../../../../modules/clients/infra/models/client_model.dart';
import '../../../../../modules/clients/infra/repositories/client_repository_impl.dart';
import '../../../../../utils/wks_custom_dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/state_manager.dart';

class ClientController extends GetxController {
  RxInt count = 0.obs;
  RxInt clientId = 0.obs;
  RxBool isProcessing = false.obs;

  final dio = WksCustomDio.withAuthentication().instance;
  late ClientsDatasource datasource;
  late ClientRepository repository;
  late GetClientAll search;
  late GetClientById getClientById;
  late DeleteClientById deleteClientById;
  late UpdateClient updateClient;
  late AddClient addClient;

  late TextEditingController nameController;
  late TextEditingController phonenumberController;
  late TextEditingController useridController;
  late TextEditingController companyController;
  late TextEditingController vatController;
  late TextEditingController countryController;
  late TextEditingController cityController;
  late TextEditingController zipController;
  late TextEditingController stateController;
  late TextEditingController addressController;
  late TextEditingController websiteController;
  late TextEditingController datecreatedController;
  late TextEditingController activeController;
  late TextEditingController leadidController;
  late TextEditingController billing_streetController;
  late TextEditingController billing_cityController;
  late TextEditingController billing_stateController;
  late TextEditingController billing_zipController;
  late TextEditingController billing_countryController;
  late TextEditingController shipping_streetController;
  late TextEditingController shipping_cityController;
  late TextEditingController shipping_stateController;
  late TextEditingController shipping_zipController;
  late TextEditingController shipping_countryController;
  late TextEditingController longitudeController;
  late TextEditingController latitudeController;
  late TextEditingController default_languageController;
  late TextEditingController default_currencyController;
  late TextEditingController show_primary_contactController;
  late TextEditingController stripe_idController;
  late TextEditingController registration_confirmedController;
  late TextEditingController addedfromController;
  late TextEditingController last_changeController;

  final nameKey = GlobalKey<FormFieldState>();
  final companyKey = GlobalKey<FormFieldState>();
  final phonenumberKey = GlobalKey<FormFieldState>();
  final useridKey = GlobalKey<FormFieldState>();
  final vatKey = GlobalKey<FormFieldState>();
  final countryKey = GlobalKey<FormFieldState>();
  final cityKey = GlobalKey<FormFieldState>();
  final zipKey = GlobalKey<FormFieldState>();
  final stateKey = GlobalKey<FormFieldState>();
  final addressKey = GlobalKey<FormFieldState>();
  final websiteKey = GlobalKey<FormFieldState>();
  final datecreatedKey = GlobalKey<FormFieldState>();
  final activeKey = GlobalKey<FormFieldState>();
  final leadidKey = GlobalKey<FormFieldState>();
  final billing_streetKey = GlobalKey<FormFieldState>();
  final billing_cityKey = GlobalKey<FormFieldState>();
  final billing_stateKey = GlobalKey<FormFieldState>();
  final billing_zipKey = GlobalKey<FormFieldState>();
  final billing_countryKey = GlobalKey<FormFieldState>();
  final shipping_streetKey = GlobalKey<FormFieldState>();
  final shipping_cityKey = GlobalKey<FormFieldState>();
  final shipping_stateKey = GlobalKey<FormFieldState>();
  final shipping_zipKey = GlobalKey<FormFieldState>();
  final shipping_countryKey = GlobalKey<FormFieldState>();
  final longitudeKey = GlobalKey<FormFieldState>();
  final latitudeKey = GlobalKey<FormFieldState>();
  final default_languageKey = GlobalKey<FormFieldState>();
  final default_currencyKey = GlobalKey<FormFieldState>();
  final show_primary_contactKey = GlobalKey<FormFieldState>();
  final stripe_idKey = GlobalKey<FormFieldState>();
  final registration_confirmedKey = GlobalKey<FormFieldState>();
  final addedfromKey = GlobalKey<FormFieldState>();
  final last_changeKey = GlobalKey<FormFieldState>();

  final formKey = GlobalKey<FormState>();

  loadClient(int id) async {
    isProcessing.value = true;
    update();
    var result = await getClientById.call(id);
    try {
      if ((result).isRight()) {
        ClientModel _client = ClientModel();
        var _resultList = ((result as Right).value as List<ClientModel>);
        _resultList.forEach((element) {
          _client = element;
        });

        _toControllers(_client);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    ++count;
    isProcessing.value = false;
    update();
  }

  delete(int id) {
    deleteClientById.call(id);
  }

  updateData() async {
    ClientModel _clientModel = _fromControllers();
    var result = await updateClient.call(_clientModel);
    try {
      if ((result).isRight()) {
        ClientModel _client = ClientModel();
        var _resultList = ((result as Right).value as List<ClientModel>);
        _resultList.forEach((element) {
          _client = element;
        });

        _toControllers(_client);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    ++count;
    isProcessing.value = false;
    update();
  }

  addData() async {
    isProcessing.value = true;
    ClientModel _clientModel = _fromControllers();
    var result = await addClient.call(_clientModel);
    try {
      if ((result).isRight()) {
        ClientModel _client = ClientModel();
        var _resultList = ((result as Right).value as List<ClientModel>);
        _resultList.forEach((element) {
          _client = element;
        });

        _toControllers(_client);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    ++count;
    isProcessing.value = false;
  }

// Load data from Model to controllers
  _toControllers(ClientModel _client) {
    companyController.text = '${_client.company}';
    phonenumberController.text = _client.phonenumber ?? '';
    useridController.text = (_client.userid ?? 0).toString();
    companyController.text = _client.company ?? '';
    vatController.text = _client.vat ?? '';
    countryController.text = (_client.country ?? 0).toString();
    cityController.text = _client.city ?? '';
    zipController.text = _client.zip ?? '';
    stateController.text = _client.state ?? '';
    addressController.text = _client.address ?? '';
    websiteController.text = _client.website ?? '';
    datecreatedController.text = _client.datecreated ?? '';
    activeController.text = (_client.active ?? 1).toString();
    leadidController.text = (_client.leadid ?? 0).toString();
    billing_streetController.text = _client.billingStreet ?? '';
    billing_cityController.text = _client.billingCity ?? '';
    billing_stateController.text = _client.billingState ?? '';
    billing_zipController.text = _client.billingZip ?? '';
    billing_countryController.text = (_client.billingCountry ?? 0).toString();
    shipping_streetController.text = _client.shippingStreet ?? '';
    shipping_cityController.text = _client.shippingCity ?? '';
    shipping_stateController.text = _client.shippingState ?? '';
    shipping_zipController.text = _client.shippingZip ?? '';
    shipping_countryController.text = (_client.shippingCountry ?? 0).toString();
    longitudeController.text = _client.longitude ?? '';
    latitudeController.text = _client.latitude ?? '';
    default_languageController.text = '';
    //(_client.default_language ?? '');
    //?default_currencyController.text = '';
    //? _client.default_currency ?? '';
    show_primary_contactController.text =
        (_client.showPrimaryContact ?? 1).toString();
    stripe_idController.text = (_client.stripeId ?? 0).toString();
    registration_confirmedController.text =
        (_client.registrationConfirmed ?? 0).toString();
    addedfromController.text = (_client.addedfrom ?? 0).toString();
    //?last_changeController.text = (_client.lastChange ?? '').toString();
  }

// Load data from Model to controllers
  _fromControllers() {
    ClientModel _client = ClientModel();
    // to resolver
    //? nameController.text = _client.name ?? '';
    //(_client.default_language ?? '');
    //?default_currencyController.text = '';
    //? _client.default_currency ?? '';
    //?last_changeController.text = (_client.lastChange ?? '').toString();

    _client.company = companyController.text;
    _client.phonenumber = phonenumberController.text;
    _client.userid =
        useridController.text == '' ? 0 : int.parse(useridController.text);
    _client.company = companyController.text;
    _client.vat = vatController.text;
    _client.country =
        countryController.text == '' ? 0 : int.parse(countryController.text);
    _client.city = cityController.text;
    _client.zip = zipController.text;
    _client.state = stateController.text;
    _client.address = addressController.text;
    _client.website = websiteController.text;
    _client.datecreated = datecreatedController.text;
    _client.active =
        activeController.text == '' ? 1 : int.parse(activeController.text);
    _client.leadid =
        leadidController.text == '' ? 0 : int.parse(leadidController.text);
    _client.billingStreet = billing_streetController.text;
    _client.billingCity = billing_cityController.text;
    _client.billingState = billing_stateController.text;
    _client.billingZip = billing_zipController.text;
    _client.billingCountry = billing_countryController.text.isEmpty
        ? 0
        : int.parse(billing_countryController.text);
    _client.shippingStreet = shipping_streetController.text;
    _client.shippingCity = shipping_cityController.text;
    _client.shippingState = shipping_stateController.text;
    _client.shippingZip = shipping_zipController.text;
    _client.shippingCountry = shipping_countryController.text.isEmpty
        ? 0
        : int.parse(shipping_countryController.text);
    _client.longitude = longitudeController.text;
    _client.latitude = latitudeController.text;
    _client.defaultLanguage = default_languageController.text;
    _client.showPrimaryContact =
        (show_primary_contactController.text == '1' ? 1 : 0);
    _client.stripeId = stripe_idController.text;
    _client.registrationConfirmed =
        registration_confirmedController.text == '1' ? 1 : 0;
    _client.addedfrom = addedfromController.text == ''
        ? 0
        : int.parse(addedfromController.text);

    return _client;
  }

  @override
  void onInit() {
    datasource = EIAPIClientsDatasource(dio);
    repository = ClientRepositoryImpl(datasource);
    deleteClientById = DeleteClientByIdImpl(repository);
    getClientById = GetClientByIdImpl(repository);
    addClient = AddClientImpl(repository);
    updateClient = UpdateClientImpl(repository);

    nameController = TextEditingController();
    phonenumberController = TextEditingController();
    useridController = TextEditingController();
    companyController = TextEditingController();
    vatController = TextEditingController();
    countryController = TextEditingController();
    cityController = TextEditingController();
    zipController = TextEditingController();
    stateController = TextEditingController();
    addressController = TextEditingController();
    websiteController = TextEditingController();
    datecreatedController = TextEditingController();
    activeController = TextEditingController();
    leadidController = TextEditingController();
    billing_streetController = TextEditingController();
    billing_cityController = TextEditingController();
    billing_stateController = TextEditingController();
    billing_zipController = TextEditingController();
    billing_countryController = TextEditingController();
    shipping_streetController = TextEditingController();
    shipping_cityController = TextEditingController();
    shipping_stateController = TextEditingController();
    shipping_zipController = TextEditingController();
    shipping_countryController = TextEditingController();
    longitudeController = TextEditingController();
    latitudeController = TextEditingController();
    default_languageController = TextEditingController();
    default_currencyController = TextEditingController();
    show_primary_contactController = TextEditingController();
    stripe_idController = TextEditingController();
    registration_confirmedController = TextEditingController();
    addedfromController = TextEditingController();
    last_changeController = TextEditingController();

    isProcessing.value = false;
    // TODO: implement onInit
    super.onInit();
  }
}
