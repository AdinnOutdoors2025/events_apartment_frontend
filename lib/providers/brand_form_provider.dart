import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/constant.dart';
import '../utils/api_service.dart';

const _unset = Object();

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
  final String productDescription;
  final String targetCustomer;
  final int avgProductPrice;
  final String selectedIndustry;
  final String selectedCampaignGoal;


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
    this.logoImage,
    this.productDescription = '',
    this.targetCustomer = '',
    this.avgProductPrice = 0,
    this.selectedIndustry = '',
    this.selectedCampaignGoal = '',
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
    Object? logoImage = _unset,
    String? productDescription,
    String? targetCustomer,
    int? avgProductPrice,
    String? selectedIndustry,
    String? selectedCampaignGoal,
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
      logoImage: logoImage == _unset
          ? this.logoImage
          : logoImage as File?,
      productDescription: productDescription ?? this.productDescription,
      targetCustomer: targetCustomer ?? this.targetCustomer,
      avgProductPrice: avgProductPrice ?? this.avgProductPrice,
      selectedIndustry: selectedIndustry ?? this.selectedIndustry,
      selectedCampaignGoal: selectedCampaignGoal ?? this.selectedCampaignGoal,
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

  bool get canSubmit {

    final industryValid = selectedIndustry.trim().isNotEmpty;
    final productValid = productDescription.trim().isNotEmpty;
    final targetValid = targetCustomer.trim().isNotEmpty;
    final campaignValid = selectedCampaignGoal.trim().isNotEmpty;
    final priceValid = avgProductPrice > 0;
    final logoValid = logoImage != null;

    return
        industryValid &&
        productValid &&
        targetValid &&
        campaignValid &&
        priceValid &&
        logoValid;
  }
}

class BrandFormNotifier extends StateNotifier<BrandFormState> {
  BrandFormNotifier() : super(const BrandFormState());
  final ApiService apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  void updateOwnerName(String value) {
    state = state.copyWith(ownerName: value);
  }

  void updateProductDescription(String value) {
    state = state.copyWith(productDescription: value);
  }

  void setIndustry(String role) {
    state = state.copyWith(selectedIndustry: role);
  }

  void setCampaignRole(String role) {
    state = state.copyWith(selectedCampaignGoal: role);
  }

  void updateTargetCustomer(String value) {
    state = state.copyWith(targetCustomer: value);
  }

  void updateAvgProductPrice(int value) {
    state = state.copyWith(avgProductPrice: value);
  }

  void removeLogo() {
    print('remove');
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

  Future<bool> saveProfile() async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await apiService.saveProfile(state,2);

      if (response.success == true) {
        AppToast.showSuccess(response.message ?? "Profile saved");
        return true;
      } else {
        AppToast.showError(response.message ?? "Failed");
        return false;
      }
    } catch (e) {
      AppToast.showError(e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
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
      state = state.copyWith(logoImage: File(image.path));
    }
  }
}

final brandFormProvider =
    StateNotifierProvider<BrandFormNotifier, BrandFormState>(
      (ref) => BrandFormNotifier(),
    );
