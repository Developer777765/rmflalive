import 'package:either_dart/either.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repository/sql_helper_repository.dart';
import '../Failure.dart';
import '../datasource/loacal_database/sql_helper_repco.dart';

final SqlHelperRepositoryProvider =
    StateProvider<SQLHelperRepositoryImpl>((ref) {
  return SQLHelperRepositoryImpl(sqlHelper: ref.watch(sqlHelperProvider));
});

class SQLHelperRepositoryImpl extends SQLHelperRepository {
  final SQLHelper sqlHelper;
  SQLHelperRepositoryImpl({
    required this.sqlHelper,
  });
  @override
  Future<Either<Failure, SQLHelper>> getData() async {
    try {
      final result = await sqlHelper;
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}