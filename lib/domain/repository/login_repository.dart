import '/data/Failure.dart';
import 'package:either_dart/either.dart';
import '/data/model/user_mapping_req_res.dart';

import '../entity/login_res_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResEntity>> checkUserLogin(String body);
  Future<Either<Failure, List<UsermappingResponse>?>> getUserMapping(
      String body);
  Future<Either<Failure, InsertUserResponse?>> insertUser(
      String body);
  Future<Either<Failure, ChangePassResult?>> changePasswordRep(String body);
}
