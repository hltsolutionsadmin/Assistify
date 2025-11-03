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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerName'] = customerName;
    data['address'] = address;
    data['phoneNumber'] = phoneNumber;
    data['alternatePhoneNumber'] = alternatePhoneNumber;
    return data;
  }
}
