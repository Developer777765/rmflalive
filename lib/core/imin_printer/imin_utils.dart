import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

MethodChannel _channel = const MethodChannel('com.imin.printersdk');

class IminUtils {
  ValueNotifier<String> stateNotifier = ValueNotifier("");
  ValueNotifier<String> libsNotifier = ValueNotifier("");
  ValueNotifier<String> scanNotifier = ValueNotifier("");

  IminUtils() {
    initPrinter();
  }

  Future<void> initPrinter() async {
    stateNotifier.value = await _channel.invokeMethod("sdkInit");
  }

  Future<void> printText(String text, [int fontsize = 23]) async {
    // stateNotifier.value = await _channel.invokeMethod("setTextTypeface", [1]);
    stateNotifier.value =
        await _channel.invokeMethod("setTextSize", [fontsize]);
    stateNotifier.value = await _channel.invokeMethod("printText", [text]);
  }

  Future<void> printTextWithLine(String text, [int fontsize = 20]) async {
    stateNotifier.value =
        await _channel.invokeMethod("setTextSize", [fontsize]);

    stateNotifier.value = await _channel.invokeMethod("printText", ["$text\n"]);
  }

  Future<void> printReceipt({
    required String branch,
    required String date,
    required String staffName,
    required String collectedAmount,
    required String remittedAmount,
    required String payableAmount,
    required String acCollections,
  }) async {
    await initPrinter();

    await printText(" REPCO MICRO FINANCE LIMITED");
    await printText(" Branch : $branch ");
    await printText(" Date : $date");
    await printText(
        " .............................................................. ");
    await printText(" Cash Collection Receipt");
    await printText(
        " .............................................................. ");
    await printText("""
 Staff Name               : $staffName
 Collected Amount    : Rs.$collectedAmount
 Remitted Amount    : Rs.$remittedAmount
 Payable Amount      : Rs.$payableAmount
 Nos.A/c Collections : $acCollections
..............................................................  
 

 """);
    // await printText(" Collected Amount : Rs.$collectedAmount");
    // await printText(" Remitted Amount  : Rs.$branch");
    // await printText(" Payable Amount   : Rs.$payableAmount");
    // await printText(" Nos.A/c Collections: Rs.$acCollections");
    // await printText(
    //     " .............................................................. ");
    // stateNotifier.value = await _channel.invokeMethod("partialCut");
    // await printText(" ");
    // await printText(" ");
    // await printText(" ");
    // await printText(" ");
    // await printText(" ");

    // await printLogoImage();
  }

  String sampleString =
      "iron titanium gold carbon silicon hydrogen oxygen nitrogen helium lithium aluminium galium calcium";
  Future<void> printReceiptNonRemitted(
      {required String branch,
      required String receiptNo,
      required String groupId,
      required String groupName,
      required String loanNo,
      required String name,
      required String collectedAmt,
      required String date,
      required String collectedBy}) async {
    await initPrinter();
    // await printLogoImage();
    // await SunmiPrinter.lineWrap(1);
    await printText("  REPCO MICRO FINANCE LIMITED");
    await printText("  Branch : $branch ");
    await printText(
        " .............................................................. ");
    await printText(" Cash Collection Receipt");
    await printText(" (Duplicate value)");
    await printText(
        " .............................................................. ");
    await printText("""
Receipt No     : $receiptNo
Group ID        : $groupId
Group Name : ${groupName.length < 14 ? groupName : splitCalculation1(groupName)}
Loan No          : $loanNo
Name             : ${name.length < 14 ? name : splitCalculation1(name)}
Collected Amount : Rs.$collectedAmt
Date       : $date
Collected by  : $collectedBy


..............................................................  
 


         """);
    // await printText(" Group ID   : $groupId");
    // await printText(" Group Name : $groupName");
    // await printText(" Loan No    : $loanNo ");
    // await printText(" Name       : $name ");
    // await printText(" Collected Amount : Rs.$collectedAmt");
    // await printText(" Date : $date");
    // await printText(" Collected by : $collectedBy ");
    // await printText(
    //     " .............................................................. ");
    // stateNotifier.value = await _channel.invokeMethod("partialCut");
    // await printText(" ");
    // await printText(" ");
    // await printText(" ");
  }

  Future<void> printReceiptMoneyCollection(
      {required String branch,
      required String receiptNo,
      required String groupId,
      required String groupName,
      required String loanNo,
      required String name,
      required String collectedAmt,
      required String date,
      required String collectedBy}) async {
    await initPrinter();
    // await printLogoImage();
    // await SunmiPrinter.lineWrap(1);
    // await printText("  REPCO MICRO FINANCE LIMITED");
    // await printText("  Branch : $branch ");
    // await printText(
    //     " .............................................................. ");
    // await printText("Cash Collection Receipt");
    // // await printText("  " + " (Duplicate value)");
    // await printText(
    //     " .............................................................. ");
    await printText("""
  REPCO MICRO FINANCE LIMITED
  Branch : $branch 
 .............................................................. 
Cash Collection Receipt
 .............................................................. 
Receipt No     : $receiptNo
Group ID        : $groupId
Group Name : ${groupName.length < 14 ? groupName : splitCalculation1(groupName)}
Loan No          : $loanNo
Name             : ${name.length < 14 ? name : splitCalculation1(name)}
Collected Amount : Rs.$collectedAmt
Date       : $date
Collected by  : $collectedBy
..............................................................  
 

         """);
    // await printText(" Group ID: $groupId");
    // await printText(" Group Name: $groupName");
    // await printText(" Loan No: $loanNo ");
    // await printText(" Name : $name ");
    // await printText(" Collected Amount : Rs.$collectedAmt");
    // await printText(" Date : $date");
    // await printText(" Collected by : $collectedBy ");
    // await printText(
    //     " .............................................................. ");
    // await printText(" ");
    // await printText(" ");
    // await printText(" ");
  }
}

String splitCalculation1(String groupName) {
  String stringCollection = "";
  List<String> listString = [];
  const int limitCount = 14;
  listString = groupName.split("").toList();
  debugPrint("listString : ${listString.length}");
  var div = listString.length / limitCount;
  int line =
      listString.length % limitCount != 0 ? div.toInt() + 1 : div.toInt();
  debugPrint("Line$line");
  for (int i = 1; i <= line; i++) {
    debugPrint(listString[i]);
    stringCollection += (i == 1 ? "" : "\n                         ") +
        listString
            .getRange(
                limitCount * (i - 1),
                listString.length <= (limitCount * i)
                    ? listString.length
                    : limitCount * i)
            .join();
  }
  debugPrint("listString final:$listString");

  debugPrint("final String : $stringCollection");
  return stringCollection;
}
