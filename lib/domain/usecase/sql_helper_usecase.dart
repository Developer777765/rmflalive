
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/Failure.dart';
import '../../data/datasource/loacal_database/sql_helper_repco.dart';
import '../../data/repositoryImpl/sql_helper_repository_impl.dart';

final sqlHelperUseCaseProvider = StateProvider<SqlHelperUseCase>(
  (ref) => SqlHelperUseCase(sqlHelper: ref.watch(SqlHelperRepositoryProvider)),
);

class SqlHelperUseCase {
  final SQLHelperRepositoryImpl sqlHelper;

  SqlHelperUseCase({required this.sqlHelper});

  Future<Either<Failure, SQLHelper>> getSqlData() async {
    return await sqlHelper.getData();
  }
}