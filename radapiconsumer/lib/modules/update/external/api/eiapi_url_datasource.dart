import 'dart:convert';

import 'package:dio/dio.dart';
import '/modules/update/infra/datasources/url_datasource.dart';
import '/modules/update/infra/models/url_model.dart';
import '/utils/globals.dart';
import 'package:flutter/cupertino.dart';

class EIAPIUrlDatasource implements UrlDatasource {
  final Dio dio;

  EIAPIUrlDatasource(this.dio);

  @override
  Future<UrlModel> getAll() async {
    debugPrint('f7484 - EIAPI_URLMODEL_DATASOURCE_ via getAll');
    final String _url = app_urlapi + "/urls";
    debugPrint('f7484 - url (0): $_url');
    var result = await this.dio.get(_url);
    debugPrint('f7484 - url (1): $_url');
    //var result = await this.dio.get(app_urlapi + "/contacts");
    if (result.statusCode == 200) {
      var data = result.data['data']['urls'];
      late UrlModel urlModel;
      var item = data;
      urlModel = UrlModel(
        activityUpload: item['activity_upload'] ?? '',
        workspaceManager: item['workspace_manager'] ?? '',
        root: item['root'] ?? '',
        download: item['download'] ?? '',
        upload: item['upload'] ?? '',
        webmodule: item['webmodule'] ?? '',
        webmoduleAdmin: item['webmodule_admin'] ?? '',
        webmoduleCfgBaseUrl: item['webmodule_cfg_base_url'] ?? '',
        webmoduleCfgMainDomain: item['webmodule_cfg_main_domain'] ?? '',
        taskUpload: item['task_upload'] ?? '',
        projectUpload: item['project_upload'] ?? '',
        staffProfileUpload: item['staff_profile_upload'] ?? '',
        companyUpload: item['company_upload'] ?? '',
        clientUpload: item['client_upload'] ?? '',
        ticketUpload: item['ticket_upload'] ?? '',
        expenseUpload: item['expense_upload'] ?? '',
        leadsUpload: item['leads_upload'] ?? '',
        discussionUpload: item['discussion_upload'] ?? '',
        cashflowUpload: item['cashflow_upload'] ?? '',
        knowledgeBaseUpload: item['knowledge_base_upload'] ?? '',
      );

      return urlModel;
    } else {
      throw Exception();
    }
  }
}
