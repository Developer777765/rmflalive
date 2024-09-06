import 'package:either_dart/either.dart';


import '../../data/Failure.dart';
import '../entity/daily_statuscheck_entity.dart';

abstract class DailyStatusCheckRepository {
  Future<Either<Failure, DailyStatusCheckResEntity>> getDailtStatusRep(
      String body);
}
