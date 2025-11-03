class UserProfileModel {
  String? status;
  String? message;
  Data? data;

  UserProfileModel({this.status, this.message, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
  Null registeredIdentity;
  String? termsAndConditions;
  num? category;
  String? jobIdFormat;
  String? validityDate;
  String? createdAt;
  num? categoryId;
  String? updatedAt;
  Null products;
  Null bills;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['logo'] = logo;
    data['bannerImage'] = bannerImage;
    data['initialJOBID'] = initialJOBID;
    data['registeredIdentity'] = registeredIdentity;
    data['termsAndConditions'] = termsAndConditions;
    data['category'] = category;
    data['jobIdFormat'] = jobIdFormat;
    data['validityDate'] = validityDate;
    data['createdAt'] = createdAt;
    data['categoryId'] = categoryId;
    data['updatedAt'] = updatedAt;
    data['products'] = products;
    data['bills'] = bills;
    return data;
  }
}
