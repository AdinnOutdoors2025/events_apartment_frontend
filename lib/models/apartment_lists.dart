class ApartmentList {
  final bool success;
  final String message;
  final ApartmentData? data;

  ApartmentList({required this.success, required this.message, this.data});

  factory ApartmentList.fromJson(Map<String, dynamic> json) {
    return ApartmentList(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ApartmentData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class ApartmentData {
  final int pageNumber;
  final int count;
  final int totalCount;
  final int totalPages;
  final FileDetails? file;
  final List<dynamic> locationFilter;
  final List<dynamic> cityFilter;
  final List<dynamic> stateFilter;
  final List<dynamic> apartmentGroupNameFilter;
  final PriceRange? priceRange;
  final List<Apartment> apartments;

  ApartmentData({
    required this.pageNumber,
    required this.count,
    required this.totalCount,
    required this.totalPages,
    this.file,
    required this.locationFilter,
    required this.cityFilter,
    required this.stateFilter,
    this.priceRange,
    required this.apartments,
    required this.apartmentGroupNameFilter,
  });

  factory ApartmentData.fromJson(Map<String, dynamic> json) {
    return ApartmentData(
      pageNumber: json['pageNumber'] ?? 0,
      count: json['count'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      file: json['file'] != null ? FileDetails.fromJson(json['file']) : null,
      locationFilter: json['locationFilter'] ?? [],
      cityFilter: json['cityFilter'] ?? [],
      stateFilter: json['stateFilter'] ?? [],
      priceRange: json['priceRange'] != null
          ? PriceRange.fromJson(json['priceRange'])
          : null,
      apartments: (json['apartments'] as List<dynamic>? ?? [])
          .map((e) => Apartment.fromJson(e))
          .toList(),
      apartmentGroupNameFilter: json['apartmentGroupNameFilter'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'count': count,
      'totalCount': totalCount,
      'totalPages': totalPages,
      'file': file?.toJson(),
      'locationFilter': locationFilter,
      'cityFilter': cityFilter,
      'stateFilter': stateFilter,
      'priceRange': priceRange?.toJson(),
      'apartments': apartments.map((e) => e.toJson()).toList(),
    };
  }
}

class FileDetails {
  final String sessionId;
  final String fileName;
  final int totalRows;
  final int insertedCount;
  final int updatedCount;
  final int skippedCount;
  final String uploadedAt;

  FileDetails({
    required this.sessionId,
    required this.fileName,
    required this.totalRows,
    required this.insertedCount,
    required this.updatedCount,
    required this.skippedCount,
    required this.uploadedAt,
  });

  factory FileDetails.fromJson(Map<String, dynamic> json) {
    return FileDetails(
      sessionId: json['sessionId'] ?? '',
      fileName: json['fileName'] ?? '',
      totalRows: json['totalRows'] ?? 0,
      insertedCount: json['insertedCount'] ?? 0,
      updatedCount: json['updatedCount'] ?? 0,
      skippedCount: json['skippedCount'] ?? 0,
      uploadedAt: json['uploadedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'fileName': fileName,
      'totalRows': totalRows,
      'insertedCount': insertedCount,
      'updatedCount': updatedCount,
      'skippedCount': skippedCount,
      'uploadedAt': uploadedAt,
    };
  }
}

class PriceRange {
  final int minTG;
  final int maxTG;
  final int minRent;
  final int maxRent;

  PriceRange({
    required this.minTG,
    required this.maxTG,
    required this.minRent,
    required this.maxRent,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      minTG: json['minTG'] ?? 0,
      maxTG: json['maxTG'] ?? 0,
      minRent: json['minRent'] ?? 0,
      maxRent: json['maxRent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minTG': minTG,
      'maxTG': maxTG,
      'minRent': minRent,
      'maxRent': maxRent,
    };
  }
}

class Apartment {
  final String id;
  final SessionInfo? createdBySession;
  final SessionInfo? lastUpdatedBySession;
  final dynamic skippedBySession;

  final String apartmentName;
  final String apartmentGroupName;
  final String city;
  final String state;
  final String location;
  final String geoLocation;
  final String contactPersonName;
  final String contactPersonPhone;

  final BankDetails? bankDetails;

  final String permissionStatus;
  final String rating;

  final int residencyCount;
  final int approxPeopleCount;
  final int fromTGValues;
  final int toTGValues;

  final String isActive;
  final int perDayRent;

  final String updatedBy;
  final String createdAt;
  final String updatedAt;

  final String apartmentId;
  final int v;
  final String sessionStatus;

  Apartment({
    required this.id,
    this.createdBySession,
    this.lastUpdatedBySession,
    this.skippedBySession,
    required this.apartmentName,
    required this.apartmentGroupName,
    required this.city,
    required this.state,
    required this.location,
    required this.geoLocation,
    required this.contactPersonName,
    required this.contactPersonPhone,
    this.bankDetails,
    required this.permissionStatus,
    required this.rating,
    required this.residencyCount,
    required this.approxPeopleCount,
    required this.fromTGValues,
    required this.toTGValues,
    required this.isActive,
    required this.perDayRent,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.apartmentId,
    required this.v,
    required this.sessionStatus,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['_id'] ?? '',
      createdBySession: json['createdBySession'] != null
          ? SessionInfo.fromJson(json['createdBySession'])
          : null,
      lastUpdatedBySession: json['lastUpdatedBySession'] != null
          ? SessionInfo.fromJson(json['lastUpdatedBySession'])
          : null,
      skippedBySession: json['skippedBySession'],

      apartmentName: json['ApartmentName'] ?? '',
      apartmentGroupName: json['ApartmentGroupName'] ?? '',
      city: json['City'] ?? '',
      state: json['State'] ?? '',
      location: json['Location'] ?? '',
      geoLocation: json['GeoLocation'] ?? '',
      contactPersonName: json['ContactPersonName'] ?? '',
      contactPersonPhone: json['ContactPersonPhone'] ?? '',

      bankDetails: json['bankDetails'] != null
          ? BankDetails.fromJson(json['bankDetails'])
          : null,

      permissionStatus: json['PermissionStatus'] ?? '',
      rating: json['Rating'] ?? '',

      residencyCount: json['ResidencyCount'] ?? 0,
      approxPeopleCount: json['ApproxPeopleCount'] ?? 0,
      fromTGValues: json['FromTGValues'] ?? 0,
      toTGValues: json['ToTGValues'] ?? 0,

      isActive: json['isActive'] ?? '',
      perDayRent: json['PerDayRent'] ?? 0,

      updatedBy: json['updatedBy'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',

      apartmentId: json['apartmentId'] ?? '',
      v: json['__v'] ?? 0,
      sessionStatus: json['sessionStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'createdBySession': createdBySession?.toJson(),
      'lastUpdatedBySession': lastUpdatedBySession?.toJson(),
      'skippedBySession': skippedBySession,
      'ApartmentName': apartmentName,
      'ApartmentGroupName': apartmentGroupName,
      'City': city,
      'State': state,
      'Location': location,
      'GeoLocation': geoLocation,
      'ContactPersonName': contactPersonName,
      'ContactPersonPhone': contactPersonPhone,
      'bankDetails': bankDetails?.toJson(),
      'PermissionStatus': permissionStatus,
      'Rating': rating,
      'ResidencyCount': residencyCount,
      'ApproxPeopleCount': approxPeopleCount,
      'FromTGValues': fromTGValues,
      'ToTGValues': toTGValues,
      'isActive': isActive,
      'PerDayRent': perDayRent,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'apartmentId': apartmentId,
      '__v': v,
      'sessionStatus': sessionStatus,
    };
  }
}

class SessionInfo {
  final String id;
  final String fileName;
  final String createdAt;

  SessionInfo({
    required this.id,
    required this.fileName,
    required this.createdAt,
  });

  factory SessionInfo.fromJson(Map<String, dynamic> json) {
    return SessionInfo(
      id: json['_id'] ?? '',
      fileName: json['fileName'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'fileName': fileName, 'createdAt': createdAt};
  }
}

class BankDetails {
  final String accountHolderName;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String phoneNumber;
  final String upiID;

  BankDetails({
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.phoneNumber,
    required this.upiID,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      accountHolderName: json['AccountHolderName'] ?? '',
      bankName: json['BankName'] ?? '',
      accountNumber: json['AccountNumber'] ?? '',
      ifscCode: json['IfscCode'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      upiID: json['UpiID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AccountHolderName': accountHolderName,
      'BankName': bankName,
      'AccountNumber': accountNumber,
      'IfscCode': ifscCode,
      'PhoneNumber': phoneNumber,
      'UpiID': upiID,
    };
  }
}
