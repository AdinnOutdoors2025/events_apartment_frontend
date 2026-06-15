class OTPVerify {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  OTPVerify({this.success, this.statusCode, this.message, this.data});

  OTPVerify.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
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
  String? sId;
  String? userName;
  String? userPhone;
  int? userType;
  int? profileCompleted;
  int? customerType;

  User({
    this.sId,
    this.userName,
    this.userPhone,
    this.userType,
    this.profileCompleted,
    this.customerType,
  });

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['userName'];
    userPhone = json['userPhone'];
    userType = json['userType'];
    profileCompleted = json['profileCompleted'];
    customerType = json['customerType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userName'] = userName;
    data['userPhone'] = userPhone;
    data['userType'] = userType;
    data['profileCompleted'] = profileCompleted;
    data['customerType'] = customerType;
    return data;
  }
}
