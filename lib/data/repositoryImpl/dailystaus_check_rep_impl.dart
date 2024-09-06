import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:either_dart/src/either.dart';

import '../../domain/entity/daily_statuscheck_entity.dart';
import '../../domain/repository/dailystatus_check._rep.dart';
import '../Failure.dart';
import '../datasource/remote_data/daily_statust_check_datasourse.dart';

class DailyStatusCheckRepImpl extends DailyStatusCheckRepository {
  final DailyStatusCheckDatasourse dailyCheckdatasourse;
  DailyStatusCheckRepImpl({required this.dailyCheckdatasourse}); //constructor
  @override
  Future<Either<Failure, DailyStatusCheckResEntity>> getDailtStatusRep(
      String body) async {
    var result;
    try {
      await dailyCheckdatasourse.getDailyStatus(body).then((value) {
        result = value;
      });
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}

final dailyStatuscheckProviderimpl = Provider<DailyStatusCheckRepImpl>((ref) {
  return DailyStatusCheckRepImpl(
      dailyCheckdatasourse: ref.read(dailyStatusCheck));
});
