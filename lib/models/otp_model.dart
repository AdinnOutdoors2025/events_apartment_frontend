class OTPVerify {
  bool? success;
  String? message;
  String? token;
  User? user;

  OTPVerify({this.success, this.message, this.token, this.user});

  OTPVerify.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
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
  int? customerType;
  int? profileCompleted;

  User(
      {this.sId,
        this.userName,
        this.userPhone,
        this.userType,
        this.customerType,
        this.profileCompleted});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['userName'];
    userPhone = json['userPhone'];
    userType = json['userType'];
    customerType = json['customerType'];
    profileCompleted = json['profileCompleted'] as int?;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userName'] = userName;
    data['userPhone'] = userPhone;
    data['userType'] = userType;
    data['customerType'] = customerType;
    data['profileCompleted'] = profileCompleted;
    return data;
  }
}
