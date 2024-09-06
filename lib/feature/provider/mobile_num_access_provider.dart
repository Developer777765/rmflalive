import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/domain/entity/mobile_no_access_model.dart';
import 'package:mobile_number/mobile_number.dart';

final mobileNumberProvider =
    StateNotifierProvider<MobileNumerNotifier, MobileNumberAccess>(
        (ref) => MobileNumerNotifier());

class MobileNumerNotifier extends StateNotifier<MobileNumberAccess> {
  MobileNumerNotifier()
      : super(MobileNumberAccess(mobileNumber: "", simCard: []));

  void updateMobileNo(String value) {
    state = state.copyWith(mobileNumber: value.toString());
  }

  Future<void> listenForPermission() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }

    try {
      String mobileNumber1 = (await MobileNumber.mobileNumber)!;
      var simCard = (await MobileNumber.getSimCards)!;

      state = state.copyWith(
          mobileNumber: mobileNumber1.substring(mobileNumber1.length - 10),
          simCard: simCard);
      debugPrint("Mobile Number : " "${state.mobileNumber}");
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    if (!mounted) return;
  }
}
