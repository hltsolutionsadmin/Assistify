class InventroryProductsModel {
  String? status;
  String? message;
  List<Data>? data;

  InventroryProductsModel({this.status, this.message, this.data});

  InventroryProductsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? productName;
  num? price;
  num? quantity;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? userId;
  String? companyId;

  Data(
      {this.id,
      this.productName,
      this.price,
      this.quantity,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.companyId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    price = json['price'];
    quantity = json['quantity'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    companyId = json['companyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productName'] = this.productName;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['companyId'] = this.companyId;
    return data;
  }
}
