class ClientResult {
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

  ClientResult(
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
}
