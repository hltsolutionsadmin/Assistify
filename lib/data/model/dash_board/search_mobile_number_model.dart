class SeachMobileNumberModel {
  String? status;
  String? message;
  List<Data>? data;

  SeachMobileNumberModel({this.status, this.message, this.data});

  SeachMobileNumberModel.fromJson(Map<String, dynamic> json) {
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
  String? customerName;
  String? address;
  String? phoneNumber;
  String? alternatePhoneNumber;

  Data(
      {this.customerName,
      this.address,
      this.phoneNumber,
      this.alternatePhoneNumber});

  Data.fromJson(Map<String, dynamic> json) {
    customerName = json['customerName'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    alternatePhoneNumber = json['alternatePhoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerName'] = this.customerName;
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['alternatePhoneNumber'] = this.alternatePhoneNumber;
    return data;
  }
}
