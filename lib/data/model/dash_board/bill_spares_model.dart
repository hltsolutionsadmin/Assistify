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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['billId'] = billId;
    data['productId'] = productId;
    data['product'] = product;
    data['quantity'] = quantity;
    data['price'] = price;
    data['description'] = description;
    return data;
  }
}
