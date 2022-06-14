import 'dart:convert';

import '../../../../modules/contacts/infra/models/contact_model.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/wks_custom_dio.dart';
import 'package:flutter/cupertino.dart';

class DirectContactRepository {
  Future<List<ContactModel>> getAll() {
    var dio = WksCustomDio.withAuthentication().instance;
    debugPrint('GET ' + app_urlapi + '/contacts ');
    return dio.get(app_urlapi + '/contacts').then((res) {
      debugPrint(res.toString());
      //return res.data.map<ContactModel>(ContactModel.fromJson).toList();
      List<ContactModel> contacts = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        contacts.add(ContactModel.fromJson(item));
      });
      return contacts;
    });
  }

  Future<List<ContactModel>> getByClientId(int id) {
    var dio = WksCustomDio.withAuthentication().instance;
    debugPrint('GET ' + app_urlapi + '/clients/:id/contacts ');
    return dio
        .get(app_urlapi + '/clients/' + id.toString() + '/contacts')
        .then((res) {
      debugPrint(res.toString());
      //return res.data.map<ContactModel>(ContactModel.fromJson).toList();
      List<ContactModel> contacts = [];
      var dados = res.data['data'];
      dados.forEach((item) {
        contacts.add(ContactModel.fromJson(item));
      });
      return contacts;
    });
  }
}
