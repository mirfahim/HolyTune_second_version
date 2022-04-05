// To parse this JSON data, do
//
//     final spCheckoutModel = spCheckoutModelFromJson(jsonString);

import 'dart:convert';

SpCheckoutModel spCheckoutModelFromJson(String str) =>
    SpCheckoutModel.fromJson(json.decode(str));

class SpCheckoutModel {
  SpCheckoutModel({
    this.checkoutUrl,
    this.amount,
    this.currency,
    this.spOrderId,
    this.customerOrderId,
    this.customerName,
    this.customerAddress,
    this.customerCity,
    this.customerPhone,
    this.customerEmail,
    this.clientIp,
    this.intent,
    this.transactionStatus,
  });

  String checkoutUrl;
  dynamic amount;
  dynamic currency;
  dynamic spOrderId;
  dynamic customerOrderId;
  dynamic customerName;
  dynamic customerAddress;
  dynamic customerCity;
  dynamic customerPhone;
  dynamic customerEmail;
  dynamic clientIp;
  dynamic intent;
  dynamic transactionStatus;

  factory SpCheckoutModel.fromJson(Map<String, dynamic> json) =>
      SpCheckoutModel(
        checkoutUrl: json["checkout_url"],
        amount: json["amount"],
        currency: json["currency"],
        spOrderId: json["sp_order_id"],
        customerOrderId: json["customer_order_id"],
        customerName: json["customer_name"],
        customerAddress: json["customer_address"],
        customerCity: json["customer_city"],
        customerPhone: json["customer_phone"],
        customerEmail: json["customer_email"],
        clientIp: json["client_ip"],
        intent: json["intent"],
        transactionStatus: json["transactionStatus"],
      );
}
