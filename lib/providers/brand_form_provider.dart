import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class BrandFormState {
  final String ownerName;
  final String companyName;
  final String email;
  final String gst;

  const BrandFormState({
    this.ownerName = '',
    this.companyName = '',
    this.email = '',
    this.gst = '',
  });

  BrandFormState copyWith({
    String? ownerName,
    String? companyName,
    String? email,
    String? gst,
  }) {
    return BrandFormState(
      ownerName: ownerName ?? this.ownerName,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      gst: gst ?? this.gst,
    );
  }

  bool get isValid =>
      ownerName.isNotEmpty &&
          companyName.isNotEmpty &&
          email.isNotEmpty;
}

class BrandFormNotifier extends StateNotifier<BrandFormState> {
  BrandFormNotifier() : super(const BrandFormState());

  void updateOwnerName(String value) {
    state = state.copyWith(ownerName: value);
  }

  void updateCompanyName(String value) {
    state = state.copyWith(companyName: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updateGst(String value) {
    state = state.copyWith(gst: value);
  }
}

final brandFormProvider =
StateNotifierProvider<BrandFormNotifier, BrandFormState>(
      (ref) => BrandFormNotifier(),
);