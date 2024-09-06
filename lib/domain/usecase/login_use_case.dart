import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/Failure.dart';
import '/data/model/user_mapping_req_res.dart';
import '/domain/repository/login_repository.dart';
import '../../data/repositoryImpl/login_repository_impl.dart';
import '../entity/login_res_entity.dart';

final loginUseCaseProvider =
    Provider((ref) => LoginUseCase(ref.watch(loginRepositoryProvider)));

class LoginUseCase {
  final LoginRepository loginRepository;

  LoginUseCase(this.loginRepository);

  Future<Either<Failure, LoginResEntity>> loginCheck(String body) async {
    return await loginRepository.checkUserLogin(body);
  }

  Future<Either<Failure, List<UsermappingResponse>?>> getUserMapping(
      String body) async {
    return await loginRepository.getUserMapping(body);
  }

  Future<Either<Failure, InsertUserResponse?>> insertUserUseCase(
      String body) async {
    return await loginRepository.insertUser(body);
  }

  Future<Either<Failure, ChangePassResult?>> changePasswordUseCase(
      String body) async {
    return await loginRepository.changePasswordRep(body);
  }
}
