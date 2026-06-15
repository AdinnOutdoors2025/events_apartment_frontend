class ProfileModel {
  bool? success;
  String? message;
  Data? data;

  ProfileModel({this.success, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? brandOwnerName;
  String? companyBrandName;
  String? email;
  String? gstNumber;
  String? industryCategory;
  String? productServiceDescription;
  LogoDocument? logoDocument;
  String? targetCustomer;
  int? averageProductPrice;
  String? campaignGoal;
  int? profileCompleted;
  int? customerType;
  String? userId;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.brandOwnerName,
        this.companyBrandName,
        this.email,
        this.gstNumber,
        this.industryCategory,
        this.productServiceDescription,
        this.logoDocument,
        this.targetCustomer,
        this.averageProductPrice,
        this.campaignGoal,
        this.profileCompleted,
        this.customerType,
        this.userId,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    brandOwnerName = json['brandOwnerName'];
    companyBrandName = json['companyBrandName'];
    email = json['email'];
    gstNumber = json['gstNumber'];
    industryCategory = json['industryCategory'];
    productServiceDescription = json['productServiceDescription'];
    logoDocument = json['logoDocument'] != null
        ?  LogoDocument.fromJson(json['logoDocument'])
        : null;
    targetCustomer = json['targetCustomer'];
    averageProductPrice = json['averageProductPrice'];
    campaignGoal = json['campaignGoal'];
    profileCompleted = json['profileCompleted'];
    customerType = json['customerType'];
    userId = json['userId'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = sId;
    data['brandOwnerName'] = brandOwnerName;
    data['companyBrandName'] = companyBrandName;
    data['email'] = email;
    data['gstNumber'] = gstNumber;
    data['industryCategory'] = industryCategory;
    data['productServiceDescription'] = productServiceDescription;
    if (logoDocument != null) {
      data['logo'] = logoDocument!.toJson();
    }
    data['targetCustomer'] = targetCustomer;
    data['averageProductPrice'] = averageProductPrice;
    data['campaignGoal'] = campaignGoal;
    data['profileCompleted'] = profileCompleted;
    data['customerType'] = customerType;
    return data;
  }
}

class LogoDocument {
  String? uploadedAt;

  LogoDocument({this.uploadedAt});

  LogoDocument.fromJson(Map<String, dynamic> json) {
    uploadedAt = json['uploadedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uploadedAt'] = uploadedAt;
    return data;
  }
}
