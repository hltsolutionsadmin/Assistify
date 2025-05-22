class BillSparesModel {
  String? status;
  String? message;
  List<Data>? data;

  BillSparesModel({this.status, this.message, this.data});

  BillSparesModel.fromJson(Map<String, dynamic> json) {
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
  String? billId;
  String? productId;
  String? product;
  num? quantity;
  num? price;
  String? description;

  Data(
      {this.id,
      this.billId,
      this.productId,
      this.product,
      this.quantity,
      this.price,
      this.description});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    billId = json['billId'];
    productId = json['productId'];
    product = json['product'];
    quantity = json['quantity'];
    price = json['price'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['billId'] = this.billId;
    data['productId'] = this.productId;
    data['product'] = this.product;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['description'] = this.description;
    return data;
  }
}
