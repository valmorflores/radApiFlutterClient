import '/modules/contacts/domain/entities/contact_result.dart';

class ContactModel extends ContactResult {
  int? index;
  int? id;
  int? userid;
  int? isPrimary;
  String? firstname;
  String? lastname;
  String? email;
  String? phonenumber;
  String? title;
  String? datecreated;
  String? password;
  String? newPassKey;
  String? newPassKeyRequested;
  String? emailVerifiedAt;
  String? emailVerificationKey;
  String? emailVerificationSentAt;
  String? lastIp;
  String? lastLogin;
  String? lastPasswordChange;
  String? active;
  String? profileImage;
  String? direction;
  String? invoiceEmails;
  String? estimateEmails;
  String? creditNoteEmails;
  String? contractEmails;
  String? taskEmails;
  String? projectEmails;
  String? ticketEmails;
  String? lastLoginTime;
  String? lastActiveTime;

  ContactModel(
      {this.index,
      this.id,
      this.userid,
      this.isPrimary,
      this.firstname,
      this.lastname,
      this.email,
      this.phonenumber,
      this.title,
      this.datecreated,
      this.password,
      this.newPassKey,
      this.newPassKeyRequested,
      this.emailVerifiedAt,
      this.emailVerificationKey,
      this.emailVerificationSentAt,
      this.lastIp,
      this.lastLogin,
      this.lastPasswordChange,
      this.active,
      this.profileImage,
      this.direction,
      this.invoiceEmails,
      this.estimateEmails,
      this.creditNoteEmails,
      this.contractEmails,
      this.taskEmails,
      this.projectEmails,
      this.ticketEmails,
      this.lastLoginTime,
      this.lastActiveTime});

  ContactModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    id = json['id'];
    userid = json['userid'];
    isPrimary = json['is_primary'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    title = json['title'];
    datecreated = json['datecreated'];
    password = json['password'];
    newPassKey = json['new_pass_key'];
    newPassKeyRequested = json['new_pass_key_requested'];
    emailVerifiedAt = json['email_verified_at'];
    emailVerificationKey = json['email_verification_key'];
    emailVerificationSentAt = json['email_verification_sent_at'];
    lastIp = json['last_ip'];
    lastLogin = json['last_login'];
    lastPasswordChange = json['last_password_change'];
    active = json['active'];
    profileImage = json['profile_image'];
    direction = json['direction'];
    invoiceEmails = json['invoice_emails'];
    estimateEmails = json['estimate_emails'];
    creditNoteEmails = json['credit_note_emails'];
    contractEmails = json['contract_emails'];
    taskEmails = json['task_emails'];
    projectEmails = json['project_emails'];
    ticketEmails = json['ticket_emails'];
    lastLoginTime = json['last_login_time'];
    lastActiveTime = json['last_active_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['index'] = this.index;
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['is_primary'] = this.isPrimary;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    data['title'] = this.title;
    data['datecreated'] = this.datecreated;
    data['password'] = this.password;
    data['new_pass_key'] = this.newPassKey;
    data['new_pass_key_requested'] = this.newPassKeyRequested;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['email_verification_key'] = this.emailVerificationKey;
    data['email_verification_sent_at'] = this.emailVerificationSentAt;
    data['last_ip'] = this.lastIp;
    data['last_login'] = this.lastLogin;
    data['last_password_change'] = this.lastPasswordChange;
    data['active'] = this.active;
    data['profile_image'] = this.profileImage;
    data['direction'] = this.direction;
    data['invoice_emails'] = this.invoiceEmails;
    data['estimate_emails'] = this.estimateEmails;
    data['credit_note_emails'] = this.creditNoteEmails;
    data['contract_emails'] = this.contractEmails;
    data['task_emails'] = this.taskEmails;
    data['project_emails'] = this.projectEmails;
    data['ticket_emails'] = this.ticketEmails;
    data['last_login_time'] = this.lastLoginTime;
    data['last_active_time'] = this.lastActiveTime;
    return data;
  }
}
