class Apiconstant {
  // static const SERVER_URL = "http://3.6.63.31:2902/";
  // static const SERVER_URL = "https://10.10.12.20/";
  // static const SERVER_URL = "https://10.10.12.20/";
  // static const SERVER_URL = "https://10.10.12.20:2010/";
  // static const SERVER_URL = "https://10.10.13.10:2010/";
  // static const SERVER_URL = "https://10.10.12.20:2010/";
  static const SERVER_URL = "http://3.6.63.31:2902/";

  static const LOGIN_URL = "${SERVER_URL}AuthServices/Authenticate";

  static const Loan_collection_Amt = '${SERVER_URL}LoanCollection/GetLoanLists';
  static const collection_list_report =
      '${SERVER_URL}LoanCollection/GetCollectionListReport';
  static const admin_login = "${SERVER_URL}AuthServices/Authenticate";
  static const admin_branch_maping =
      "${SERVER_URL}Authentication/BranchMapping";
  static const CHECKTODAYCOLLECTIONSTATUS =
      "${SERVER_URL}LoanCollection/CheckTodayCollectionStatus";
  static const save_collected_ln_amt =
      "${SERVER_URL}LoanCollection/SaveCollectedLoanAmount";
  static const check_collected_amt_list =
      "${SERVER_URL}LoanCollection/CheckCollectedAmountListStatus";
  static const GETUSERMAPPING = "${SERVER_URL}AuthServices/getUserList";
  static const INSERTUSER = "${SERVER_URL}AuthServices/insertUser";
  static const CHANGEPASSWORD = "${SERVER_URL}AuthServices/changePassword";
  static const Map<String, String> headers = {
    'Content-Type': 'application/json'
  };
}
