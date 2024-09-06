import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/crypto_utils.dart';
import '/core/string_manger.dart';
import '/data/model/user_mapping_req_res.dart';
import '/domain/entity/user_mapping_entity.dart';
import '/domain/usecase/login_use_case.dart';
import '../../data/Failure.dart';
import '../../domain/entity/login_entity.dart';
import '../../domain/entity/login_res_entity.dart';
import '../page/login/admin_login_screen.dart';
import '../page/splash/splash_screen.dart';

final userIdProvider = StateProvider<String>((ref) {
  return '';
});
final brIdProvider = StateProvider<String>((ref) {
  return '';
});

final loginProvider = StateNotifierProvider<LoginNotifier, LoginResEntity>(
    (ref) => LoginNotifier(ref.watch(loginUseCaseProvider)));
var pasword;

class LoginNotifier extends StateNotifier<LoginResEntity> {
  final LoginUseCase loginUseCase;

  late Either<Failure, LoginResEntity> result;
  LoginNotifier(this.loginUseCase)
      : super(LoginResEntity(result: null, status: null));

  Future<void> checkLoginUser(
      {required String username,
      required WidgetRef ref,
      required String uniqueID,
      required String pass,
      required String mobilenum,
      required bool isAdmin}) async {
    String body = loginEntityToJson(LoginEntity(
        loginType: isAdmin ? "MappingUser" : "LoginUser",
        platfrom: AppString.Mobile,
        loginId: CryptoUtils.encrypt(username),
        password: CryptoUtils.encrypt(pass),
        mobileNo: CryptoUtils.encrypt(mobilenum),
        branchId: null,
        userRole: isAdmin ? "Mobile Admin" : "Mobile User",
        uniqueId: CryptoUtils.encrypt(
          ref.read(androidUniqueIdProvider),
        ),
        isValidOn: !isAdmin));
    pasword = CryptoUtils.encrypt(pass);

    debugPrint("Mobile No on login Request  : $mobilenum");
    ref
        .watch(tokenProvider.notifier)
        .update((state) => CryptoUtils.encrypt(pass));

    result = await loginUseCase.loginCheck(body);
  }

  Future<Either<Failure, List<UsermappingResponse>?>> getUserMappingUseCase(
      {required String brId, required String password, required String pkId}) {
    Future<Either<Failure, List<UsermappingResponse>?>>? resultData;
    String body = userMappingReqToJson(
        UserMappingReqEntiry(brId: brId, password: password, pkId: pkId));
    resultData = loginUseCase.getUserMapping(body);
    return resultData;
  }

  Future<Either<Failure, InsertUserResponse?>> insertUserProvider(
      List<UserInsertReq> UserList) {
    Future<Either<Failure, InsertUserResponse?>>? resultData;
    String body = userInsertReqToJson(UserList);
    resultData = loginUseCase.insertUserUseCase(body);
    return resultData;
  }

  Future<Either<Failure, ChangePassResult?>> changePasswordProvider(
      ChangePasswordReq changePassModel) {
    Future<Either<Failure, ChangePassResult?>>? resultData;
    String body = changePasswordReqToJson(changePassModel);
    resultData = loginUseCase.changePasswordUseCase(body);
    return resultData;
  }
}
