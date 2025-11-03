class AllBillsModel {
  String? status;
  String? message;
  Data? data;

  AllBillsModel({this.status, this.message, this.data});

  AllBillsModel.fromJson(Map<String, dynamic> json) {
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
  List<Bills>? bills;
  num? totalRecords;

  Data({this.bills, this.totalRecords});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['bills'] != null) {
      bills = <Bills>[];
      json['bills'].forEach((v) {
        bills!.add(Bills.fromJson(v));
      });
    }
    totalRecords = json['totalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bills != null) {
      data['bills'] = bills!.map((v) => v.toJson()).toList();
    }
    data['totalRecords'] = totalRecords;
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
  Null deliveryDate;
  String? statusDescription;
  String? paymentType;
  String? userId;
  String? companyId;
  Null billSpares;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['jobId'] = jobId;
    data['customerName'] = customerName;
    data['address'] = address;
    data['phoneNumber'] = phoneNumber;
    data['alternatePhoneNumber'] = alternatePhoneNumber;
    data['productName'] = productName;
    data['modelNumber'] = modelNumber;
    data['serialNumber'] = serialNumber;
    data['complaint'] = complaint;
    data['otherAccessories'] = otherAccessories;
    data['status'] = status;
    data['paidAmount'] = paidAmount;
    data['balance'] = balance;
    data['totalAmount'] = totalAmount;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deliveryDate'] = deliveryDate;
    data['statusDescription'] = statusDescription;
    data['paymentType'] = paymentType;
    data['userId'] = userId;
    data['companyId'] = companyId;
    data['billSpares'] = billSpares;
    return data;
  }
}

