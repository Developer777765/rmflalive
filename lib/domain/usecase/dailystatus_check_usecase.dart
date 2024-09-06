import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:either_dart/src/either.dart';

import '../../data/Failure.dart';
import '../../data/repositoryImpl/dailystaus_check_rep_impl.dart';
import '../entity/daily_statuscheck_entity.dart';
import '../repository/dailystatus_check._rep.dart';

class DailyStatusUseCase {
  final DailyStatusCheckRepository dailyStatusCheckRepository;

  DailyStatusUseCase({required this.dailyStatusCheckRepository});
  Future<Either<Failure, DailyStatusCheckResEntity>> getDailtStatusRep(
      String body) async {
    return await dailyStatusCheckRepository.getDailtStatusRep(body);
  }
}

final DailystatustUseCaseProvider = StateProvider<DailyStatusUseCase>((ref) {
  return DailyStatusUseCase(
      dailyStatusCheckRepository: ref.read(dailyStatuscheckProviderimpl));
});
