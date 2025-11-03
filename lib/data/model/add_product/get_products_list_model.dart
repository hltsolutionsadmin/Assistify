class GetProductsListModel {
  String? status;
  String? message;
  List<Data>? data;

  GetProductsListModel({this.status, this.message, this.data});

  GetProductsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productName'] = productName;
    data['price'] = price;
    data['quantity'] = quantity;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['userId'] = userId;
    data['companyId'] = companyId;
    return data;
  }
}
