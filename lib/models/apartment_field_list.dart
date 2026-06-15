class ApartmentFieldsList {
  bool? success;
  String? message;
  Data? data;

  ApartmentFieldsList({this.success, this.message, this.data});

  ApartmentFieldsList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Apartments? apartment;
  List<Events>? events;
  List<ElementsDetails>? elementsDetails;
  GiftsDetails? giftsDetails;

  Data({this.apartment, this.events, this.elementsDetails, this.giftsDetails});

  Data.fromJson(Map<String, dynamic> json) {
    apartment = json['apartment'] != null
        ?  Apartments.fromJson(json['apartment'])
        : null;
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add( Events.fromJson(v));
      });
    }
    if (json['elementsDetails'] != null) {
      elementsDetails = <ElementsDetails>[];
      json['elementsDetails'].forEach((v) {
        elementsDetails!.add( ElementsDetails.fromJson(v));
      });
    }
    giftsDetails = json['giftsDetails'] != null
        ?  GiftsDetails.fromJson(json['giftsDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (apartment != null) {
      data['apartment'] = apartment!.toJson();
    }
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    if (elementsDetails != null) {
      data['elementsDetails'] =
          elementsDetails!.map((v) => v.toJson()).toList();
    }
    if (giftsDetails != null) {
      data['giftsDetails'] = giftsDetails!.toJson();
    }
    return data;
  }
}

class Apartments {
  BankDetails? bankDetails;
  String? sId;
  String? createdBySession;
  String? lastUpdatedBySession;
  String? skippedBySession;
  String? apartmentName;
  String? apartmentGroupName;
  String? city;
  String? state;
  String? location;
  String? geoLocation;
  String? contactPersonName;
  String? contactPersonPhone;
  String? permissionStatus;
  String? rating;
  int? residencyCount;
  int? approxPeopleCount;
  int? fromTGValues;
  int? toTGValues;
  bool? isActive;
  int? perDayRent;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? apartmentId;
  int? iV;
  List<SqFeetAmount>? sqFeetAmount;

  Apartments(
      {this.bankDetails,
        this.sId,
        this.createdBySession,
        this.lastUpdatedBySession,
        this.skippedBySession,
        this.apartmentName,
        this.apartmentGroupName,
        this.city,
        this.state,
        this.location,
        this.geoLocation,
        this.contactPersonName,
        this.contactPersonPhone,
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
        this.sqFeetAmount});

  Apartments.fromJson(Map<String, dynamic> json) {
    bankDetails = json['bankDetails'] != null
        ?  BankDetails.fromJson(json['bankDetails'])
        : null;
    sId = json['_id'];
    createdBySession = json['createdBySession'];
    lastUpdatedBySession = json['lastUpdatedBySession'];
    skippedBySession = json['skippedBySession'];
    apartmentName = json['ApartmentName'];
    apartmentGroupName = json['ApartmentGroupName'];
    city = json['City'];
    state = json['State'];
    location = json['Location'];
    geoLocation = json['GeoLocation'];
    contactPersonName = json['ContactPersonName'];
    contactPersonPhone = json['ContactPersonPhone'];
    permissionStatus = json['PermissionStatus'];
    rating = json['Rating'];
    residencyCount = json['ResidencyCount'];
    approxPeopleCount = json['ApproxPeopleCount'];
    fromTGValues = json['FromTGValues'];
    toTGValues = json['ToTGValues'];
    isActive = json['isActive'];
    perDayRent = json['PerDayRent'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    apartmentId = json['apartmentId'];
    iV = json['__v'];
    if (json['sqFeetAmount'] != null) {
      sqFeetAmount = <SqFeetAmount>[];
      json['sqFeetAmount'].forEach((v) {
        sqFeetAmount!.add( SqFeetAmount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (bankDetails != null) {
      data['bankDetails'] = bankDetails!.toJson();
    }
    data['_id'] = sId;
    data['createdBySession'] = createdBySession;
    data['lastUpdatedBySession'] = lastUpdatedBySession;
    data['skippedBySession'] = skippedBySession;
    data['ApartmentName'] = apartmentName;
    data['ApartmentGroupName'] = apartmentGroupName;
    data['City'] = city;
    data['State'] = state;
    data['Location'] = location;
    data['GeoLocation'] = geoLocation;
    data['ContactPersonName'] = contactPersonName;
    data['ContactPersonPhone'] = contactPersonPhone;
    data['PermissionStatus'] = permissionStatus;
    data['Rating'] = rating;
    data['ResidencyCount'] = residencyCount;
    data['ApproxPeopleCount'] = approxPeopleCount;
    data['FromTGValues'] = fromTGValues;
    data['ToTGValues'] = toTGValues;
    data['isActive'] = isActive;
    data['PerDayRent'] = perDayRent;
    data['updatedBy'] = updatedBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['apartmentId'] = apartmentId;
    data['__v'] = iV;
    if (sqFeetAmount != null) {
      data['sqFeetAmount'] = sqFeetAmount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BankDetails {
  String? accountHolderName;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? phoneNumber;
  String? upiID;

  BankDetails(
      {this.accountHolderName,
        this.bankName,
        this.accountNumber,
        this.ifscCode,
        this.phoneNumber,
        this.upiID});

  BankDetails.fromJson(Map<String, dynamic> json) {
    accountHolderName = json['AccountHolderName'];
    bankName = json['BankName'];
    accountNumber = json['AccountNumber'];
    ifscCode = json['IfscCode'];
    phoneNumber = json['PhoneNumber'];
    upiID = json['UpiID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['AccountHolderName'] = accountHolderName;
    data['BankName'] = bankName;
    data['AccountNumber'] = accountNumber;
    data['IfscCode'] = ifscCode;
    data['PhoneNumber'] = phoneNumber;
    data['UpiID'] = upiID;
    return data;
  }
}

class SqFeetAmount {
  String? size;
  int? charge;

  SqFeetAmount({this.size, this.charge});

  SqFeetAmount.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    charge = json['charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['size'] = size;
    data['charge'] = charge;
    return data;
  }
}

class Events {
  String? sId;
  String? eventName;
  int? amount;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Events(
      {this.sId,
        this.eventName,
        this.amount,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Events.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    eventName = json['eventName'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['_id'] = sId;
    data['eventName'] = eventName;
    data['amount'] = amount;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ElementsDetails {
  String? categoryName;
  List<ItemsData>? itemsData;

  ElementsDetails({this.categoryName, this.itemsData});

  ElementsDetails.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    if (json['itemsData'] != null) {
      itemsData = <ItemsData>[];
      json['itemsData'].forEach((v) {
        itemsData!.add( ItemsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['category_name'] = categoryName;
    if (itemsData != null) {
      data['itemsData'] = itemsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemsData {
  String? sId;
  String? state;
  String? itemName;
  int? itemType;
  int? amount;
  int? amountUnit;
  int? quantity;
  int? itemStatus;
  String? itemNotes;
  String? createdAt;
  String? updatedAt;

  ItemsData(
      {this.sId,
        this.state,
        this.itemName,
        this.itemType,
        this.amount,
        this.amountUnit,
        this.quantity,
        this.itemStatus,
        this.itemNotes,
        this.createdAt,
        this.updatedAt});

  ItemsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    state = json['state'];
    itemName = json['item_name'];
    itemType = json['item_type'];
    amount = json['amount'];
    amountUnit = json['amount_unit'];
    quantity = json['quantity'];
    itemStatus = json['item_status'];
    itemNotes = json['item_notes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['_id'] = sId;
    data['state'] = state;
    data['item_name'] = itemName;
    data['item_type'] = itemType;
    data['amount'] = amount;
    data['amount_unit'] = amountUnit;
    data['quantity'] = quantity;
    data['item_status'] = itemStatus;
    data['item_notes'] = itemNotes;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class GiftsDetails {
  List<NormalGifts>? normalGifts;
  List<LiveCounterGifts>? liveCounterGifts;

  GiftsDetails({this.normalGifts, this.liveCounterGifts});

  GiftsDetails.fromJson(Map<String, dynamic> json) {
    if (json['normalGifts'] != null) {
      normalGifts = <NormalGifts>[];
      json['normalGifts'].forEach((v) {
        normalGifts!.add( NormalGifts.fromJson(v));
      });
    }
    if (json['liveCounterGifts'] != null) {
      liveCounterGifts = <LiveCounterGifts>[];
      json['liveCounterGifts'].forEach((v) {
        liveCounterGifts!.add( LiveCounterGifts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (normalGifts != null) {
      data['normalGifts'] = normalGifts!.map((v) => v.toJson()).toList();
    }
    if (liveCounterGifts != null) {
      data['liveCounterGifts'] =
          liveCounterGifts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NormalGifts {
  String? sId;
  String? state;
  int? giftType;
  String? giftName;
  int? priceType;
  int? price;
  int? unit;
  String? notes;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  NormalGifts(
      {this.sId,
        this.state,
        this.giftType,
        this.giftName,
        this.priceType,
        this.price,
        this.unit,
        this.notes,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  NormalGifts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    state = json['state'];
    giftType = json['giftType'];
    giftName = json['giftName'];
    priceType = json['priceType'];
    price = json['price'];
    unit = json['unit'];
    notes = json['notes'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['_id'] = sId;
    data['state'] = state;
    data['giftType'] = giftType;
    data['giftName'] = giftName;
    data['priceType'] = priceType;
    data['price'] = price;
    data['unit'] = unit;
    data['notes'] = notes;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class LiveCounterGifts {
  String? sId;
  int? giftType;
  String? giftName;
  int? priceType;
  int? price;
  String? unit;
  String? notes;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  LiveCounterGifts(
      {this.sId,
        this.giftType,
        this.giftName,
        this.priceType,
        this.price,
        this.unit,
        this.notes,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  LiveCounterGifts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    giftType = json['giftType'];
    giftName = json['giftName'];
    priceType = json['priceType'];
    price = json['price'];
    unit = json['unit'];
    notes = json['notes'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['_id'] = sId;
    data['giftType'] = giftType;
    data['giftName'] = giftName;
    data['priceType'] = priceType;
    data['price'] = price;
    data['unit'] = unit;
    data['notes'] = notes;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
