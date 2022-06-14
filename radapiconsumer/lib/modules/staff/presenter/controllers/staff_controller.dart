import 'package:dartz/dartz.dart';
import '/core/constants/kpresenter.dart';
import '/modules/staff/domain/usecases/get_staff_all.dart';
import '/modules/staff/domain/usecases/patch_staff_image.dart';
import '/modules/staff/domain/usecases/patch_staff_name.dart';
import '/utils/globals.dart';
import 'package:path/path.dart';
import '/core/platform/network_info.dart';
import '/modules/staff/domain/repositories/staff_repository.dart';
import '/modules/staff/domain/usecases/get_staff_by_id.dart';
import '/modules/staff/external/api/eiapi_staff_datasource.dart';
import '/modules/staff/infra/datasources/staff_datasource.dart';
import '/modules/staff/infra/models/staff_model.dart';
import '/modules/staff/infra/repositories/staff_repository_impl.dart';
import '/modules/update/presenter/controllers/url_controller.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class StaffController extends GetxController {
  UrlController urlController = Get.put(UrlController());

  RxInt count = 0.obs;
  RxString urlImage = ''.obs;

  late final staffList = <StaffModel>[].obs;

  late int selectedStaffId;
  late StaffModel selectedStaffModel;

  final dio = WksCustomDio.withAuthentication().instance;
  late StaffDatasource datasource;
  late StaffRepository repository;
  late GetStaffById getById;
  late GetStaffAll getStaffAll;

  selectStaff(int _staffid) async {
    if (_staffid > 0) {
      var result = await getById.call(_staffid);
      if (result.isRight()) {
        var info = (result as Right).value;
        final List<StaffModel> _myUrlModel = info;
        _myUrlModel.forEach((element) {
          selectedStaffModel = element;
          selectedStaffId = _staffid;
          String _urlImage = getImageUrlByStaffId(_staffid);
          changeImage(_urlImage);
        });
      }
      count++;
      update();
      return true;
    } else {
      return false;
    }
  }

  changeImage(file) async {
    if (file.substring(0, 4) == 'http') {
      urlImage.value = file;
    } else {
      urlImage.value = await uploadImage(file);
    }
    update();
  }

  // uploadImage
  uploadImage(String _file) async {
    debugPrint('f7704 - start upload from local: $_file');
    _patchStaffImage(basename(_file));
    String _urlImage = _directoryApiUrl(selectedStaffId, _file);
    urlImage.value = _urlImage;
    debugPrint('f7704 - url:  $_urlImage');
    return _urlImage;
  }

  _directoryApiUrl(int staffid, String _file) {
    // with personal workspace, folder is "workspace-foder"
    if (app_workspace_name != '') {
      return app_urlapi +
          '/download/' +
          app_workspace_name +
          '-staff/' +
          staffid.toString() +
          '/' +
          basename(_file);
    } else {
      return app_urlapi +
          '/download/staff/' +
          staffid.toString() +
          '/' +
          basename(_file);
    }
  }

  _directoryDirectUrl(String _file) {
    return urlController.getUrls()!.staffProfileUpload +
        selectedStaffId.toString() +
        '/' +
        basename(_file);
  }

  _patchStaffImage(String _file) async {
    debugPrint('f8004 - Patch: $_file');
    StaffModel _staffModel =
        StaffModel(staffid: selectedStaffId, profileImage: _file);
    PatchStaffImage _patchStaffImageImpl = PatchStaffImageImpl(repository);
    await _patchStaffImageImpl.call(_staffModel);
    debugPrint('f8004 - Do changed profile image information');
    return true;
  }

  postChangeName({required String firstname, required String lastname}) async {
    var result = await _patchStaffName(firstname, lastname);
    if (result.isRight()) {
      var info = (result as Right).value;
      final List<StaffModel> _myUrlModel = info;
      _myUrlModel.forEach((element) {
        selectedStaffModel.firstname = element.firstname;
        selectedStaffModel.lastname = element.lastname;
        selectedStaffId = element.staffid ?? 0;
        count++;
      });
    }

    update();
  }

  _patchStaffName(String _firstname, _lastname) async {
    debugPrint('f8004 - Patch firstname: $_firstname, lastname: $_lastname ');
    StaffModel _staffModel = StaffModel(
        staffid: selectedStaffId, firstname: _firstname, lastname: _lastname);
    PatchStaffName _patchStaffNameImpl = PatchStaffNameImpl(repository);
    return await _patchStaffNameImpl.call(_staffModel);
  }

  loadStaffList() async {
    var result = await getStaffAll.call();
    staffList.clear();
    if (result.isRight()) {
      var info = (result as Right).value;
      final List<StaffModel> _myUrlModel = info;
      _myUrlModel.forEach((element) {
        staffList.add(element);
      });
    }
    update();
  }

  getImageUrlByStaffId(int _staffid) {
    String _file = '';
    String _url = '';
    if (staffList.isNotEmpty) {
      staffList.forEach((element) {
        if (element.staffid == _staffid) {
          _file = element.profileImage ?? '';
        }
      });
      if (_file.trim() == '') {
      } else {
        _url = _directoryApiUrl(_staffid, _file);
      }
    } else {
      // todo: change for optional image
    }
    if (_url.trim() == '') {
      _url = kDefaultStaffImage;
    }
    return _url;
  }

  @override
  void onInit() {
    selectedStaffId = 0;

    // Links for data get
    datasource = EIAPIStaffDatasource(dio);
    repository = StaffRepositoryImpl(datasource);
    getById = GetStaffByIdImpl(repository);
    getStaffAll = GetStaffAllImpl(repository);

    selectedStaffModel = StaffModel();
    urlImage.value = '';
    //'https://cosems.com/rs/integrador/uploads/staff_profile_images/1/thumb_valmor1.jpeg';

    super.onInit();
  }
}
