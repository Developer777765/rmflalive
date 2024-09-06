import 'package:either_dart/either.dart';
import '/data/Failure.dart';
import '/domain/entity/branch_maping_entity.dart';

abstract class BranchMapingRep {
  Future<Either<Failure, BranchMapingResEntity>> getRepData(
      {required String body});
}
