import 'package:apartment_client_app/models/apartment_lists.dart';
import 'package:apartment_client_app/utils/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final bottomNavigationIndex = StateProvider<int>((ref) => 0);

final apartmentListProvider = FutureProvider<ApartmentList>((ref) async {
  return ApiService().apartmentList();
});

final showSpacesBackButtonProvider = StateProvider<bool>((ref) => false);