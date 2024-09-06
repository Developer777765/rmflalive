import 'package:either_dart/either.dart';

import '../../data/Failure.dart';
import '../../data/datasource/loacal_database/sql_helper_repco.dart';

abstract class SQLHelperRepository {
  Future<Either<Failure, SQLHelper>> getData();
}