import 'dart:io';

import 'package:excel/excel.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/imin_printer/imin_utils.dart';
import '../../../core/sunmi_printer_utils.dart/sunmi_printer2.dart';
import '../splash/splash_screen.dart';
import '/core/notification_service.dart';
import '/domain/entity/collction_list_report_res_entity.dart';
import '/feature/provider/login_provider.dart';
import '/feature/provider/network_listener_provider.dart';

import '../../../core/pdf_utils.dart';
// import '../../../core/sunmi_printer_utils.dart/sunmi_printer2.dart';
import '../../../core/value_manger.dart';
import '../../provider/auto_logout_provider.dart';
import '../../provider/collection_list_report_provider.dart';
import '../common_widgets/common_methods.dart';

class CollectionSummaryReportScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CollectionSummaryReportScreen();
  }
}

class _CollectionSummaryReportScreen
    extends ConsumerState<CollectionSummaryReportScreen> {
  TextEditingController dateinputStartController = TextEditingController();
  TextEditingController dateinputEndController = TextEditingController();

  TextEditingController remittedAmtController = TextEditingController();
  TextEditingController collectedAmtController = TextEditingController();
  TextEditingController payableAmtController = TextEditingController();
  TextEditingController noAcController = TextEditingController();
  TextEditingController brIdController = TextEditingController();
  TextEditingController stafNameController = TextEditingController();

  DateTimeRange? _pickedDate;

  void _pickDateFunction() async {
    _pickedDate = await showDateRangePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: const Color(0xFF216C2E),
                onPrimary: const Color.fromARGB(255, 255, 255, 255),
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
        context: context,
        currentDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());

    if (ref.watch(connectivityStatusProviders) ==
        ConnectivityStatus.connected) {
      if (_pickedDate != null) {
        dateinputStartController.text = ref
            .read(stratDateTxtFieldProvider.notifier)
            .update(
                (state) => DateFormat('dd/MM/yyyy').format(_pickedDate!.start));
        dateinputEndController.text = ref
            .read(endDateTxtFieldProvider.notifier)
            .update(
                (state) => DateFormat('dd/MM/yyyy').format(_pickedDate!.end));

        ref.read(dateStartApiProvider1.notifier).update((state) =>
            DateFormat("yyyy-MM-ddTHH:mm:ss").format(_pickedDate!.start));
        ref.read(dateEndtApiProvider1.notifier).update((state) =>
            DateFormat("yyyy-MM-ddTHH:mm:ss").format(_pickedDate!.end));
        // ignore: unused_result
        ref.refresh(collectionListProvider1);
        String formattedDateEndString = DateFormat("yyyy-MM-ddTHH:mm:ss")
            .format(_pickedDate!.end)
            .replaceRange(10, null, "T23:59:59");
        ref
            .read(dateEndtApiProvider1.notifier)
            .update((state) => formattedDateEndString);
        // ignore: unused_result
        ref.refresh(collectionListProvider1);
        selectedValue = "select";
        setState(() {});
      } else {
        selectedValue = "select";
        setState(() {});
        debugPrint("Date is not selected");
      }
    } else if (ref.watch(connectivityStatusProviders) ==
            ConnectivityStatus.disconnected ||
        ref.watch(connectivityStatusProviders) ==
            ConnectivityStatus.notDetermined) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Alert!"),
            content: const Text(
                "Internet connection unavailable Please turn on your internet"),
            actions: [
              TextButton(
                  onPressed: () {
                    selectedValue = "select";
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          );
        },
      );
    }
  }

  Future<void> _showPrintAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Are you sure want to print receipt ?',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                var posPrint =
                    ref.read(deviceModelProvider) ? Sunmi2() : IminUtils();

                if (posPrint is Sunmi2) {
                  Sunmi2 sunmi2Printer = posPrint;
                  await sunmi2Printer.printReceipt(
                      date:
                          "${dateinputStartController.text.trim()} to ${dateinputEndController.text.trim()}",
                      branch: ref.watch(brIdProvider),
                      staffName: ref.read(userIdProvider)[0].toUpperCase() +
                          ref.read(userIdProvider).substring(1),
                      collectedAmount:
                          collectedAmt(filedata!).toDouble().toString(),
                      remittedAmount: remittedAmt(filedata!).toString(),
                      payableAmount: payableAmtController.text.toString(),
                      acCollections: filedata!.length.toString());
                  Navigator.of(context).pop();
                } else if (posPrint is IminUtils) {
                  IminUtils iminUtilsPrinter = posPrint;
                  await iminUtilsPrinter.printReceipt(
                      date:
                          "${dateinputStartController.text.trim()} to ${dateinputEndController.text.trim()}",
                      branch: ref.watch(brIdProvider),
                      staffName: ref.read(userIdProvider)[0].toUpperCase() +
                          ref.read(userIdProvider).substring(1),
                      collectedAmount:
                          collectedAmt(filedata!).toDouble().toString(),
                      remittedAmount: remittedAmt(filedata!).toString(),
                      payableAmount: payableAmtController.text.toString(),
                      acCollections: filedata!.length.toString());
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  String selectedValue = "select";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        child: Text("Select"),
        value: "select",
      ),
      const DropdownMenuItem(
        child: Text("EXCEL"),
        value: "excel",
      ),
      const DropdownMenuItem(
        child: Text("PDF"),
        value: "pdf",
      ),
    ];
    return menuItems;
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  void initClear() async {
    dateinputStartController.text = '';
    dateinputEndController.text = '';

    await ref.read(dateEndtApiProvider1.notifier).update((state) => '');
    await ref.read(dateStartApiProvider1.notifier).update((state) => '');
    payableAmtController.clear();
    remittedAmtController.clear();
    collectedAmtController.clear();
    noAcController.clear;
    setState(() {});
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   initClear();
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    NotificationService().initNotification;

    Future.delayed(
      const Duration(microseconds: 20),
      () {
        initClear();
        resultdata.clear();
        // setState(() {});
      },
    );
  }

  @override
  void dispose() {
    ref.read(dateEndtApiProvider1.notifier).update((state) => '');
    ref.read(dateStartApiProvider1.notifier).update((state) => '');
    super.dispose();
  }

  Future<void> _showPrintDialog(String newValue) async {
    if (_formKey.currentState!.validate()) {
      await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  'Do you want to download ?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedValue = "select";
                      });
                      Navigator.pop(context);
                    },
                    //return false when click on "NO"
                    child: const Text('No'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      {
                        setState(() {
                          selectedValue = newValue;
                        });

                        if (selectedValue == "select") {
                          debugPrint(
                              "sync selected$selectedValue");
                        } else if (selectedValue == "excel") {
                          var excel = Excel.createExcel();
                          CellStyle cellStyle = CellStyle(
                            bold: true,
                            italic: false,
                            rotation: 0,
                          );
                          var sheet1 = excel['Sheet1'];

                          List<Map<String, dynamic>> data = [
                            {
                              "Branch": ref.read(brIdProvider),
                              "StaffName": ref.read(userIdProvider),
                              "CollectedAmount":
                                  "Rs.${collectedAmt(filedata!)}",
                              "RemitedAmount":
                                  remittedAmt(filedata!).toString(),
                              'PayableAmount':
                                  "Rs.${payableAmtController.text}",
                              "Nos.A/c Collections": filedata!.length
                            },
                          ];
                          int coli = 0;
                          int rowj = 0;
                          //header
                          data[0].forEach((key, value) {
                            sheet1
                                .cell(CellIndex.indexByColumnRow(
                                    columnIndex: coli, rowIndex: rowj))
                                .cellStyle = cellStyle;
                            sheet1
                                .cell(CellIndex.indexByColumnRow(
                                    columnIndex: coli, rowIndex: rowj))
                                .value = key;
                            coli++;
                          });

                          int row = 1;
                          int col = 0;
                          //values
                          for (int i = 0; i < data.length; i++) {
                            col = 0;
                            data[i].forEach((key, value) {
                              sheet1
                                  .cell(CellIndex.indexByColumnRow(
                                      columnIndex: col, rowIndex: row))
                                  .value = value;
                              col++;
                            });
                            row++;
                          }

                          List<int>? fileBytes = excel.save(
                              fileName: "ExcelReports${DateTime.now()}xlsx");
                          var path = await ExternalPath
                              .getExternalStoragePublicDirectory(
                                  ExternalPath.DIRECTORY_DOWNLOADS);

                          writeToFile(fileBytes, path);
                          NotificationService().showDownloadedNotification(
                              ref
                                  .read(uniqueIdNotificationProvider.notifier)
                                  .update((state) => state + 1),
                              path,
                              " Excel Report",
                              " File Downloaded Location : $path");

                          debugPrint(
                              " excel selected$selectedValue");
                          selectedValue = "select";

                          Navigator.of(context).pop();
                          var dwnsnack =
                              authsnackbar("Excel File Downloaded", context);
                          ScaffoldMessenger.of(context).showSnackBar(dwnsnack);
                          setState(() {});
                          await showAlertOpenDialog(context);
                        } else if (selectedValue == "pdf") {
                          List<Map<String, dynamic>> data = [
                            {
                              "Branch": ref.read(brIdProvider),
                            },
                            {
                              "StaffName": ref.read(userIdProvider),
                            },
                            {
                              "CollectedAmount":
                                  "Rs.${collectedAmt(filedata!)}",
                            },
                            {
                              "RemitedAmount":
                                  "Rs.${remittedAmt(filedata!)}",
                            },
                            {
                              'PayableAmount':
                                  "Rs.${payableAmtController.text}",
                            },
                            {
                              "Nos.A/c Collections":
                                  noAcController.text.toString()
                            }
                          ];
                          var path = await ExternalPath
                              .getExternalStoragePublicDirectory(
                                  ExternalPath.DIRECTORY_DOWNLOADS);
                          Uint8List fileBytes = await makePdf2(
                            data,
                          );
                          String date = DateTime.now()
                              .toString()
                              .replaceAll(".", "")
                              .replaceAll(":", "")
                              .replaceAll(" ", "_");
                          File files =
                              File("$path/PDFSummaryReport$date.pdf");
                          try {
                            files.open(mode: FileMode.writeOnly);
                            final buffer = fileBytes.buffer;
                            files.writeAsBytes(buffer.asUint8List(
                                fileBytes.offsetInBytes,
                                fileBytes.lengthInBytes));
                            NotificationService().showDownloadedNotification(
                                ref
                                    .read(uniqueIdNotificationProvider.notifier)
                                    .update((state) => state + 1),
                                path,
                                " PDF Report",
                                " File Downloaded Location : $path");

                            var dwnsnack =
                                authsnackbar("PDF Downloaded", context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(dwnsnack);
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                          debugPrint(
                              " pdf selected$selectedValue");
                          selectedValue = "select";
                          setState(() {});

                          Navigator.of(context).pop();
                          await showAlertOpenDialog(context);
                        }
                      }
                    },
                    //return true when click on "Yes"
                    child: const Text('Yes'),
                  ),
                ],
              ));
    }
    ;
  }

  num remittedAmt(
    List<ResultEntity> data,
  ) {
    num sum = 0;
    for (var i = 0; i < data.length; i++) {
      sum += data[i].remittedAmount!.toInt();
    }
    return sum;
  }

  num collectedAmt(
    List<ResultEntity> data,
  ) {
    num sum = 0;
    for (var i = 0; i < data.length; i++) {
      sum += data[i].collectedAmount!;
    }
    return sum;
  }

  Future<File> writeToFile(List<int>? data, String path) async {
    String date = DateTime.now()
        .toString()
        .replaceAll(".", "")
        .replaceAll(":", "")
        .replaceAll(" ", "_");
    File files = File("$path/ExcelReport$date.xlsx");
    try {
      files.open(mode: FileMode.writeOnly);
      return await files.writeAsBytes(data!);
    } catch (e) {
      debugPrint(e.toString());
    }
    return File(path);
  }

  List<ResultEntity> resultdata = [];
  List<ResultEntity>? filedata = [];
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<ResultEntity> printData = [];
  @override
  Widget build(BuildContext context) {
    final reportData = ref.watch(collectionListProvider1);
    Size size = MediaQuery.of(context).size;
    return generalsession(
      ref: ref,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Collection Summary Report ",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
            toolbarHeight: size.height * 0.08,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ])),
            ),
          ),
          body: SingleChildScrollView(
              child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(children: [
              SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(Apppadding.p10),
                  child: TextFormField(
                    controller: dateinputStartController,
                    validator: (value) {
                      if (dateinputEndController.text.isEmpty) {
                        return "Please select the Date Range";
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () {
                            _pickDateFunction();
                          },
                        ),
                        labelText: "From Date (dd/mm/yyyy)",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).colorScheme.primary)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color:
                                    Theme.of(context).colorScheme.secondary))),
                    readOnly: true,
                    onTap: () async {
                      _pickDateFunction();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.005,
              ),
              SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(AppMargin.m10),
                  child: TextFormField(
                    validator: (value) {
                      if (dateinputEndController.text.isEmpty) {
                        return "Please select the Date Range";
                      } else
                        return null;
                    },
                    controller: dateinputEndController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () {
                            _pickDateFunction();
                          },
                        ),
                        labelText: "From Date (dd/mm/yyyy)",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).colorScheme.primary)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color:
                                    Theme.of(context).colorScheme.secondary))),
                    readOnly: true,
                  ),
                ),
              ),
              Divider(
                height: 0,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              Container(
                color: Theme.of(context).colorScheme.surface,
                height: size.height * 0.06,
                child: const Center(
                    child: Text(
                  "View Report",
                  style: TextStyle(fontWeight: FontWeight.w600),
                )),
              ),
              Divider(
                height: 0,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              reportData.when(
                data: (data) {
                  return data.fold((left) => bodyMethod(size, context, []),
                      (right) {
                    printData = right.result!;
                    resultdata = right.result!;
                    filedata = right.result;
                    remittedAmtController.text =
                        remittedAmt(resultdata).toString();
                    collectedAmtController.text =
                        collectedAmt(resultdata).toString();
                    payableAmtController.text =
                        (remittedAmt(resultdata) - collectedAmt(resultdata))
                            .toString();
                    noAcController.text = right.result!.length.toString();
                    brIdController.text = ref.read(brIdProvider);
                    stafNameController.text = ref.read(userIdProvider);
                    return bodyMethod(size, context, resultdata);
                  });
                },
                error: (error, stackTrace) => bodyMethod(size, context, []),
                loading: () => bodyMethod(size, context, []),
              ),
            ]),
          )),
          bottomNavigationBar: printData.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.all(Apppadding.p8),
                  height: size.height * 0.11,
                  width: size.width,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: size.width * 0.4,
                          height: size.width * 0.1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            onPressed: () async {
                              setState(() {
                                if (_formKey.currentState!.validate() &&
                                    printData.isNotEmpty) {}
                                // this._getBluetoots;
                                _showPrintAlertDialog();
                              });
                            },
                            child: Text(
                              "Print",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Export to",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                            ),
                            DropdownButton(
                                isDense: true,
                                value: selectedValue,
                                onChanged: (String? newValue) async {
                                  setState(() {
                                    selectedValue = newValue!;
                                  });

                                  if (selectedValue == "select") {
                                    debugPrint("Select");
                                  } else if (selectedValue == "excel") {
                                    await _showPrintDialog(newValue!);
                                  } else if (selectedValue == "pdf") {
                                    await _showPrintDialog(newValue!);
                                  }
                                },
                                items: dropdownItems)
                          ],
                        )
                      ]),
                )
              : null),
    );
  }

  Container bodyMethod(
      Size size, BuildContext context, List<ResultEntity>? data) {
    return Container(
      height: size.height * 0.55,
      padding: const EdgeInsets.all(AppSize.s10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            customTextField(
                context: context,
                labelText: "Branch",
                controller: brIdController),
            customTextField(
                context: context,
                labelText: "Staf Name",
                controller: stafNameController),
            customTextField(
                context: context,
                labelText: "Collected Amount",
                controller: collectedAmtController),
            customTextField(
                context: context,
                labelText: "Remitted Amount",
                controller: remittedAmtController),
            customTextField(
                context: context,
                labelText: "Payable Amount",
                controller: payableAmtController),
            customTextField(
                context: context,
                labelText: "Nos.A/c Collections",
                controller: noAcController),
          ],
        ),
      ),
    );
  }

  Widget customTextField(
      {required BuildContext context,
      required String labelText,
      required TextEditingController controller}) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Apppadding.p5),
        child: TextField(
          controller: controller, //editing controller of this TextField
          decoration: InputDecoration(
              labelText: labelText,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: Theme.of(context).colorScheme.primary)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.secondary))),
          readOnly: true,
          onTap: () async {},
        ),
      ),
    );
  }
}
