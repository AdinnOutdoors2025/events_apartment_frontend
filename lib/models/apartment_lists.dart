class ApartmentList {
  bool? success;
  String? message;
  Data? data;

  ApartmentList({this.success, this.message, this.data});

  ApartmentList.fromJson(Map<String, dynamic> json) {
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
  int? pageNumber;
  int? count;
  int? totalCount;
  int? totalPages;
  File? file;
  List<String>? locationFilter;
  List<String>? cityFilter;
  List<String>? stateFilter;
  PriceRange? priceRange;
  List<Apartments>? apartments;

  Data(
      {this.pageNumber,
        this.count,
        this.totalCount,
        this.totalPages,
        this.file,
        this.locationFilter,
        this.cityFilter,
        this.stateFilter,
        this.priceRange,
        this.apartments});

  Data.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    count = json['count'];
    totalCount = json['totalCount'];
    totalPages = json['totalPages'];
    file = json['file'] != null ?  File.fromJson(json['file']) : null;
    locationFilter = json['locationFilter'].cast<String>();
    cityFilter = json['cityFilter'].cast<String>();
    stateFilter = json['stateFilter'].cast<String>();
    priceRange = json['priceRange'] != null
        ?  PriceRange.fromJson(json['priceRange'])
        : null;
    if (json['apartments'] != null) {
      apartments = <Apartments>[];
      json['apartments'].forEach((v) {
        apartments!.add( Apartments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNumber'] = pageNumber;
    data['count'] = count;
    data['totalCount'] = totalCount;
    data['totalPages'] = totalPages;
    if (file != null) {
      data['file'] = file!.toJson();
    }
    data['locationFilter'] = locationFilter;
    data['cityFilter'] = cityFilter;
    data['stateFilter'] = stateFilter;
    if (priceRange != null) {
      data['priceRange'] = priceRange!.toJson();
    }
    if (apartments != null) {
      data['apartments'] = apartments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class File {
  String? sessionId;
  String? fileName;
  int? totalRows;
  int? insertedCount;
  int? updatedCount;
  int? skippedCount;
  String? uploadedAt;

  File(
      {this.sessionId,
        this.fileName,
        this.totalRows,
        this.insertedCount,
        this.updatedCount,
        this.skippedCount,
        this.uploadedAt});

  File.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    fileName = json['fileName'];
    totalRows = json['totalRows'];
    insertedCount = json['insertedCount'];
    updatedCount = json['updatedCount'];
    skippedCount = json['skippedCount'];
    uploadedAt = json['uploadedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sessionId'] = sessionId;
    data['fileName'] = fileName;
    data['totalRows'] = totalRows;
    data['insertedCount'] = insertedCount;
    data['updatedCount'] = updatedCount;
    data['skippedCount'] = skippedCount;
    data['uploadedAt'] = uploadedAt;
    return data;
  }
}

class PriceRange {
  int? minTG;
  int? maxTG;
  int? minRent;
  int? maxRent;

  PriceRange({this.minTG, this.maxTG, this.minRent, this.maxRent});

  PriceRange.fromJson(Map<String, dynamic> json) {
    minTG = json['minTG'];
    maxTG = json['maxTG'];
    minRent = json['minRent'];
    maxRent = json['maxRent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['minTG'] = minTG;
    data['maxTG'] = maxTG;
    data['minRent'] = minRent;
    data['maxRent'] = maxRent;
    return data;
  }
}

class Apartments {
  String? sId;
  String? createdBySession;
  String? lastUpdatedBySession;
  String? skippedBySession;
  String? apartmentName;
  String? city;
  String? state;
  String? location;
  String? jioLocation;
  String? contactPersonName;
  String? contactPersonPhone;
  BankDetails? bankDetails;
  String? permissionStatus;
  String? rating;
  int? residencyCount;
  int? approxPeopleCount;
  int? fromTGValues;
  int? toTGValues;
  String? isActive;
  int? perDayRent;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? apartmentId;
  int? iV;
  String? sessionStatus;

  Apartments(
      {this.sId,
        this.createdBySession,
        this.lastUpdatedBySession,
        this.skippedBySession,
        this.apartmentName,
        this.city,
        this.state,
        this.location,
        this.jioLocation,
        this.contactPersonName,
        this.contactPersonPhone,
        this.bankDetails,
        this.permissionStatus,
        this.rating,
        this.residencyCount,
        this.approxPeopleCount,
        this.fromTGValues,
        this.toTGValues,
        this.isActive,
        this.perDayRent,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.apartmentId,
        this.iV,
        this.sessionStatus});

  Apartments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdBySession = json['createdBySession'];
    lastUpdatedBySession = json['lastUpdatedBySession'];
    skippedBySession = json['skippedBySession'];
    apartmentName = json['apartmentName'];
    city = json['city'];
    state = json['state'];
    location = json['location'];
    jioLocation = json['jioLocation'];
    contactPersonName = json['contactPersonName'];
    contactPersonPhone = json['contactPersonPhone'];
    bankDetails = json['bankDetails'] != null
        ?  BankDetails.fromJson(json['bankDetails'])
        : null;
    permissionStatus = json['permissionStatus'];
    rating = json['rating'];
    residencyCount = json['residencyCount'];
    approxPeopleCount = json['approxPeopleCount'];
    fromTGValues = json['fromTGValues'];
    toTGValues = json['toTGValues'];
    isActive = json['isActive'];
    perDayRent = json['perDayRent'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    apartmentId = json['apartmentId'];
    iV = json['__v'];
    sessionStatus = json['sessionStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['_id'] = sId;
    data['createdBySession'] = createdBySession;
    data['lastUpdatedBySession'] = lastUpdatedBySession;
    data['skippedBySession'] = skippedBySession;
    data['apartmentName'] = apartmentName;
    data['city'] = city;
    data['state'] = state;
    data['location'] = location;
    data['jioLocation'] = jioLocation;
    data['contactPersonName'] = contactPersonName;
    data['contactPersonPhone'] = contactPersonPhone;
    if (bankDetails != null) {
      data['bankDetails'] = bankDetails!.toJson();
    }
    data['permissionStatus'] = permissionStatus;
    data['rating'] = rating;
    data['residencyCount'] = residencyCount;
    data['approxPeopleCount'] = approxPeopleCount;
    data['fromTGValues'] = fromTGValues;
    data['toTGValues'] = toTGValues;
    data['isActive'] = isActive;
    data['perDayRent'] = perDayRent;
    data['updatedBy'] = updatedBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['apartmentId'] = apartmentId;
    data['__v'] = iV;
    data['sessionStatus'] = sessionStatus;
    return data;
  }
}

class BankDetails {
  String? accountHolderName;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? phoneNumber;
  String? upiId;

  BankDetails(
      {this.accountHolderName,
        this.bankName,
        this.accountNumber,
        this.ifscCode,
        this.phoneNumber,
        this.upiId});

  BankDetails.fromJson(Map<String, dynamic> json) {
    accountHolderName = json['accountHolderName'];
    bankName = json['bankName'];
    accountNumber = json['accountNumber'];
    ifscCode = json['ifscCode'];
    phoneNumber = json['phoneNumber'];
    upiId = json['upiId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountHolderName'] = accountHolderName;
    data['bankName'] = bankName;
    data['accountNumber'] = accountNumber;
    data['ifscCode'] = ifscCode;
    data['phoneNumber'] = phoneNumber;
    data['upiId'] = upiId;
    return data;
  }
}
