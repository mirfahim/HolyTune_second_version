// To parse this JSON data, do
//
//     final spTokenModel = spTokenModelFromJson(jsonString);

import 'dart:convert';

SpTokenModel spTokenModelFromJson(String str) =>
    SpTokenModel.fromJson(json.decode(str));

String spTokenModelToJson(SpTokenModel data) => json.encode(data.toJson());

class SpTokenModel {
  SpTokenModel({
    this.token,
    this.storeId,
    this.executeUrl,
    this.tokenType,
    this.spCode,
    this.massage,
    this.tokenCreateTime,
    this.expiresIn,
  });

  String token;
  int storeId;
  String executeUrl;
  String tokenType;
  String spCode;
  String massage;
  String tokenCreateTime;
  int expiresIn;

  factory SpTokenModel.fromJson(Map<String, dynamic> json) => SpTokenModel(
        token: json["token"],
        storeId: json["store_id"],
        executeUrl: json["execute_url"],
        tokenType: json["token_type"],
        spCode: json["sp_code"],
        massage: json["massage"],
        tokenCreateTime: json["TokenCreateTime"],
        expiresIn: json["expires_in"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "store_id": storeId,
        "execute_url": executeUrl,
        "token_type": tokenType,
        "sp_code": spCode,
        "massage": massage,
        "TokenCreateTime": tokenCreateTime,
        "expires_in": expiresIn,
      };
}
