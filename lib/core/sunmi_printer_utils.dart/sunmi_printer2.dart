// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class Sunmi2 {
  // initialize sunmi printer
  Future<void> initialize() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
  }

  Future<void> printLogoImage() async {
    await SunmiPrinter.lineWrap(1);
    Uint8List byte = await _getImageFromAsset(
      "assets/images/dummy2.png",
    );
    await SunmiPrinter.printImage(
      byte,
    );
    await SunmiPrinter.lineWrap(1);
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  Future<void> printText(String text) async {
    // await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(text,
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          bold: false,
          align: SunmiPrintAlign.LEFT,
        ));
    // await SunmiPrinter.lineWrap(1);
  }

  Future<void> printTextSmall(String text) async {
    // await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(text,
        style: SunmiStyle(
          fontSize: SunmiFontSize.SM,
          bold: false,
          align: SunmiPrintAlign.LEFT,
        ));
    // await SunmiPrinter.lineWrap(1);
  }

  Future<void> closePrinter() async {
    await SunmiPrinter.unbindingPrinter();
  }

  // print row and 2 columns
  Future<void> printRowAndColumns({
    required String branch,
    required String staffName,
    required String collectedAmount,
    required String remittedAmount,
    required String payableAmount,
    required String acCollections,
  }) async {
    await SunmiPrinter.lineWrap(1); // creates one line space

    // set alignment center
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    // prints a row with 3 columns
    // total width of columns should be 30
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "SummaryCollectionlist",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "Reports",
        width: 10,
        align: SunmiPrintAlign.CENTER,
      ),
      // for (var i = 0; i < data.length; i++) {}
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Branch ",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: branch,
        width: 10,
        align: SunmiPrintAlign.CENTER,
      ),
      // for (var i = 0; i < data.length; i++) {}
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "StaffName",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: staffName,
        width: 10,
        align: SunmiPrintAlign.CENTER,
      ),
      // for (var i = 0; i < data.length; i++) {}
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "CollectedAmount",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: collectedAmount,
        width: 10,
        align: SunmiPrintAlign.CENTER,
      ),
      // for (var i = 0; i < data.length; i++) {}
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Remitted Amount",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: remittedAmount,
        width: 10,
        align: SunmiPrintAlign.CENTER,
      ),
      // for (var i = 0; i < data.length; i++) {}
    ]);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "PayableAmount",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: payableAmount,
        width: 10,
        align: SunmiPrintAlign.CENTER,
      ),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Nos A/c Collections",
        width: 10,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: acCollections,
        width: 10,
        align: SunmiPrintAlign.CENTER,
      ),
    ]);
    await SunmiPrinter.lineWrap(1); // creates one line space
  }

  // print one structure
  Future<void> printReceipt({
    required String branch,
    required String date,
    required String staffName,
    required String collectedAmount,
    required String remittedAmount,
    required String payableAmount,
    required String acCollections,
  }) async {
    await initialize();
    // await printLogoImage();
    // await SunmiPrinter.lineWrap(1);
    await printText(" REPCO MICRO FINANCE LIMITED");
    await printText(" Branch : $branch ");
    await printText(" Date : $date");
    await printText(" ...............................");
    await printText(" Cash Collection Receipt");
    await printText(" ...............................");
    await printText(" Staff Name       : $staffName");
    await printText(" Collected Amount : Rs.$collectedAmount");
    await printText(" Remitted Amount  : Rs.$branch");
    await printText(" Payable Amount   : Rs.$payableAmount");
    await printText(" Nos.A/c Collections: Rs.$acCollections");
    await printText(" ...............................");
    await printText(" ");
    await printText(" ");
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.cut();
    // await printLogoImage();
    await closePrinter();
  }

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
    await initialize();
    // await printLogoImage();
    // await SunmiPrinter.lineWrap(1);
    await printText(" REPCO MICRO FINANCE LIMITED");
    await printText(" Branch : $branch ");
    await printText(" ...............................");
    await printText(" Cash Collection Receipt");
    await printText(" (Duplicate Copy)");
    await printText(" ...............................");
    await printText(" Receipt No : $receiptNo");
    await printText(" Group ID   : $groupId");
    await printText(" Group Name : ${groupName.length < 18 ? groupName : splitCalculation(groupName)}");
    await printText(" Loan No    : $loanNo ");
    await printText(" Name       : $name ");
    await printText(" Collected Amount : Rs.$collectedAmt");
    await printText(" Date : $date");
    await printText(" Collected by : $collectedBy ");
    await printText(" ...............................");
    await printText(" ");
    await printText(" ");
    await SunmiPrinter.lineWrap(1);

    // await printRowAndColumns(
    //     branch: branch,
    //     staffName: staffName,
    //     collectedAmount: collectedAmount,
    //     remittedAmount: remittedAmount,
    //     payableAmount: payableAmount,
    //     acCollections: acCollections);

    await SunmiPrinter.cut();
    await closePrinter();
  }

  String splitCalculation(String groupName) {
    String stringCollection = "";
    List<String> listString = [];
    const int limitCount = 17;
    listString = groupName.split("").toList();
    debugPrint("listString : ${listString.length}");
    var div = listString.length / limitCount;
        int line = listString.length % limitCount != 0
        ?  div.toInt()+1
        : div.toInt();
        debugPrint("Line$line");
    for (int i = 1; i <= line; i++) {
      debugPrint(listString[i]);
      stringCollection += (i == 1 ? "" : "\n              ") +
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
    await initialize();
    // await printLogoImage();
    // await SunmiPrinter.lineWrap(1);
    await printText(" REPCO MICRO FINANCE LIMITED");
    await printText(" Branch : $branch ");
    await printText(" ...............................");
    await printText(" Cash Collection Receipt");
    // await printText(" (Duplicate value)");
    await printText(" ...............................");
    await printText(" Receipt No : $receiptNo");
    await printText(" Group ID   : $groupId");
    // await printText("Group Name : Group Name Group Name Group Name Group Name Group Name");
    await printText(
        " Group Name : ${groupName.length < 18 ? groupName : splitCalculation(groupName)}");
    await printText(" Loan No    : $loanNo ");
    await printText(" Name       : $name ");
    await printText(" Collected Amount : Rs.$collectedAmt");
    await printText(" Date : $date");
    await printText(" Collected by : $collectedBy ");
    await printText(" ...............................");
    await printText(" ");
    await printText(" ");
    await SunmiPrinter.lineWrap(1);

    await SunmiPrinter.cut();
    await closePrinter();
  }
}
