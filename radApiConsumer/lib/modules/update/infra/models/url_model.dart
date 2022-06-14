import '/modules/update/domain/entities/url_result.dart';

class UrlModel extends UrlResult {
  String workspaceManager;
  String root;
  String download;
  String upload;
  String webmodule;
  String webmoduleAdmin;
  String webmoduleCfgBaseUrl;
  String webmoduleCfgMainDomain;
  String activityUpload;
  String taskUpload;
  String projectUpload;
  String staffProfileUpload;
  String companyUpload;
  String clientUpload;
  String ticketUpload;
  String expenseUpload;
  String leadsUpload;
  String discussionUpload;
  String cashflowUpload;
  String knowledgeBaseUpload;

  UrlModel({
    required this.workspaceManager,
    required this.root,
    required this.download,
    required this.upload,
    required this.webmodule,
    required this.webmoduleAdmin,
    required this.webmoduleCfgBaseUrl,
    required this.webmoduleCfgMainDomain,
    required this.activityUpload,
    required this.taskUpload,
    required this.projectUpload,
    required this.staffProfileUpload,
    required this.companyUpload,
    required this.clientUpload,
    required this.ticketUpload,
    required this.expenseUpload,
    required this.leadsUpload,
    required this.discussionUpload,
    required this.cashflowUpload,
    required this.knowledgeBaseUpload,
  }) : super(
          activityUpload: activityUpload,
          workspaceManager: workspaceManager,
          root: root,
          download: download,
          upload: upload,
          webmodule: webmodule,
          webmoduleAdmin: webmoduleAdmin,
          webmoduleCfgBaseUrl: webmoduleCfgBaseUrl,
          webmoduleCfgMainDomain: webmoduleCfgMainDomain,
          taskUpload: taskUpload,
          projectUpload: projectUpload,
          staffProfileUpload: staffProfileUpload,
          companyUpload: companyUpload,
          clientUpload: clientUpload,
          ticketUpload: ticketUpload,
          expenseUpload: expenseUpload,
          leadsUpload: leadsUpload,
          discussionUpload: discussionUpload,
          cashflowUpload: cashflowUpload,
          knowledgeBaseUpload: knowledgeBaseUpload,
        );
}
