import 'dart:convert';
import 'package:apartment_client_app/models/gst_verification_model.dart';
import 'package:apartment_client_app/models/otp_model.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../constants/constant.dart';
import '../models/apartment_field_list.dart';
import '../models/apartment_lists.dart';
import '../models/profile_model.dart';
import '../providers/brand_form_provider.dart';
import '../providers/campaign_provider.dart';
import 'package:path/path.dart' as path;

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.0.141:5000',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Map<String, dynamic>> loginPostAPI({required String phone}) async {
    try {
      final response = await _dio.post(
        '/user/login',
        data: {'userPhone': phone},
      );

      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Something went wrong';

      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<Map<String, dynamic>> registerPostAPI({
    required String name,
    required String phone,
    required int customerType,
    String? email,
  }) async {
    try {
      print('userName: $name');
      print('userPhone: $phone');
      print('customerType: $customerType');
      final response = await _dio.post(
        '/user/register',
        data: {
          'userName': name,
          'userPhone': phone,
          'customerType': customerType,
          if (email != null && email.isNotEmpty) 'userEmail': email,
        },
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Registration failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<ProfileModel> saveProfile(
    BrandFormState state,
    int profileCompleted,
  ) async {
    try {
      final id = StorageService.getId();
      final token = await StorageService.getToken();

      FormData formData = FormData.fromMap({
        'id': id,
        "brandOwnerName": state.ownerName,
        "companyBrandName": state.companyName,
        "email": state.email,
        "gstNumber": state.gst,
        "industryCategory": state.selectedIndustry,
        "productServiceDescription": state.productDescription,
        "targetCustomer": state.targetCustomer,
        "averageProductPrice": state.avgProductPrice,
        "campaignGoal": state.selectedCampaignGoal,
        "businessName": state.businessName,
        "businessAddress": state.businessAddress,
        "profileCompleted": profileCompleted,
      });

      if (state.logoImage != null) {
        formData.files.add(
          MapEntry(
            "logoDocument",
            await MultipartFile.fromFile(
              state.logoImage!.path,
              filename: path.basename(state.logoImage!.path),
            ),
          ),
        );
      }

      print('===== FORM DATA =====');
      for (final field in formData.fields) {
        print('${field.key}: ${field.value}');
      }

      final response = await _dio.post(
        "/user/profile-save",
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token",
          },
        ),
      );

      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('MESSAGE: ${e.message}');
      throw Exception(e.response?.data?['message'] ?? "Profile save failed");
    }
  }

  Future<ProfileModel> skipProfile() async {
    final token = await StorageService.getToken();
    print("token :$token");
    try {
      final token = await StorageService.getToken();
      final response = await _dio.post(
        options: Options(headers: {"Authorization": "Bearer $token"}),
        "/user/profile-save",
        data: {"profileCompleted": 0},
      );

      print(response.data);

      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      print(e.toString());
      throw Exception(e.response?.data?['message'] ?? "Profile save failed");
    }
  }

  Future<ProfileModel> getUserProfile(String userId) async {
    try {
      final token = await StorageService.getToken();
      final response = await _dio.get(
        '/user/profile',
        queryParameters: {'userId': userId},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.message ??
          'Failed to fetch profile';
      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<OTPVerify> verifyOtpPostAPI({
    required String phone,
    required String otp,
    required String api,
    int? customerType,
  }) async {
    print('otp: $otp');
    print('api: $api');
    print('userPhone: $phone');
    print('customerType: $customerType');
    try {
      final response = await _dio.post(
        api,
        data: {
          'userPhone': phone,
          'otp': otp,
          if (customerType != null && customerType.toString().isNotEmpty)
            'customerType': customerType,
        },
      );
      print(response.realUri);
      return OTPVerify.fromJson(response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.message ??
          'OTP verification failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<Map<String, dynamic>> resendOtpPostAPI({
    required String phone,
    required String api,
  }) async {
    try {
      final response = await _dio.post(api, data: {'userPhone': phone});
      print(response.realUri);

      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.message ??
          'OTP verification failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<GstVerification> gstVerify(String? gstNumber) async {
    try {
      final response = await _dio.post(
        '/gstdetails/verify',
        data: GstVerification(gstNumber: gstNumber).toJson(),
      );
      print(response.realUri);

      return GstVerification.fromJson(response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.message ??
          'GST verification failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<ApartmentFieldsList> getApartmentFieldList(String? id) async {
    try {
      final token = await StorageService.getToken();
      final response = await _dio.get(
        '/admin/apartmentEventGet',
        queryParameters: {'apartmentId': id},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return ApartmentFieldsList.fromJson(response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.message ??
          'Apartment Listing failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<ApartmentList> apartmentList({
    int pageNumber = 1,
    int count = 10,
    String? search,
    String? location,
    String? city,
    String? state,
    String? apartmentGroupName,
    double? minTG,
    double? maxTG,
    double? minRent,
    double? maxRent,
  }) async {
    try {
      final token = await StorageService.getToken();

      final payload = {
        'pageNumber': pageNumber,
        'count': count,
        if (search != null && search.isNotEmpty) 'search': search,
        if (location != null && location.isNotEmpty) 'Location': location,
        if (city != null && city.isNotEmpty) 'City': city,
        if (state != null && state.isNotEmpty) 'State': state,
        if (apartmentGroupName != null && apartmentGroupName.isNotEmpty)
          'ApartmentGroupName': apartmentGroupName,
        if (minTG != null) 'minTG': minTG.toInt(),
        if (maxTG != null) 'maxTG': maxTG.toInt(),
        if (minRent != null) 'minRent': minRent.toInt(),
        if (maxRent != null) 'maxRent': maxRent.toInt(),
      };

      print('====================');
      print('API REQUEST');
      print(payload);
      print('====================');

      final response = await _dio.post(
        '/admin/apartment-list',
        data: {
          'pageNumber': pageNumber,
          'count': count,
          if (search != null && search.isNotEmpty) 'search': search,
          if (location != null && location.isNotEmpty) 'Location': location,
          if (city != null && city.isNotEmpty) 'City': city,
          if (state != null && state.isNotEmpty) 'State': state,
          if (apartmentGroupName != null && apartmentGroupName.isNotEmpty)
            'ApartmentGroupName': apartmentGroupName,
          if (minTG != null) 'minTG': minTG.toInt(),
          if (maxTG != null) 'maxTG': maxTG.toInt(),
          if (minRent != null) 'minRent': minRent.toInt(),
          if (maxRent != null) 'maxRent': maxRent.toInt(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('====================');
      print('API SUCCESS');
      print(
        'Total Apartments: ${response.data['data']?['apartments']?.length}',
      );
      print('Response: ${response.data}');
      print('====================');

      return ApartmentList.fromJson(response.data);
    } on DioException catch (e) {
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('MESSAGE: ${e.message}');
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Apartment Lists failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<void> createCampaign(
    CampaignState state,
    ApartmentFieldsList fieldList,
  ) async {
    final token = await StorageService.getToken();

    // 1. Resolve eventId
    final eventObj = fieldList.data?.events?.firstWhere(
      (e) => e.eventName == state.campaignObjective,
      orElse: () => Events(),
    );
    final eventId = eventObj?.sId ?? '';

    // 2. Format dates
    final fromDateStr = state.selectedStart != null
        ? DateFormat('yyyy-MM-dd').format(state.selectedStart!)
        : '';
    final toDateStr = state.selectedEnd != null
        ? DateFormat('yyyy-MM-dd').format(state.selectedEnd!)
        : '';

    // 3. Resolve promoters
    int totalPromoterCount = 0;
    final List<Map<String, dynamic>> promotersList = [];
    if (state.needPromoters) {
      for (final req in state.promoterRequirements) {
        final maleCount = req.maleCount;
        final femaleCount = req.femaleCount;
        final days = req.selectedDates.length;
        totalPromoterCount += (maleCount + femaleCount);

        for (int i = 0; i < maleCount; i++) {
          promotersList.add({
            "promoterGender": "Male",
            "promoterPerDayCharge": 1500,
            "promoterLanguage": req.languages,
            "promoterLookAndAppearance": req.appearances,
            "promoterDays": days,
          });
        }
        for (int i = 0; i < femaleCount; i++) {
          promotersList.add({
            "promoterGender": "Female",
            "promoterPerDayCharge": 1500,
            "promoterLanguage": req.languages,
            "promoterLookAndAppearance": req.appearances,
            "promoterDays": days,
          });
        }
      }
    }

    // 4. Resolve customerDetails
    final Map<String, dynamic> customerDetailsMap = {
      "brandOrCompanyName": state.customerBrandName ?? '',
      "contactPersonName": state.customerContactName ?? '',
      "contactPersonPhoneNumber": state.customerPhone ?? '',
      "email": state.customerEmail ?? '',
      "customerType": int.tryParse(state.customerType ?? '1') ?? 1,
      "gstNumber": state.customerGst ?? '',
      "designation": state.customerDesignation ?? '',
    };
    if (state.customerNotes != null && state.customerNotes!.isNotEmpty) {
      customerDetailsMap["customerAdditionalNotes"] = state.customerNotes;
    }

    // 5. Resolve dailySchedule
    final List<Map<String, dynamic>> dateRanges = [];

    for (final schedule in state.schedules) {
      final List<Map<String, dynamic>> dailySchedule = [];

      int daysCount = 0;

      for (
      DateTime date = schedule.startDate;
      !date.isAfter(schedule.endDate);
      date = date.add(const Duration(days: 1))
      ) {
        daysCount++;

        dailySchedule.add({
          "date": DateFormat('yyyy-MM-dd').format(date),
          "fromTime": schedule.fromTime,
          "toTime": schedule.toTime,
          "notes": "Day $daysCount",
        });
      }

      dateRanges.add({
        "fromDate": DateFormat('yyyy-MM-dd').format(schedule.startDate),
        "toDate": DateFormat('yyyy-MM-dd').format(schedule.endDate),
        "daysOfEvent": daysCount,
        "dailySchedule": dailySchedule,
      });
    }

    // 6. Resolve sqfet index (1-indexed)
    int sqfetIndex = 1;
    final sqFeetList = fieldList.data?.apartment?.sqFeetAmount ?? [];
    for (int i = 0; i < sqFeetList.length; i++) {
      if (sqFeetList[i].size == state.builderSelectedSpace) {
        sqfetIndex = i + 1;
        break;
      }
    }

    // 7. Resolve items
    final List<Map<String, dynamic>> itemsList = [];
    final allElementDetails = fieldList.data?.elementsDetails ?? [];

    void addItemIfFound(String name, int quantity) {
      if (quantity <= 0) return;
      for (final category in allElementDetails) {
        final itemsDataList = category.itemsData;
        if (itemsDataList != null) {
          final found = itemsDataList.firstWhere(
            (item) => item.itemName == name,
            orElse: () => ItemsData(),
          );
          if (found.sId != null) {
            itemsList.add({"item_id": found.sId!, "quantity": quantity});
            return;
          }
        }
      }
    }

    state.categoryBrandingCounts.forEach(
      (name, count) => addItemIfFound(name, count),
    );
    state.unCategoryBrandingCounts.forEach(
      (name, count) => addItemIfFound(name, count),
    );
    state.stageCounts.forEach((name, count) => addItemIfFound(name, count));

    // 8. Resolve gifts
    final List<Map<String, dynamic>> giftsList = [];
    final normalGifts = fieldList.data?.giftsDetails?.normalGifts ?? [];
    final liveGifts = fieldList.data?.giftsDetails?.liveCounterGifts ?? [];

    state.giftCounts.forEach((name, count) {
      if (count <= 0) return;
      final found = normalGifts.firstWhere(
        (g) => g.giftName == name,
        orElse: () => NormalGifts(),
      );
      if (found.sId != null) {
        giftsList.add({"gift_id": found.sId, "quantity": count});
      }
    });

    state.experienceCounts.forEach((name, count) {
      if (count <= 0) return;
      final found = liveGifts.firstWhere(
        (g) => g.giftName == name,
        orElse: () => LiveCounterGifts(),
      );
      if (found.sId != null) {
        giftsList.add({"gift_id": found.sId, "quantity": count});
      }
    });

    // 9. Build main map/payload
    final Map<String, dynamic> payload = {
      "apartmentId": state.apartmentId,
      "eventId": eventId,
      "totalDaysOfEvent": state.days,
      "promoterRequired": state.needPromoters ? 1 : 0,
      "customerDetails": customerDetailsMap,
      "dateRanges": dateRanges,
      "discountType": state.discountType ?? 1,
      "discountPercentage": state.discountPercentage.round(),
      "sqfet": sqfetIndex,
      "stageRequired": state.stageSetup ? 1 : 0,
      "items": itemsList,
      "gifts": giftsList,
      "orderNoteText": state.notes,
    };

    if (state.needPromoters) {
      payload["promoterCount"] = totalPromoterCount;
      payload["promoters"] = promotersList;
    }

    try {
      dynamic requestData;
      if (state.voiceNotePath != null && state.voiceNotePath!.isNotEmpty) {
        // We use FormData for file upload
        final formDataMap = Map<String, dynamic>.from(payload);

        // Since FormData.fromMap does not automatically convert complex lists/maps to json strings in some server middlewares,
        // we encode nested structures.
        formDataMap["customerDetails"] = jsonEncode(customerDetailsMap);
        formDataMap["dateRanges"] = jsonEncode(dateRanges);
        formDataMap["items"] = jsonEncode(itemsList);
        formDataMap["gifts"] = jsonEncode(giftsList);
        if (state.needPromoters) {
          formDataMap["promoters"] = jsonEncode(promotersList);
        }

        final formData = FormData.fromMap(formDataMap);
        formData.files.add(
          MapEntry(
            "orderNoteFiles",
            await MultipartFile.fromFile(
              state.voiceNotePath!,
              filename: path.basename(state.voiceNotePath!),
            ),
          ),
        );
        requestData = formData;
      } else {
        requestData = payload;
      }

      print('===== CAMPAIGN SAVE PAYLOAD =====');
      print(jsonEncode(payload));
      print("Voice file path: ${state.voiceNotePath}");
      print('=================================');
      const encoder = JsonEncoder.withIndent('  ');
      print(encoder.convert(payload));

      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: false,
          error: true,
        ),
      );

      await _dio.post(
        '/admin/order-booking-save',
        data: requestData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            if (state.voiceNotePath != null) "Content-Type": "multipart/form-data",
          },
        ),
      );
    } on DioException catch (e) {
      print('CAMPAIGN SAVE ERROR STATUS: ${e.response?.statusCode}');
      print('CAMPAIGN SAVE ERROR DATA: ${e.response?.data}');
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to save campaign',
      );
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}
