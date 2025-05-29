class AllBillsModel {
  String? status;
  String? message;
  Data? data;

  AllBillsModel({this.status, this.message, this.data});

  AllBillsModel.fromJson(Map<String, dynamic> json) {
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
  List<Bills>? bills;
  num? totalRecords;

  Data({this.bills, this.totalRecords});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['bills'] != null) {
      bills = <Bills>[];
      json['bills'].forEach((v) {
        bills!.add(new Bills.fromJson(v));
      });
    }
    totalRecords = json['totalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bills != null) {
      data['bills'] = this.bills!.map((v) => v.toJson()).toList();
    }
    data['totalRecords'] = this.totalRecords;
    return data;
  }
}

class Bills {
  String? id;
  String? jobId;
  String? customerName;
  String? address;
  String? phoneNumber;
  String? alternatePhoneNumber;
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

  Bills(
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

  Bills.fromJson(Map<String, dynamic> json) {
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

