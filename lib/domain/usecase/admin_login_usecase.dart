import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/Failure.dart';
import '/data/repositoryImpl/branch_maping_rep_impl.dart';
import '/domain/entity/branch_maping_entity.dart';
import '/domain/repository/branch_maping_rep.dart';

final branchMapingUsecaseProvider = StateProvider<BranchMapingUseCase>((ref) {
  return BranchMapingUseCase(
      branchMapingRep: ref.watch(branchMapingRepProvider));
});

class BranchMapingUseCase {
  final BranchMapingRep branchMapingRep;
  
  BranchMapingUseCase({required this.branchMapingRep});

  Future<Either<Failure, BranchMapingResEntity>> getData(
      {required String body}) async {
    return await branchMapingRep.getRepData(body: body);
  }
}
