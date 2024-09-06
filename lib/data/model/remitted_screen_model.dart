import 'dart:convert';

class Remittedldb {
  String? brId;
  num? collectedAmount;
  dynamic ReceiptNo;
  String? prId;
  String? collectedDate;
  String? groupName;
  String? loanNo;
  dynamic loginId;
  String? memName;
  num? id;
  String? groupId;
  String? status;
  int? sync;
  String? loanAmt;
  String? newCollectedDate;

  Remittedldb(
      {this.brId,
      this.collectedAmount,
      this.ReceiptNo,
      this.prId,
      this.collectedDate,
      this.groupName,
      this.loanNo,
      this.loginId,
      this.memName,
      this.id,
      this.groupId,
      this.status,
      this.sync,
      this.loanAmt,
      this.newCollectedDate});

  Remittedldb copyWith(
      {String? brId,
      num? collectedAmount,
      dynamic ReceiptNo,
      required String prId,
      String? collectedDate,
      String? groupName,
      String? loanNo,
      dynamic loginId,
      String? memName,
      num? id,
      String? groupId,
      String? status,
      int? sync,
      String? loanAmt,
      String? newCollectedDate}) {
    return Remittedldb(
      prId: prId,
      brId: brId ?? this.brId,
      collectedAmount: collectedAmount ?? this.collectedAmount,
      ReceiptNo: ReceiptNo ?? this.ReceiptNo,
      collectedDate: collectedDate ?? this.collectedDate,
      groupName: groupName ?? this.groupName,
      loanNo: loanNo ?? this.loanNo,
      loginId: loginId ?? this.loginId,
      memName: memName ?? this.memName,
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      status: status ?? this.status,
      sync: sync ?? this.sync,
      loanAmt: loanAmt ?? this.loanAmt,
      newCollectedDate: newCollectedDate ?? this.newCollectedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'prdId': prId,
      'brId': brId,
      'collectedAmount': collectedAmount,
      'ReceiptNo': ReceiptNo,
      'collectedDate': collectedDate,
      'groupName': groupName,
      'loanNo': loanNo,
      'loginId': loginId,
      'memName': memName,
      'id': id,
      'groupId': groupId,
      'status': status,
      'sync': sync,
      'loanAmt': loanAmt,
      'newCollectedDate': newCollectedDate
    };
  }

  factory Remittedldb.fromMap(Map<String, dynamic> map) {
    return Remittedldb(
        prId: map["prdId"] != null ? map["prdId"] as String : null,
        brId: map['brId'] != null ? map['brId'] as String : null,
        collectedAmount: map['collectedAmount'] != null
            ? map['collectedAmount'] as num
            : null,
        ReceiptNo: map['ReceiptNo'] as dynamic,
        collectedDate:
            map['collectedDate'] != null ? map['collectedDate'] : null,
        groupName: map['groupName'] != null ? map['groupName'] as String : null,
        loanNo: map['loanNo'] != null ? map['loanNo'] as String : null,
        loginId: map['loginId'] as dynamic,
        memName: map['memName'] != null ? map['memName'] as String : null,
        id: map['id'] != null ? map['id'] as num : null,
        groupId: map['groupId'] != null ? map['groupId'] as String : null,
        status: map['status'] != null ? map['status'] as String : null,
        sync: map['sync'] != null ? map['sync'] as int : null,
        loanAmt: map['loanAmt'] != null ? map['loanAmt'] as String : null,
        newCollectedDate: map['newCollectedDate'] != null
            ? map['newCollectedDate'] as String
            : null);
  }

  String toJson() => json.encode(toMap());

  factory Remittedldb.fromJson(String source) =>
      Remittedldb.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Remittedldb(brId: $brId, collectedAmount: $collectedAmount, ReceiptNo: $ReceiptNo, collectedDate: $collectedDate, groupName: $groupName, loanNo: $loanNo, loginId: $loginId, memName: $memName, id: $id, groupId: $groupId, status: $status, loanAmt: $loanAmt, newCollectedDate: $newCollectedDate)';
  }

  @override
  bool operator ==(covariant Remittedldb other) {
    if (identical(this, other)) return true;

    return other.brId == brId &&
        other.collectedAmount == collectedAmount &&
        other.ReceiptNo == ReceiptNo &&
        other.prId == prId &&
        other.collectedDate == collectedDate &&
        other.groupName == groupName &&
        other.loanNo == loanNo &&
        other.loginId == loginId &&
        other.memName == memName &&
        other.id == id &&
        other.groupId == groupId &&
        other.status == status &&
        other.sync == sync &&
        other.loanAmt == loanAmt &&
        other.newCollectedDate == newCollectedDate;
  }

  @override
  int get hashCode {
    return brId.hashCode ^
        collectedAmount.hashCode ^
        ReceiptNo.hashCode ^
        collectedDate.hashCode ^
        prId.hashCode ^
        groupName.hashCode ^
        loanNo.hashCode ^
        loginId.hashCode ^
        memName.hashCode ^
        id.hashCode ^
        groupId.hashCode ^
        status.hashCode ^
        sync.hashCode ^
        loanAmt.hashCode ^
        newCollectedDate.hashCode;
  }
}
