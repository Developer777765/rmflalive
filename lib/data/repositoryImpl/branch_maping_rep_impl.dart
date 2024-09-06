// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:either_dart/src/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/data/Failure.dart';
import '/data/datasource/remote_data/branch_maping_res_datasourse.dart';
import '/domain/entity/branch_maping_entity.dart';
import '/domain/repository/branch_maping_rep.dart';

final  branchMapingRepProvider = Provider<BranchMapingRep>((ref) {
  return BranchMapingRepImpl(
      branchMapingDataSource: ref.read(branchMapingDataSourseProvider));
});

class BranchMapingRepImpl extends BranchMapingRep {
  final BranchMapingDataSource branchMapingDataSource;
  BranchMapingRepImpl({
    required this.branchMapingDataSource,
  });
  @override
  Future<Either<Failure, BranchMapingResEntity>> getRepData(
      {required String body}) async {
    try {
      final result =
          await branchMapingDataSource.getData(body) ;
      debugPrint("Right : $result");
      return Right(result);
    } catch (e) {
      debugPrint("Left error : $e");
      return Left(Failure(message: e.toString()));
    }
  }
}



