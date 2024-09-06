// ignore_for_file: avoid_unnecessary_containers

import 'dart:io';

import 'package:excel/excel.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '/domain/entity/collction_list_report_res_entity.dart';
import '/feature/provider/auto_logout_provider.dart';
import '/feature/provider/login_provider.dart';
import 'package:timeago/timeago.dart';
import '../../../core/notification_service.dart';
import '../../../core/pdf_utils.dart';
import '../../../core/value_manger.dart';
import '../../provider/collection_list_report_provider.dart';
import '../../provider/network_listener_provider.dart';
import '../common_widgets/common_methods.dart';
// import 'flutter_sam.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() {
    return _MyWidgetState();
  }
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

String dateStart = "";
String dateEnd = "";

class CollectopmListReport extends ConsumerStatefulWidget {
  const CollectopmListReport({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CollectopmListReportState();
}

class _CollectopmListReportState extends ConsumerState<CollectopmListReport> {
  TextEditingController dateinputStartController = TextEditingController();
  TextEditingController dateinputEndController = TextEditingController();
  DateTimeRange? _pickedDate;
  DateTime currentDate = DateTime.now();

  List<CollectionListReportResEntity>? reportResult;

  bool connected = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(
        microseconds: 200,
      ),
      () {
        initClear();
      },
    );
  }

  void initClear() async {
    dateinputStartController.text = '';
    dateinputEndController.text = '';
    ref.read(dateEndtApiProvider.notifier).update((state) => '');
    ref.read(dateStartApiProvider.notifier).update((state) => '');
    // ignore: unused_result
    await ref.refresh(collectionListProvider);
  }

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
//...........................
    if (ref.watch(connectivityStatusProviders) == //zzzz
        ConnectivityStatus.connected) {
      if (_pickedDate != null) {
        dateinputStartController.text =
            DateFormat('dd-MM-yyyy').format(_pickedDate!.start);

        dateinputEndController.text =
            DateFormat('dd-MM-yyyy').format(_pickedDate!.end);

        String formattedDateEndString = DateFormat("yyyy-MM-ddTHH:mm:ss")
            .format(_pickedDate!.end)
            .replaceRange(10, null, "T23:59:59");

        ref.read(dateStartApiProvider.notifier).update((state) =>
            DateFormat("yyyy-MM-ddTHH:mm:ss").format(_pickedDate!.start));

        ref
            .read(dateEndtApiProvider.notifier)
            .update((state) => formattedDateEndString);

        debugPrint(" Start date :${ref.read(dateEndtApiProvider)}");
        debugPrint(" End date : ${ref.read(dateStartApiProvider)} 12345678");
        txtSearch = false;

        ref.refresh(collectionListProvider);
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
                    setState(() {});

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

  Future<void> _showPrintDialog(String newValue) async {
    if (_formKey.currentState!.validate()) {
      await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                content: const Text(
                  'Do you want to download ?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      selectedValue = "select";
                      setState(() {});
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
                          debugPrint("sync selected$selectedValue");
                        } else if (selectedValue == "excel") {
                          var excel = Excel.createExcel();
                          CellStyle cellStyle = CellStyle(
                            bold: true,
                            italic: false,
                            rotation: 0,
                          );
                          var sheet1 = excel['Sheet1'];
                          List<Map<String, dynamic>> data = [];

                          for (var i = 0; i < resultdata.length; i++) {
                            String date = DateFormat('dd-MMM-yyyy hh:mm a')
                                .format(resultdata[i].collectedDate!);

                            data.add(
                              {
                                "Collected Amount":
                                    "Rs.${resultdata[i].collectedAmount}",
                                "Loan Number": resultdata[i].loanNo.toString(),
                                "Borrower Name":
                                    resultdata[i].memberName.toString(),
                                "Remitted Amount":
                                    "Rs.${resultdata[i].remittedAmount}",
                                "Collected Date": date
                              },
                            );
                          }
                          int coli = 0;
                          int rowj = 0;
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
                          // Directory? directory = Platform.isAndroidc
                          //     ? await getExternalStorageDirectory() //FOR ANDROID
                          //     : await getApplicationSupportDirectory();
                          // var path = directory!.path;
                          writeToFile(fileBytes, path);
                          NotificationService().showDownloadedNotification(
                              ref
                                  .read(uniqueIdNotificationProvider.notifier)
                                  .update((state) => state + 1),
                              path,
                              " Excel Collection Report",
                              " File Downloaded Location : $path");
                          debugPrint(" excel selected$selectedValue");
                          debugPrint("Path : $path");
                          var dwnsnack =
                              authsnackbar("Excel File Downloaded", context);
                          ScaffoldMessenger.of(context).showSnackBar(dwnsnack);
                          selectedValue = "select";
                          Navigator.of(context).pop();
                          setState(() {});
                          await showAlertOpenDialog(context);
                        } else if (selectedValue == "pdf") {
                          List<Map<String, dynamic>> data = [];

                          for (var i = 0; i < resultdata.length; i++) {
                            String date = DateFormat('dd-MMM-yyyy hh:mm a')
                                .format(resultdata[i].collectedDate!);
                            data.add(
                              {
                                "Collected Amount":
                                    "Rs.${resultdata[i].collectedAmount}",
                                "Loan Number": resultdata[i].loanNo.toString(),
                                "Borrower Name":
                                    resultdata[i].memberName.toString(),
                                "Remitted Amount":
                                    "Rs.${resultdata[i].remittedAmount}",
                                "Collected Date": date
                              },
                            );
                          }

                          var path = await ExternalPath
                              .getExternalStoragePublicDirectory(
                                  ExternalPath.DIRECTORY_DOWNLOADS);

                          Uint8List fileBytes = await makePdf(
                            data,
                          );
                          String date = DateTime.now()
                              .toString()
                              .replaceAll(".", "")
                              .replaceAll(":", "")
                              .replaceAll(" ", "_");
                          File files = File("$path/PDFReport$date.pdf");
                          try {
                            files.open(mode: FileMode.writeOnly);
                            final buffer = fileBytes.buffer;
                            NotificationService().showDownloadedNotification(
                                ref
                                    .read(uniqueIdNotificationProvider.notifier)
                                    .update((state) => state + 1),
                                path,
                                " PDF Collection Report",
                                " File Downloaded Location : $path");

                            files.writeAsBytes(buffer.asUint8List(
                                fileBytes.offsetInBytes,
                                fileBytes.lengthInBytes));
                            var dwnsnack =
                                authsnackbar("PDF File Downloaded", context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(dwnsnack);
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                          debugPrint(" pdf selected$selectedValue");
                          selectedValue = "select";
                          setState(() {});
                          await showAlertOpenDialog(context);
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ));
    }
    ;
  }

  String selectedValue = "select";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: "select",
        child: Text("Select"),
      ),
      const DropdownMenuItem(
        value: "excel",
        child: Text("EXCEL"),
      ),
      const DropdownMenuItem(
        value: "pdf",
        child: Text("PDF"),
      ),
    ];
    return menuItems;
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

  List<ResultEntity>? searchList = [];

  void filterSearchResults(String query, List<ResultEntity>? data) {
    List<ResultEntity>? dummySearchList = [];
    dummySearchList.addAll(data!);
    if (query.isNotEmpty || query == '') {
      List<ResultEntity>? searchedListData = [];
      dummySearchList.forEach((item) {
        if (item.memberName!.toLowerCase().contains(query.toLowerCase()) ||
            item.loanNo!.toLowerCase().contains(query.toLowerCase())) {
          searchedListData.add(item);
        }
      });
      setState(() {
        searchList!.clear();
        searchList!.addAll(searchedListData);
        // dummySearchList.clear();
        // searchedListData.clear();
      });
      return;
    } else {
      setState(() {
        searchList!.clear();
        searchList!.addAll(data);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchList!.clear();
    resultdata.clear();
  }

  TextEditingController searhController = TextEditingController();
  bool txtSearch = false;
  List<ResultEntity>? filedata = [];
  List<ResultEntity> resultdata = [];
  List<ResultEntity> btmData = [];
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final reportData = ref.watch(collectionListProvider);
    Size size = MediaQuery.of(context).size;
    return generalsession(
      ref: ref,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Scaffold(
            appBar: AppBar(
              // actions: [
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => CollectionListRepPage(),
              //           ));
              //     },
              //     child: Text("blt"))
              // ],
              toolbarHeight: size.height * 0.06,
              title: Text(
                "Collection List Report ",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              ),
              centerTitle: false,
              automaticallyImplyLeading: false,
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
              physics: const ClampingScrollPhysics(),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(Apppadding.p10),
                          child: TextFormField(
                            validator: (value) {
                              if (dateinputStartController.text.isEmpty) {
                                return "Please select the Date Range";
                              } else
                                return null;
                            },
                            controller:
                                dateinputStartController, //editing controller of this TextField
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))),
                            readOnly: true,
                            onTap: () async {
                              _pickDateFunction();
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(AppMargin.m10),
                          child: TextFormField(
                            validator: (value) {
                              if (dateinputEndController.text.isEmpty) {
                                return "Please select the Date Range";
                              } else {
                                return null;
                              }
                            },
                            controller: dateinputEndController,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_month),
                                  onPressed: () {
                                    _pickDateFunction();
                                  },
                                ),
                                labelText: "To Date (dd/mm/yyyy)",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))),
                            readOnly: true,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
                Divider(
                  height: 0,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                reportData.when(
                  data: (data) {
                    return data.fold((left) {
                      debugPrint("Left error : ${left.message}");
                      return SizedBox(
                        height: size.height * 0.6,
                        child: const Center(
                            child: Text(
                          'Select date range to get list',
                          style: TextStyle(fontSize: 16),
                        )),
                      );
                    }, (right) {
                      resultdata = txtSearch ? searchList! : right.result!;
                      filedata = right.result;
                      btmData = right.result!;
                      return Column(
                        children: [
                          txtSearch
                              ? Center(
                                  child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      filterSearchResults(value, right.result);
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: const Icon(
                                            Icons.search,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            txtSearch = false;

                                            filterSearchResults('', filedata);
                                            setState(() {});
                                          },
                                        ),
                                        alignLabelWithHint: true,
                                        hintText: "View Report",
                                        // labelText: "View Report",
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: Colors.greenAccent),
                                        )),
                                  ),
                                ))
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Apppadding.p8),
                                  height: size.height * 0.08,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Apppadding.p8),
                                      height: size.height * 0.04,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(),
                                            const Text(
                                              "View Report",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            GestureDetector(
                                              child: const Icon(Icons.search),
                                              onTap: () {
                                                txtSearch = true;
                                                setState(() {});
                                              },
                                            )
                                          ]))),
                          Divider(
                            height: 0,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                          Container(
                              padding: const EdgeInsets.all(Apppadding.p5),
                              height: size.height * 0.62,
                              width: size.width,
                              child: ScrollConfiguration(
                                behavior: const ScrollBehavior(),
                                child: GlowingOverscrollIndicator(
                                  axisDirection: AxisDirection.down,
                                  color: Colors.green,
                                  child: resultdata.isEmpty
                                      ? Container(
                                          child: const Center(
                                              child: Text(
                                                  "No Data Available For This Date")),
                                        )
                                      : ListView.builder(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          padding:
                                              const EdgeInsets.only(bottom: 30),
                                          itemCount: resultdata.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      child: SizedBox(
                                                        height:
                                                            size.height * 0.42,
                                                        width: size.width * 1,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSecondary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                            colors: [
                                                                          Theme.of(context)
                                                                              .colorScheme
                                                                              .primary,
                                                                          Theme.of(context)
                                                                              .colorScheme
                                                                              .onTertiary
                                                                        ]),
                                                                    borderRadius: const BorderRadius
                                                                        .only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                10),
                                                                        topRight:
                                                                            Radius.circular(10))),
                                                                height: 30,
                                                                width:
                                                                    size.width *
                                                                        0.8,
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(),
                                                                    const Text(
                                                                        "     View"),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    left:
                                                                        Apppadding
                                                                            .p8,
                                                                    right:
                                                                        Apppadding
                                                                            .p8,
                                                                    bottom:
                                                                        101),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                        "REPCO MICRO FINANCE LIMITED",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleMedium!
                                                                            .copyWith(fontWeight: FontWeight.w600)),
                                                                    Row(
                                                                      children: [
                                                                        const Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Text("Branch")),
                                                                        Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Text(
                                                                              "Branch ${ref.read(brIdProvider)}",
                                                                            ))
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Text("ReceiptNo")),
                                                                        Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Text(
                                                                              resultdata[index].receiptNo.toString().replaceAll("/", ''),
                                                                            ))
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Text("Group ID")),
                                                                        Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Text(
                                                                              resultdata[index].groupId.toString(),
                                                                            ))
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Text("Group Name")),
                                                                        Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Text(
                                                                              resultdata[index].groupName.toString(),
                                                                            ))
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Text("Loan No")),
                                                                        Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Text(
                                                                              resultdata[index].loanNo.toString(),
                                                                            ))
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Text("Name")),
                                                                        Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Text(
                                                                              resultdata[index].memberName.toString(),
                                                                            ))
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Text("Collected Amt")),
                                                                        Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Text(
                                                                              "Rs.${resultdata[index].collectedAmount}",
                                                                            ))
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Text("Date")),
                                                                        Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Text(
                                                                              DateFormat('dd-MMM-yyyy hh:mm a').format(resultdata[index].collectedDate!),
                                                                            ))
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Text("Collected By")),
                                                                        Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                Text(ref.read(userIdProvider)))
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: AppMargin.m14),
                                                padding: const EdgeInsets.only(
                                                    left: Apppadding.p8),
                                                decoration: BoxDecoration(
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //       color:
                                                  //           Color.fromARGB(255, 196, 196, 196), //New
                                                  //       blurRadius: 25.0,
                                                  //       offset: Offset(0, 25))
                                                  // ],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                height: 120,
                                                width: size.width,
                                                child: Material(
                                                  color: Colors.white,
                                                  elevation: 20,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: Apppadding.p5,
                                                            bottom:
                                                                Apppadding.p5,
                                                            left:
                                                                Apppadding.p5),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Name of Borrower",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.grey),
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                    resultdata[
                                                                            index]
                                                                        .memberName
                                                                        .toString(),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Collected Amount",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.grey),
                                                                ),
                                                                Text(
                                                                  resultdata[
                                                                          index]
                                                                      .collectedAmount
                                                                      .toString(),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium,
                                                                ),
                                                                Text(
                                                                  "Collected Date",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.grey),
                                                                ),
                                                                Text(
                                                                  DateFormat(
                                                                          'dd-MMM-yyyy hh:mm a')
                                                                      .format(resultdata[
                                                                              index]
                                                                          .collectedDate!),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              12),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Loan No",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.grey),
                                                                ),
                                                                Text(
                                                                  resultdata[
                                                                          index]
                                                                      .loanNo
                                                                      .toString(),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium,
                                                                ),
                                                                Text(
                                                                  "Remitted Amount",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.grey),
                                                                ),
                                                                Text(
                                                                  resultdata[
                                                                          index]
                                                                      .remittedAmount
                                                                      .toString(),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium,
                                                                ),
                                                                Text(
                                                                  "TAT",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.grey),
                                                                ),
                                                                Text(
                                                                  format(
                                                                    resultdata[
                                                                            index]
                                                                        .collectedDate!,
                                                                  ),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              )),
                        ],
                      );
                    });
                  },
                  error: (error, stackTrace) {
                    debugPrint("Error : ${error.toString}");
                    return const Center(
                        child: Text('Select data range to get list'));
                  },
                  loading: () => SizedBox(
                      height: size.height * 05,
                      child: const Center(
                          child: CircularProgressIndicator.adaptive())),
                )
              ]),
            ),
            bottomNavigationBar: btmData.isNotEmpty
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
                            child: AbsorbPointer(
                              child: ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: Text(
                                  "Print",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer),
                                ),
                              ),
                            ),
                          ),
                          Column(
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
                                      debugPrint("sync selected$selectedValue");
                                    } else if (selectedValue == "excel") {
                                      _showPrintDialog(newValue!);
                                    } else if (selectedValue == "pdf") {
                                      _showPrintDialog(newValue!);
                                    }
                                  },
                                  items: dropdownItems)
                            ],
                          )
                        ]),
                  )
                : null),
      ),
    );
  }
}
