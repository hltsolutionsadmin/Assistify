class UserProfileModel {
  String? status;
  String? message;
  Data? data;

  UserProfileModel({this.status, this.message, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? address;
  String? phoneNumber;
  String? email;
  String? logo;
  String? bannerImage;
  num? initialJOBID;
  Null? registeredIdentity;
  String? termsAndConditions;
  num? category;
  String? jobIdFormat;
  String? validityDate;
  String? createdAt;
  num? categoryId;
  String? updatedAt;
  Null? products;
  Null? bills;

  Data(
      {this.id,
      this.name,
      this.address,
      this.phoneNumber,
      this.email,
      this.logo,
      this.bannerImage,
      this.initialJOBID,
      this.registeredIdentity,
      this.termsAndConditions,
      this.category,
      this.jobIdFormat,
      this.validityDate,
      this.createdAt,
      this.categoryId,
      this.updatedAt,
      this.products,
      this.bills});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    logo = json['logo'];
    bannerImage = json['bannerImage'];
    initialJOBID = json['initialJOBID'];
    registeredIdentity = json['registeredIdentity'];
    termsAndConditions = json['termsAndConditions'];
    category = json['category'];
    categoryId = json['categoryId'];
    jobIdFormat = json['jobIdFormat'];
    validityDate = json['validityDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    products = json['products'];
    bills = json['bills'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['logo'] = this.logo;
    data['bannerImage'] = this.bannerImage;
    data['initialJOBID'] = this.initialJOBID;
    data['registeredIdentity'] = this.registeredIdentity;
    data['termsAndConditions'] = this.termsAndConditions;
    data['category'] = this.category;
    data['jobIdFormat'] = this.jobIdFormat;
    data['validityDate'] = this.validityDate;
    data['createdAt'] = this.createdAt;
    data['categoryId'] = this.categoryId;
    data['updatedAt'] = this.updatedAt;
    data['products'] = this.products;
    data['bills'] = this.bills;
    return data;
  }
}
