class AllExpencesModel {
  String? status;
  String? message;
  List<Data>? data;

  AllExpencesModel({this.status, this.message, this.data});

  AllExpencesModel.fromJson(Map<String, dynamic> json) {
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
  String? expenseDate;
  String? description;
  String? category;
  num? amount;
  String? paymentMode;
  String? referenceNumber;
  String? createdAt;
  String? updatedAt;
  String? userId;
  String? companyId;

  Data(
      {this.id,
      this.expenseDate,
      this.description,
      this.category,
      this.amount,
      this.paymentMode,
      this.referenceNumber,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.companyId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expenseDate = json['expenseDate'];
    description = json['description'];
    category = json['category'];
    amount = json['amount'];
    paymentMode = json['paymentMode'];
    referenceNumber = json['referenceNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    companyId = json['companyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expenseDate'] = this.expenseDate;
    data['description'] = this.description;
    data['category'] = this.category;
    data['amount'] = this.amount;
    data['paymentMode'] = this.paymentMode;
    data['referenceNumber'] = this.referenceNumber;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['companyId'] = this.companyId;
    return data;
  }
}
