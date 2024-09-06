import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/model/receipt_table_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../../../domain/entity/loan_collection_res_entity.dart';
import '../../model/remitted_screen_model.dart';

abstract class SQLhHelperRepositoryDb {
  Future<int> deleteDataFromDb({required String groupCode});
  Future<int> updateDataInDb({required ResultEntity repcoData});

  Future<void> insertDataToDbRemitted(Remittedldb remittedData);
  Future<List<Remittedldb>> readAllDataFromDbRemitted();
  Future<void> deleteDataFromDbRemitted(int id);
  Future<void> insertDataToReceiptDb(ReceiptTable receiptTable);
  Future<List<ReceiptTable>> readAllDataFromDbReceiptTable();
  Future<List<ReceiptTable>> readonlySuffixFromDbReceiptTable(String suffix);
  Future<List<Remittedldb>> readDataFromDbRemittedbyLoanNo(
      List<String> loanNoList);
  Future<void> updateSyncValue(String receiptNo, bool syncValue);
  Future<List<Remittedldb>> getDataByStatusList(List<String> statusList);
  Future<void> updateCollectedStatus(String receiptNo, String newStatus);
  Future<void> updateSyncValueList(List<String> receiptNoList, bool syncValue);
  Future<void> refreshLoanListTable();
  Future<List<Remittedldb>> getDataByStatusListAndIds(
      List<String> statusList, String loginId, String brId);
}

final sqlHelperProvider = StateProvider<SQLHelper>((ref) {
  return SQLHelper();
});

class SQLHelper extends SQLhHelperRepositoryDb {
  static Future<sql.Database> db() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "repcomfl.db");

    return sql.openDatabase(
      path,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        debugPrint("db_creatted");
        await SQLHelper.createLoanListTables(database);
        await SQLHelper.createTablesRemitted(database);
        await SQLHelper.createReceiptGenerationTable(database);
      },
    );
  }

  @override
  Future<void> refreshLoanListTable() async {
    final db = await SQLHelper.db();

    await deleteLoanListTables();
    await createLoanListTables(db);

    debugPrint("Refreshed tLOANLIST table");
  }

  Future<void> deleteLoanListTables() async {
    final db = await SQLHelper.db();
    await db.execute('DROP TABLE IF EXISTS tLOANLIST');
    debugPrint("deleted LoanListTables");
  }

  static Future<void> createLoanListTables(sql.Database dataBase) async {
    final sqlTableFormat = '''CREATE TABLE IF NOT EXISTS tLOANLIST(
    groupCode TEXT ,
    groupName TEXT,
    lonaNo TEXT PRIMARY KEY,
    memberName TEXT,
    loanAmt REAL,
    loanOS REAL,
    loanOverdue REAL,
    emiAmt REAL, 
    brID TEXT, 
    prdId TEXT,
    openingDt TEXT,
    businessDate TEXT)''';
    await dataBase.execute(sqlTableFormat);
  }

  Future<List<ResultEntity>> getGroupNamesWithSimilarGroupCodes(
      String searchTerm) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT DISTINCT groupName, groupCode 
    FROM tLOANLIST
    WHERE groupCode LIKE '%' || ? || '%'
  ''', [searchTerm]);
    return List.generate(result.length, (index) {
      return ResultEntity(
        groupCode: result[index]['groupCode'],
        groupName: result[index]['groupName'],
      );
    });
  }

  Future<List<ResultEntity>> filterLoanList({
    required String searchTerm,
    required String groupName,
    required String loanNo,
    required String borrowerName,
  }) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT DISTINCT groupName, groupCode 
    FROM tLOANLIST
    WHERE groupCode LIKE '%' || ? || '%'
    AND groupName LIKE '%' || ? || '%'
    AND lonaNo LIKE '%' || ? || '%'
    AND memberName LIKE '%' || ? || '%'
  ''', [searchTerm, groupName, loanNo, borrowerName]);

    return List.generate(result.length, (index) {
      return ResultEntity(
        groupCode: result[index]['groupCode'],
        groupName: result[index]['groupName'],
      );
    });
  }

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

  Future<List<ResultEntity>> readAllDataFromDb() async {
    final db = await SQLHelper.db();

    final List<Map<String, dynamic>> maps = await db.query('repco');

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

  // @override
  Future<List<ResultEntity>> getUniqueGroupNameAndCode() async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT DISTINCT groupName, groupCode FROM repco');

    return List.generate(maps.length, (index) {
      return ResultEntity(
        groupCode: maps[index]['groupCode'],
        groupName: maps[index]['groupName'],
      );
    });
  }

  @override
  Future<int> deleteDataFromDb({required String groupCode}) async {
    final db = await SQLHelper.db();
    int id = await db
        .delete("repco", where: 'groupCode = ?', whereArgs: [groupCode]);
    return id;
  }

  @override
  Future<int> updateDataInDb({required ResultEntity repcoData}) async {
    final db = await SQLHelper.db();

    int id = await db.update('repco', repcoData.toJson(),
        where: 'groupCode = ?', whereArgs: [repcoData.groupCode]);
    return id;
  }

  static Future<void> createTablesRemitted(sql.Database database) async {
    final sqlTableFormat = '''CREATE TABLE IF NOT EXISTS remittedTable(
  prdId TEXT,
  brId TEXT,
  collectedAmount NUMERIC,
  ReceiptNo TEXT,
  collectedDate TEXT,
  groupName TEXT,
  loanNo TEXT,
  loginId TEXT,
  memName TEXT,
  id NUMERIC,
  groupId TEXT,
  status TEXT,
  sync NUMERIC,
  loanAmt Text,
  newCollectedDate Text
)''';
    await database.execute(sqlTableFormat);
  }

  @override
  Future<void> updateCollectedStatus(String receiptNo, String newStatus) async {
    final db = await SQLHelper.db();
    await db.update(
      'remittedTable',
      {'status': newStatus},
      where: 'ReceiptNo = ?',
      whereArgs: [receiptNo],
    );
    debugPrint("db : $newStatus");
  }

  @override
  Future<List<Remittedldb>> getDataByStatusList(List<String> statusList) async {
    final db = await SQLHelper.db();
    String query =
        'SELECT * FROM remittedTable WHERE status IN (${statusList.map((e) => "'$e'").join(", ")})';
    List<Map<String, dynamic>> result = await db.rawQuery(query);
    return await List.generate(result.length, (i) {
      return Remittedldb(
          prId:
              result[i]['prdId'] != null ? result[i]['prdId'] as String : null,
          brId: result[i]['brId'] != null ? result[i]['brId'] as String : null,
          collectedAmount: result[i]['collectedAmount'] != null
              ? result[i]['collectedAmount'] as num
              : null,
          ReceiptNo: result[i]['ReceiptNo'] as dynamic,
          collectedDate: result[i]['collectedDate'],
          groupName: result[i]['groupName'] != null
              ? result[i]['groupName'] as String
              : null,
          loanNo: result[i]['loanNo'] != null
              ? result[i]['loanNo'] as String
              : null,
          loginId: result[i]['loginId'] as dynamic,
          memName: result[i]['memName'] != null
              ? result[i]['memName'] as String
              : null,
          id: result[i]['id'] != null ? result[i]['id'] as num : null,
          groupId: result[i]['groupId'] != null
              ? result[i]['groupId'] as String
              : null,
          status: result[i]['status'] != null
              ? result[i]['status'] as String
              : null,
          sync: result[i]['sync'] != null ? result[i]['sync'] as int : null,
          loanAmt: result[i]['loanAmt'] != null
              ? result[i]['loanAmt'] as String
              : null,
          newCollectedDate: result[i]['newCollectedDate'] != null
              ? result[i]['newCollectedDate'] as String
              : null);
    });
  }

  @override
  Future<List<Remittedldb>> getDataByStatusListAndIds(
      List<String> statusList, String loginId, String brId) async {
    final db = await SQLHelper.db();
    String query =
        'SELECT * FROM remittedTable WHERE status IN (${statusList.map((e) => "'$e'").join(", ")}) AND loginId = "$loginId" AND brId = "$brId"';
    List<Map<String, dynamic>> result = await db.rawQuery(query);
    return await List.generate(result.length, (i) {
      return Remittedldb(
          prId:
              result[i]['prdId'] != null ? result[i]['prdId'] as String : null,
          brId: result[i]['brId'] != null ? result[i]['brId'] as String : null,
          collectedAmount: result[i]['collectedAmount'] != null
              ? result[i]['collectedAmount'] as num
              : null,
          ReceiptNo: result[i]['ReceiptNo'] as dynamic,
          collectedDate: result[i]['collectedDate'],
          groupName: result[i]['groupName'] != null
              ? result[i]['groupName'] as String
              : null,
          loanNo: result[i]['loanNo'] != null
              ? result[i]['loanNo'] as String
              : null,
          loginId: result[i]['loginId'] as dynamic,
          memName: result[i]['memName'] != null
              ? result[i]['memName'] as String
              : null,
          id: result[i]['id'] != null ? result[i]['id'] as num : null,
          groupId: result[i]['groupId'] != null
              ? result[i]['groupId'] as String
              : null,
          status: result[i]['status'] != null
              ? result[i]['status'] as String
              : null,
          sync: result[i]['sync'] != null ? result[i]['sync'] as int : null,
          loanAmt: result[i]['loanAmt'] != null
              ? result[i]['loanAmt'] as String
              : null,
          newCollectedDate: result[i]['newCollectedDate'] != null
              ? result[i]['newCollectedDate'] as String
              : null);
    });
  }

  //todo
  Future<List<Remittedldb>> getDataByStatusAndLoginIdList(
      List<String> statusList, String loginId) async {
    final db = await SQLHelper.db();
    String query =
        'SELECT * FROM remittedTable WHERE status IN (${statusList.map((e) => "'$e'").join(", ")}) AND loginId = "$loginId"';
    List<Map<String, dynamic>> result = await db.rawQuery(query);
    return await List.generate(result.length, (i) {
      return Remittedldb(
          prId:
              result[i]['prdId'] != null ? result[i]['prdId'] as String : null,
          brId: result[i]['brId'] != null ? result[i]['brId'] as String : null,
          collectedAmount: result[i]['collectedAmount'] != null
              ? result[i]['collectedAmount'] as num
              : null,
          ReceiptNo: result[i]['ReceiptNo'] as dynamic,
          collectedDate: result[i]['collectedDate'],
          groupName: result[i]['groupName'] != null
              ? result[i]['groupName'] as String
              : null,
          loanNo: result[i]['loanNo'] != null
              ? result[i]['loanNo'] as String
              : null,
          loginId: result[i]['loginId'] as dynamic,
          memName: result[i]['memName'] != null
              ? result[i]['memName'] as String
              : null,
          id: result[i]['id'] != null ? result[i]['id'] as num : null,
          groupId: result[i]['groupId'] != null
              ? result[i]['groupId'] as String
              : null,
          status: result[i]['status'] != null
              ? result[i]['status'] as String
              : null,
          sync: result[i]['sync'] != null ? result[i]['sync'] as int : null,
          loanAmt: result[i]['loanAmt'] != null
              ? result[i]['loanAmt'] as String
              : null,
          newCollectedDate: result[i]['newCollectedDate'] != null
              ? result[i]['newCollectedDate'] as String
              : null);
    });
  }

  @override
  Future<List<Remittedldb>> readAllDataFromDbRemitted() async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> maps = await db.query('remittedTable');

    return List.generate(maps.length, (i) {
      return Remittedldb(
          prId: maps[i]['prdId'] != null ? maps[i]['prdId'] as String : null,
          brId: maps[i]['brId'] != null ? maps[i]['brId'] as String : null,
          collectedAmount: maps[i]['collectedAmount'] != null
              ? maps[i]['collectedAmount'] as num
              : null,
          ReceiptNo: maps[i]['ReceiptNo'] as dynamic,
          collectedDate: maps[i]['collectedDate'],
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

  @override
  Future<void> updateSyncValue(String receiptNo, bool syncValue) async {
    final db = await SQLHelper.db();

    await db.update(
      'remittedTable',
      {'sync': syncValue ? 1 : 0},
      where: 'ReceiptNo = ?',
      whereArgs: [receiptNo],
    );
  }

  @override
  Future<void> updateSyncValueList(
      List<String> receiptNoList, bool syncValue) async {
    final db = await SQLHelper.db();

    String inClause = receiptNoList.map((e) => '?').toList().join(', ');

    await db.update(
      'remittedTable',
      {'sync': syncValue ? 1 : 0},
      where: 'ReceiptNo IN ($inClause)',
      whereArgs: receiptNoList,
    );
  }

  @override
  Future<List<Remittedldb>> readDataFromDbRemittedbyLoanNo(
      List<String> loanNoList) async {
    final db = await SQLHelper.db();
    String query = 'SELECT * FROM remittedTable WHERE loanNo IN (' +
        loanNoList.map((e) => '\"$e\"').toList().join(',') +
        ')';

    List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return List.generate(maps.length, (i) {
      return Remittedldb(
          prId: maps[i]['prdId'] != null ? maps[i]['prdId'] as String : null,
          brId: maps[i]['brId'] != null ? maps[i]['brId'] as String : null,
          collectedAmount: maps[i]['collectedAmount'] != null
              ? maps[i]['collectedAmount'] as num
              : null,
          ReceiptNo: maps[i]['ReceiptNo'] as dynamic,
          collectedDate: maps[i]['collectedDate'],
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
          newCollectedDate: maps[i]['loannewCollectedDateAmt'] != null
              ? maps[i]['newCollectedDate'] as String
              : null);
    });
  }

  static Future<void> createReceiptGenerationTable(
      sql.Database database) async {
    final sqlTableFormat = '''CREATE TABLE IF NOT EXISTS receiptTable(
    branchId Numeric,
    prefix Numeric,
    sequence TEXT,
    suffix Numeric
  )''';
    await database.execute(sqlTableFormat);
  }

  @override
  Future<void> insertDataToReceiptDb(ReceiptTable receiptTable) async {
    final db = await SQLHelper.db();
    await db.insert("receiptTable", receiptTable.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  @override
  Future<List<ReceiptTable>> readonlySuffixFromDbReceiptTable(
      String suffix) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> maps = await db
        .query('receiptTable', where: 'suffix = ?', whereArgs: [suffix]);
    debugPrint("inserting");
    return List.generate(maps.length, (i) {
      return ReceiptTable(
          branchId: maps[i]['branchId'],
          prefix: maps[i]['prefix'],
          sequence: maps[i]['sequence'],
          suffix: maps[i]['suffix']);
    });
  }

  @override
  Future<List<ReceiptTable>> readAllDataFromDbReceiptTable() async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> maps = await db.query('receiptTable');
    debugPrint("inserting");
    return List.generate(maps.length, (i) {
      return ReceiptTable(
          branchId: maps[i]['branchId'],
          prefix: maps[i]['prefix'],
          sequence: maps[i]['sequence'],
          suffix: maps[i]['suffix']);
    });
  }

  @override
  Future<void> insertDataToDbRemitted(Remittedldb remittedData) async {
    final db = await SQLHelper.db();
    await db.insert("remittedTable", remittedData.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print("inserted");
  }

  @override
  Future<void> deleteDataFromDbRemitted(int id) async {
    final db = await SQLHelper.db();
    await db.delete('remittedTable', where: 'id = ?', whereArgs: [id]);
  }

  // @override
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
          collectedDate: maps[i]['collectedDate'],
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
          newCollectedDate: maps[i]['loannewCollectedDateAmt'] != null
              ? maps[i]['newCollectedDate'] as String
              : null);
    });
  }
}
