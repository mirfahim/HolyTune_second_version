import 'dart:convert';

PackageListModel packageListModelFromJson(String str) =>
    PackageListModel.fromJson(json.decode(str));

class PackageListModel {
  PackageListModel({
    this.status,
    this.packages,
    this.isLastPage,
  });

  String status;
  List<Package> packages;
  bool isLastPage;

  factory PackageListModel.fromJson(Map<String, dynamic> json) =>
      PackageListModel(
        status: json["status"],
        packages: List<Package>.from(
            json["packages"].map((x) => Package.fromJson(x))),
        isLastPage: json["isLastPage"],
      );
}

class Package {
  Package({
    this.id,
    this.packageName,
    this.days,
    this.amount,
  });

  String id;
  String packageName;
  String days;
  String amount;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        packageName: json["package_name"],
        days: json["days"],
        amount: json["amount"],
      );
}
