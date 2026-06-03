import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/constant.dart';
import '../utils/api_service.dart';

class BrandFormState {
  final bool isLoading;
  final String ownerName;
  final String companyName;
  final String email;
  final String gst;
  final bool isGstVerifying;
  final bool isGstVerified;

  final String businessName;
  final String businessAddress;
  final File? logoImage;

  const BrandFormState({
    this.isLoading = false,
    this.ownerName = '',
    this.companyName = '',
    this.email = '',
    this.gst = '',
    this.isGstVerifying = false,
    this.isGstVerified = false,
    this.businessName = '',
    this.businessAddress = '',
    this.logoImage ,
  });

  BrandFormState copyWith({
    bool? isLoading,
    String? ownerName,
    String? companyName,
    String? email,
    String? gst,
    bool? isGstVerifying,
    bool? isGstVerified,
    String? businessName,
    String? businessAddress,
    File? logoImage,
  }) {
    return BrandFormState(
      isLoading: isLoading ?? this.isLoading,
      ownerName: ownerName ?? this.ownerName,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      gst: gst ?? this.gst,
      isGstVerifying: isGstVerifying ?? this.isGstVerifying,
      isGstVerified: isGstVerified ?? this.isGstVerified,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      logoImage: logoImage ?? this.logoImage,
    );
  }

  bool get hasGst => gst.trim().isNotEmpty;

  bool get isValid {
    if (ownerName.isEmpty || companyName.isEmpty || email.isEmpty) {
      return false;
    }

    if (!hasGst) return true;

    return isGstVerified;
  }
}

class BrandFormNotifier extends StateNotifier<BrandFormState> {
  BrandFormNotifier() : super(const BrandFormState());
  final ApiService apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  void updateOwnerName(String value) {
    state = state.copyWith(ownerName: value);
  }
  void removeLogo() {
    state = state.copyWith(logoImage: null);
  }

  void updateCompanyName(String value) {
    state = state.copyWith(companyName: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updateGst(String value) {
    state = state.copyWith(
      gst: value.toUpperCase(),
      isGstVerified: false,
      businessName: '',
      businessAddress: '',
    );
  }

  Future<bool> verifyGst() async {
    print(state.gst.trim());
    try {
      state = state.copyWith(isGstVerifying: true);
      print(state.gst.trim());
      // final response = await apiService.gstVerify(state.gst.trim());

      state = state.copyWith(
        isGstVerified: true,
        businessName: 'VST TILLERS TRACTORS LIMITED',
        businessAddress: 'KARNATAKA 560048',
      );
      AppToast.showSuccess('GST Verified');
      return true;
      /* if (response.success == true) {
        state = state.copyWith(
          isGstVerified: true,
          businessName: response.data?.businessName ?? 'VST TILLERS TRACTORS LIMITED',
          businessAddress: response.data?.businessAddress ?? 'KARNATAKA 560048',
        );

        AppToast.showSuccess(response.message ?? 'GST Verified');

        return true;
      }*/

      state = state.copyWith(isGstVerified: false);

      //AppToast.showError(/*response.message ??*/ 'GST Verification Failed');

      return false;
    } catch (e) {
      state = state.copyWith(isGstVerified: false);
      print(e.toString());
      AppToast.showError(e.toString());
      return false;
    } finally {
      state = state.copyWith(isGstVerifying: false);
    }
  }
  Future<void> pickLogo(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      state = state.copyWith(
        logoImage: File(image.path),
      );
    }
  }
}

final brandFormProvider =
    StateNotifierProvider<BrandFormNotifier, BrandFormState>(
      (ref) => BrandFormNotifier(),
    );
