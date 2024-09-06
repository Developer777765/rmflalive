import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/datasource/loacal_database/sql_helper_repco.dart';
import '/data/model/remitted_screen_model.dart';
import '../../../domain/entity/loan_collection_res_entity.dart';
import 'package:sqflite/sqflite.dart' as sql;

abstract class MoneyCollectionDataSource {
  Future<void> insertDataToDb(List<ResultEntity> data);
  Future<int> updateStatusInDb({required List<Remittedldb> repcoData});
  Future<List<ResultEntity>> getGroupNamesWithSimilarMemberNames(
      String searchTerm);
  Future<List<Remittedldb>> getCollectedStatusList();
  Future<List<ResultEntity>> readDataFromDbByGroupCode(
      {required String groupCode});
  Future<List<ResultEntity>> getUniqueGroupNameAndCode();
  Future<List<ResultEntity>> getAllDataFromDb();
  Future<List<Remittedldb>> getUnsyncedData(int boolinInt);
  Future<void> deleteTable();
}

final moneyCollectionDataSourceProvider =
    StateProvider<MoneyCollectionDataSource>(
        (ref) => MoneyCollectionDataSourceImpl());

class MoneyCollectionDataSourceImpl extends MoneyCollectionDataSource {
  // @override
  // Future<void> insertDataToDb(List<ResultEntity> data) async {
  //   final db = await SQLHelper.db();
  //   data.forEach((element) async {
  //     await db.insert("tLOANLIST", element.toJson(),
  //         conflictAlgorithm: sql.ConflictAlgorithm.replace);
  //   });

  //   debugPrint("inserted");
  // }
  @override
  Future<void> insertDataToDb(List<ResultEntity> data) async {
    final db = await SQLHelper.db();
    final batch = db.batch();

    for (final element in data) {
      batch.insert(
        "tLOANLIST",
        element.toJson(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
    debugPrint("inserted");
  }

  @override
  Future<void> deleteTable() async {
    final db = await SQLHelper.db();
    await db.execute('DROP TABLE IF EXISTS tLOANLIST');
    debugPrint('Table deleted');
  }

// 13sep
  @override
  Future<List<ResultEntity>> getUniqueGroupNameAndCode() async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT DISTINCT groupName, groupCode FROM tLOANLIST');

    return List.generate(maps.length, (index) {
      return ResultEntity(
        groupCode: maps[index]['groupCode'],
        groupName: maps[index]['groupName'],
        // lonaNo: maps[index]['lonaNo'],
        // memberName: maps[index]['memberName'],
      );
    });
  }

  @override
  Future<List<ResultEntity>> readDataFromDbByGroupCode(
      {required String groupCode}) async {
    final db = await SQLHelper.db();

    final List<Map<String, dynamic>> maps = await db
        .query('tLOANLIST', where: 'groupCode = ?', whereArgs: [groupCode]);

    return List.generate(maps.length, (i) {
      return ResultEntity(
        groupCode: maps[i]['groupCode'],
        groupName: maps[i]['groupName'],
        lonaNo: maps[i]['lonaNo'],
        memberName: maps[i]['memberName'],
        loanAmt: maps[i]['loanAmt'],
        loanOs: maps[i]['loanOS'],
        loanOverdue: maps[i]['loanOverdue'],
        emiAmt: maps[i]['emiAmt'],
        brId: maps[i]['brID'],
        prdId: maps[i]['prdId'],
        openingDt: maps[i]['openingDt'],
        businessDate: maps[i]['businessDate'],
      );
    });
  }

  @override
  Future<List<ResultEntity>> getGroupNamesWithSimilarMemberNames(
      String searchTerm) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT DISTINCT groupName, groupCode 
    FROM tLOANLIST
    WHERE memberName LIKE '%' || ? || '%'
  ''', [searchTerm]);
    return List.generate(result.length, (index) {
      return ResultEntity(
        groupCode: result[index]['groupCode'],
        groupName: result[index]['groupName'],
      );
    });
  }

  // @override
  Future<List<ResultEntity>> getGroupNamesWithSimilarGroupNames(
      String searchTerm) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT DISTINCT groupName, groupCode 
    FROM tLOANLIST
    WHERE groupName LIKE '%' || ? || '%'
  ''', [searchTerm]);
    return List.generate(result.length, (index) {
      return ResultEntity(
        groupCode: result[index]['groupCode'],
        groupName: result[index]['groupName'],
      );
    });
  }

  // @override
  Future<List<ResultEntity>> getGroupNamesWithSimilarLoanNos(
      String loanNo) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT DISTINCT groupName, groupCode 
    FROM tLOANLIST
    WHERE lonaNo LIKE ?
  ''', ['%$loanNo%']);
    return List.generate(result.length, (index) {
      return ResultEntity(
        groupCode: result[index]['groupCode'],
        groupName: result[index]['groupName'],
      );
    });
  }

  @override
  Future<List<ResultEntity>> getAllDataFromDb() async {
    final db = await SQLHelper.db();

    final List<Map<String, dynamic>> maps = await db.query('tLOANLIST');

    return List.generate(maps.length, (i) {
      return ResultEntity(
        groupCode: maps[i]['groupCode'],
        groupName: maps[i]['groupName'],
        lonaNo: maps[i]['lonaNo'],
        memberName: maps[i]['memberName'],
        loanAmt: maps[i]['loanAmt'],
        loanOs: maps[i]['loanOS'],
        loanOverdue: maps[i]['loanOverdue'],
        emiAmt: maps[i]['emiAmt'],
        brId: maps[i]['brID'],
        prdId: maps[i]['prdId'],
        openingDt: maps[i]['openingDt'],
        businessDate: maps[i]['businessDate'],
      );
    });
  }

  @override
  Future<int> updateStatusInDb({required List<Remittedldb> repcoData}) async {
    final db = await SQLHelper.db();
    repcoData.forEach((element) async {
      await db.update("remittedTable", element.toMap(),
          where: "ReceiptNo=?", whereArgs: [element.ReceiptNo]);
    });
    throw UnimplementedError();
  }

  @override
  Future<List<Remittedldb>> getCollectedStatusList() async {
    final db = await SQLHelper.db();

    final List<Map<String, dynamic>> maps = await db
        .query('remittedTable', where: 'status = ?', whereArgs: ["Collected"]);

    return List.generate(maps.length, (i) {
      return Remittedldb(
        prId: maps[i]['prdId'],
        brId: maps[i]['brId'],
        collectedAmount: maps[i]['collectedAmount'],
        ReceiptNo: maps[i]['ReceiptNo'],
        collectedDate: maps[i]['collectedDate'],
        groupName: maps[i]['groupName'],
        groupId: maps[i]['groupId'],
        loanNo: maps[i]['loanNo'],
        loginId: maps[i]['loginId'],
        memName: maps[i]['memName'],
        id: maps[i]['id'],
        status: maps[i]['status'],
      );
    });
  }

  @override
  Future<List<Remittedldb>> getUnsyncedData(int boolinInt) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM remittedTable WHERE sync = $boolinInt');
    return List.generate(maps.length, (i) {
      return Remittedldb(
          prId: maps[i]['prdId'] != null ? maps[i]['prdId'] as String : null,
          brId: maps[i]['brId'] != null ? maps[i]['brId'] as String : null,
          collectedAmount: maps[i]['collectedAmount'] != null
              ? maps[i]['collectedAmount'] as num
              : null,
          ReceiptNo: maps[i]['ReceiptNo'] as dynamic,
          collectedDate: maps[i]['collectedDate'] != null
              ? maps[i]['collectedDate']
              : null,
          groupName: maps[i]['groupName'] != null
              ? maps[i]['groupName'] as String
              : null,
          loanNo:
              maps[i]['loanNo'] != null ? maps[i]['loanNo'] as String : null,
          loginId: maps[i]['loginId'] as dynamic,
          memName:
              maps[i]['memName'] != null ? maps[i]['memName'] as String : null,
          id: maps[i]['id'] != null ? maps[i]['id'] as num : null,
          groupId:
              maps[i]['groupId'] != null ? maps[i]['groupId'] as String : null,
          status:
              maps[i]['status'] != null ? maps[i]['status'] as String : null,
          sync: maps[i]['sync'] != null ? maps[i]['sync'] as int : null,
          loanAmt:
              maps[i]['loanAmt'] != null ? maps[i]['loanAmt'] as String : null,
          newCollectedDate: maps[i]['newCollectedDate'] != null
              ? maps[i]['newCollectedDate'] as String
              : null);
    });
  }
}
