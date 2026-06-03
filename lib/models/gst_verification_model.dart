class GstVerification {
  bool? success;
  String? message;
  String? gstNumber;
  Data? data;

  GstVerification({this.success, this.message, this.data,this.gstNumber});

  GstVerification.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'gst_number': gstNumber,
    };
  }
}

class Data {
  String? gstDetailId;
  String? businessName;
  String? businessAddress;
  String? gstNumber;
  String? source;

  Data(
      {this.gstDetailId,
        this.businessName,
        this.businessAddress,
        this.gstNumber,
        this.source});

  Data.fromJson(Map<String, dynamic> json) {
    gstDetailId = json['gstDetailId'];
    businessName = json['business_name'];
    businessAddress = json['business_address'];
    gstNumber = json['gst_number'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gstDetailId'] = gstDetailId;
    data['business_name'] = businessName;
    data['business_address'] = businessAddress;
    data['gst_number'] = gstNumber;
    data['source'] = source;
    return data;
  }
}
