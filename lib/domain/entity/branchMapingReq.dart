  
  import 'dart:convert';

  BranchMapingReqEntity branchMapingReqEntityFromJson(String str) => BranchMapingReqEntity.fromJson(json.decode(str));

  String branchMapingReqEntityToJson(BranchMapingReqEntity data) => json.encode(data.toJson());

  class BranchMapingReqEntity {
      BranchMapingReqEntity({
          required this.tokenNo,
          required this.loginId,
          required this.platfrom,
          required this.branchMappingreq,
      });

      final String tokenNo;
      final String loginId;
      final String platfrom;
      final BranchMappingreq branchMappingreq;

      factory BranchMapingReqEntity.fromJson(Map<String, dynamic> json) => BranchMapingReqEntity(
          tokenNo: json["tokenNo"],
          loginId: json["loginID"],
          platfrom: json["platfrom"],
          branchMappingreq: BranchMappingreq.fromJson(json["branchMappingreq"]),
      );

      Map<String, dynamic> toJson() => {
          "tokenNo": tokenNo,
          "loginID": loginId,
          "platfrom": platfrom,
          "branchMappingreq": branchMappingreq.toJson(),
      };
  }

  class BranchMappingreq {
      BranchMappingreq({
          required this.branchId,
          required this.createdby,
          required this.ischeck,
          required this.mobileNo,
          required this.uniqueId,
      });

      final String branchId;
      final String createdby;
      final bool ischeck;
      final String mobileNo;
      final String uniqueId;

      factory BranchMappingreq.fromJson(Map<String, dynamic> json) => BranchMappingreq(
          branchId: json["branchId"],
          createdby: json["createdby"],
          ischeck: json["ischeck"],
          mobileNo: json["mobileNo"],
          uniqueId: json["uniqueId"],
      );

      Map<String, dynamic> toJson() => {
          "branchId": branchId,
          "createdby": createdby,
          "ischeck": ischeck,
          "mobileNo": mobileNo,
          "uniqueId": uniqueId,
      };
  }
