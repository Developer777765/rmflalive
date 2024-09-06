import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static Future<void> setPh(value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("phNo", value);
  }

  static Future<String?> getPh() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("phNo");
  }

  static Future<void> setBranchName(value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("brName", value);
  }

  static Future<String?> getbranchName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("brName");
  }
}
