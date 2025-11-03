class LogInModel {
  String? status;
  String? message;
  Data? data;

  LogInModel({this.status, this.message, this.data});

  LogInModel.fromJson(Map<String, dynamic> json) {
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
  String? token;
  User? user;

  Data({this.token, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? userId;
  String? email;
  String? companyId;
  String? firstName;
  String? lastName;

  User(
      {this.userId, this.email, this.companyId, this.firstName, this.lastName});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    companyId = json['companyId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['email'] = email;
    data['companyId'] = companyId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    return data;
  }
}
