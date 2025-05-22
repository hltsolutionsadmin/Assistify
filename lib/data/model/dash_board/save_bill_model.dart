class SaveBillModel {
  String? status;
  String? message;
  Data? data;

  SaveBillModel({this.status, this.message, this.data});

  SaveBillModel.fromJson(Map<String, dynamic> json) {
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
  List<Bill>? bill;

  Data({this.bill});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['bill'] != null) {
      bill = <Bill>[];
      json['bill'].forEach((v) {
        bill!.add(new Bill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bill != null) {
      data['bill'] = this.bill!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bill {
  String? id;
  String? jobId;
  String? customerName;
  String? address;
  String? phoneNumber;
  Null? alternatePhoneNumber;
  String? productName;
  String? modelNumber;
  String? serialNumber;
  String? complaint;
  String? otherAccessories;
  String? status;
  num? paidAmount;
  num? balance;
  num? totalAmount;
  String? createdAt;
  String? updatedAt;
  Null? deliveryDate;
  String? statusDescription;
  String? paymentType;
  String? userId;
  String? companyId;
  Null? billSpares;

  Bill(
      {this.id,
      this.jobId,
      this.customerName,
      this.address,
      this.phoneNumber,
      this.alternatePhoneNumber,
      this.productName,
      this.modelNumber,
      this.serialNumber,
      this.complaint,
      this.otherAccessories,
      this.status,
      this.paidAmount,
      this.balance,
      this.totalAmount,
      this.createdAt,
      this.updatedAt,
      this.deliveryDate,
      this.statusDescription,
      this.paymentType,
      this.userId,
      this.companyId,
      this.billSpares});

  Bill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['jobId'];
    customerName = json['customerName'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    alternatePhoneNumber = json['alternatePhoneNumber'];
    productName = json['productName'];
    modelNumber = json['modelNumber'];
    serialNumber = json['serialNumber'];
    complaint = json['complaint'];
    otherAccessories = json['otherAccessories'];
    status = json['status'];
    paidAmount = json['paidAmount'];
    balance = json['balance'];
    totalAmount = json['totalAmount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deliveryDate = json['deliveryDate'];
    statusDescription = json['statusDescription'];
    paymentType = json['paymentType'];
    userId = json['userId'];
    companyId = json['companyId'];
    billSpares = json['billSpares'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['jobId'] = this.jobId;
    data['customerName'] = this.customerName;
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['alternatePhoneNumber'] = this.alternatePhoneNumber;
    data['productName'] = this.productName;
    data['modelNumber'] = this.modelNumber;
    data['serialNumber'] = this.serialNumber;
    data['complaint'] = this.complaint;
    data['otherAccessories'] = this.otherAccessories;
    data['status'] = this.status;
    data['paidAmount'] = this.paidAmount;
    data['balance'] = this.balance;
    data['totalAmount'] = this.totalAmount;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deliveryDate'] = this.deliveryDate;
    data['statusDescription'] = this.statusDescription;
    data['paymentType'] = this.paymentType;
    data['userId'] = this.userId;
    data['companyId'] = this.companyId;
    data['billSpares'] = this.billSpares;
    return data;
  }
}
