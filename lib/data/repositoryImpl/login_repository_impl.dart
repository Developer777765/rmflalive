import 'package:either_dart/src/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/Failure.dart';
import '/data/datasource/remote_data/login_data_source.dart';
import '/data/model/user_mapping_req_res.dart';
import '/domain/repository/login_repository.dart';
import '../../domain/entity/login_res_entity.dart';

var exception = "test";
final loginRepositoryProvider = Provider<LoginRepository>((ref) =>
    LoginRepositoryImpl(loginDataSource: ref.watch(loginDataSourceProvider)));
final exeptionprovider = StateProvider((ref) {
  return exception;
});

class LoginRepositoryImpl extends LoginRepository {
  final LoginDataSource loginDataSource;

  LoginRepositoryImpl({required this.loginDataSource});

  @override
  Future<Either<Failure, LoginResEntity>> checkUserLogin(String body) async {
    try {
      final result = await loginDataSource.checkLogin(body);
      exception = "exception success";
      return Right(result);
    } catch (e) {
      exception = e.toString();
      print("exception${exception}");
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UsermappingResponse>?>> getUserMapping(
      String body) async {
    try {
      final res = await loginDataSource.getUserMapping(body);
      return Right(res);
    } catch (ex) {
      return Left(Failure(message: ex.toString()));
    }
  }

  @override
  Future<Either<Failure, InsertUserResponse?>> insertUser(String body) async {
    try {
      final res = await loginDataSource.insertUser(body);
      return Right(res);
    } catch (ex) {
      return Left(Failure(message: ex.toString()));
    }
  }

  @override
  Future<Either<Failure, ChangePassResult?>> changePasswordRep(
      String body) async {
    try {
      final res = await loginDataSource.changePassword(body);
      return Right(res);
    } catch (ex) {
      return Left(Failure(message: ex.toString()));
    }
  }
}
