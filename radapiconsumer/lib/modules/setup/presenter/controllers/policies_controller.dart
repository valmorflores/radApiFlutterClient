import '/modules/setup/external/api/mgr_policies_repository.dart';
import '/modules/setup/presenter/policies/policies_accept.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kPoliciesSlotVar = 'policies_accepted';

enum PoliciesState { isAccepted, isRejected, isUndefined }

class PoliciesController extends GetxController {
  final RxInt count = 0.obs;
  late SharedPreferences sharedPref;
  PoliciesState policiesState = PoliciesState.isUndefined;
  late MgrPoliciesRepository repository;

  Future<String> getPolicies() async {
    var result = await repository.getPolicies('pt_br');
    return result;
  }

  loadInformation() async {
    sharedPref = await SharedPreferences.getInstance();
    String _policiesAccepted = sharedPref.getString(kPoliciesSlotVar) ?? '?';
    if (_policiesAccepted == '?') {
      policiesState = PoliciesState.isUndefined;
    }
    if (_policiesAccepted == '1') {
      policiesState = PoliciesState.isAccepted;
    }
    if (_policiesAccepted == '0') {
      policiesState = PoliciesState.isRejected;
    }
  }

  // read and result state
  Future<PoliciesState> getPoliciesState() async {
    if (policiesState == PoliciesState.isUndefined) {
      await loadInformation();
    }
    return policiesState;
  }

  setToAccepted() {
    policiesState = PoliciesState.isAccepted;
    savePoliciedState(PoliciesState.isAccepted);
  }

  savePoliciedState(PoliciesState policiesState) async {
    String _policiesAccepted = '?';
    if (policiesState == PoliciesState.isAccepted) {
      _policiesAccepted = '1';
    }
    if (policiesState == PoliciesState.isRejected) {
      _policiesAccepted = '0';
    }
    if (policiesState == PoliciesState.isUndefined) {
      _policiesAccepted = '?';
    }
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(kPoliciesSlotVar, _policiesAccepted);
  }

  @override
  void onInit() {
    repository = MgrPoliciesRepository();
    // TODO: implement onInit
    super.onInit();
  }
}
