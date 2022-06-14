import '../../../../modules/clients/domain/entities/client_result.dart';

class ClientModel extends ClientResult {
  int? userid;
  String? company;
  String? vat;
  String? phonenumber;
  int? country;
  String? city;
  String? zip;
  String? state;
  String? address;
  String? website;
  String? datecreated;
  int? active;
  int? leadid;
  String? billingStreet;
  String? billingCity;
  String? billingState;
  String? billingZip;
  int? billingCountry;
  String? shippingStreet;
  String? shippingCity;
  String? shippingState;
  String? shippingZip;
  int? shippingCountry;
  String? longitude;
  String? latitude;
  String? defaultLanguage;
  int? defaultCurrency;
  int? showPrimaryContact;
  String? stripeId;
  int? registrationConfirmed;
  int? addedfrom;

  ClientModel(
      {this.userid,
      this.company,
      this.vat,
      this.phonenumber,
      this.country,
      this.city,
      this.zip,
      this.state,
      this.address,
      this.website,
      this.datecreated,
      this.active,
      this.leadid,
      this.billingStreet,
      this.billingCity,
      this.billingState,
      this.billingZip,
      this.billingCountry,
      this.shippingStreet,
      this.shippingCity,
      this.shippingState,
      this.shippingZip,
      this.shippingCountry,
      this.longitude,
      this.latitude,
      this.defaultLanguage,
      this.defaultCurrency,
      this.showPrimaryContact,
      this.stripeId,
      this.registrationConfirmed,
      this.addedfrom});

  ClientModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    company = json['company'];
    vat = json['vat'];
    phonenumber = json['phonenumber'];
    country = json['country'];
    city = json['city'];
    zip = json['zip'] ?? '';
    state = json['state'];
    address = json['address'];
    website = json['website'];
    datecreated = json['datecreated'];
    active = json['active'];
    leadid = json['leadid'] ?? 0;
    billingStreet = json['billing_street'];
    billingCity = json['billing_city'];
    billingState = json['billing_state'];
    billingZip = json['billing_zip'];
    billingCountry = json['billing_country'];
    shippingStreet = json['shipping_street'];
    shippingCity = json['shipping_city'];
    shippingState = json['shipping_state'];
    shippingZip = json['shipping_zip'];
    shippingCountry = json['shipping_country'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    defaultLanguage = json['default_language'];
    defaultCurrency = json['default_currency'];
    showPrimaryContact = json['show_primary_contact'];
    stripeId = json['stripe_id'];
    registrationConfirmed = json['registration_confirmed'];
    addedfrom = json['addedfrom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userid'] = this.userid;
    data['company'] = this.company;
    data['vat'] = this.vat;
    data['phonenumber'] = this.phonenumber;
    data['country'] = this.country;
    data['city'] = this.city;
    data['zip'] = this.zip;
    data['state'] = this.state;
    data['address'] = this.address;
    data['website'] = this.website;
    data['datecreated'] = this.datecreated;
    data['active'] = this.active;
    data['leadid'] = this.leadid;
    data['billing_street'] = this.billingStreet;
    data['billing_city'] = this.billingCity;
    data['billing_state'] = this.billingState;
    data['billing_zip'] = this.billingZip;
    data['billing_country'] = this.billingCountry;
    data['shipping_street'] = this.shippingStreet;
    data['shipping_city'] = this.shippingCity;
    data['shipping_state'] = this.shippingState;
    data['shipping_zip'] = this.shippingZip;
    data['shipping_country'] = this.shippingCountry;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['default_language'] = this.defaultLanguage;
    data['default_currency'] = this.defaultCurrency;
    data['show_primary_contact'] = this.showPrimaryContact;
    data['stripe_id'] = this.stripeId;
    data['registration_confirmed'] = this.registrationConfirmed;
    data['addedfrom'] = this.addedfrom;
    return data;
  }
}
