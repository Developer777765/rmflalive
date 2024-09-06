import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menthee_flutter_project/data/datasource/loacal_database/money_collection_datasource.dart';
import '../../provider/collection_list_report_provider.dart';
import '../splash/splash_screen.dart';
import '/core/imin_printer/imin_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '/core/router.dart';
import '/core/string_manger.dart';
import '/data/datasource/loacal_database/sql_helper_repco.dart';
import '/data/model/receipt_table_model.dart';
import '/feature/page/common_widgets/common_methods.dart';
import '/feature/provider/login_provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/sunmi_printer_utils.dart/sunmi_printer2.dart';
import '../../../core/value_manger.dart';
import '../../../data/model/remitted_screen_model.dart';
import '../../../domain/entity/loan_collection_res_entity.dart';
import '../../../domain/entity/save_loan_amt_req_entity.dart';
import '../../../domain/usecase/sql_helper_usecase.dart';
import '../../provider/auto_logout_provider.dart';
import '../../provider/loan_collection_response_provider.dart';
import '../../provider/network_listener_provider.dart';
import '../../provider/save_ln_amt_provider.dart';
import '../non_remitted_collection/non_remitted_collection.dart';

final recieptNoProvider = StateProvider<List<String>>((ref) {
  return [];
});

// ignore: must_be_immutable
class LoanCollectionScreen extends ConsumerStatefulWidget {
  LoanCollectionScreen({required this.groupbyData});
  ResultEntity groupbyData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoanCollectionScreenState();
}

class _LoanCollectionScreenState extends ConsumerState<LoanCollectionScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSubmit = false;
  bool isSave = false;
  bool isPrint = false;
  List loanNo = [];
  var collectedRecord = [];
  @override
  void initState() {
    super.initState();

    _refreshdb();
    Future.delayed(
      const Duration(
        microseconds: 0,
      ),
      () {
        initClear();
      },
    );
  }

  initClear() async {
    ref.read(dateStartApiProvider.notifier).update((state) =>
        DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day, 00, 00, 00)));
    ref.read(dateEndtApiProvider.notifier).update(
        (state) => DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now()));
    ref.refresh(collectionListProvider);
    // setState(() {});
  }

  Future<void> _refreshdb() async {
    final res = await ref.read(loanCollectionProvider.notifier);
    if (ref.read(connectivityStatusProviders) == ConnectivityStatus.connected) {
      await ref.read(loanCollectionListProvider).fold((left) => null,
          (right) async {
        debugPrint("Response : ${right.result}");
        // res.insertLoanDB(right.result);
        final res = ref.read(moneyCollectionDataSourceProvider);
        await res.insertDataToDb(right.result);
      });
      await res
          .readLoanListByGroupID(widget.groupbyData.groupCode!)
          .then((value) {
        data = value;
        setState(() {});
      });
    } else if (ref.read(connectivityStatusProviders) ==
        ConnectivityStatus.disconnected) {
      await res
          .readLoanListByGroupID(widget.groupbyData.groupCode!)
          .then((value) {
        data = value;
        setState(() {});
      });
    }
  }

  List<ResultEntity> data = [];

  late var controllers =
      List.generate(data.length, (index) => TextEditingController());
  final formKey = GlobalKey<FormState>();

  int totalAmt = 0;

  void sumAmt(List<TextEditingController> lstTxtCtlr) {
    if (formKey.currentState!.validate()) {
      totalAmt = 0;

      for (var i = 0; i < lstTxtCtlr.length; i++) {
        controllers[i].selection = TextSelection.fromPosition(
            TextPosition(offset: controllers[i].text.length));
        if (lstTxtCtlr[i].text != '') {
          totalAmt += int.parse(lstTxtCtlr[i].text);
        }
      }
    }
  }

  Future<void> _showPrintAlertDialog({List<LoanAmountlist>? printList}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Are you sure want to print receipt ?',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                GoRouter.of(context)
                    .pushReplacementNamed(Routes.loanCollection);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: isPrint
                  ? null
                  : () async {
                      setState(() {
                        isPrint = !isPrint;
                      });
                      var posPrint = ref.read(deviceModelProvider)
                          ? Sunmi2()
                          : IminUtils();

                      if (posPrint is Sunmi2) {
                        Sunmi2 sunmi2Printer = posPrint;
                        for (var i = 0; i < printList!.length; i++) {
                          await sunmi2Printer.printReceiptMoneyCollection(
                              branch: ref.watch(brNameProvider),
                              receiptNo: printList[i]
                                  .receiptNo!
                                  .toString()
                                  .replaceAll("/", ""),
                              groupId: printList[i].groupId!,
                              groupName: printList[i].groupName!,
                              loanNo: printList[i].loanNo!,
                              name: printList[i].memName!,
                              collectedAmt: printList[i]
                                  .collectedAmt!
                                  .toDouble()
                                  .toString(),
                              date: DateFormat('dd-MMM-yyyy hh:mm a').format(
                                  DateTime.parse(printList[i].collectedDate!)),
                              collectedBy:
                                  ref.read(userIdProvider)[0].toUpperCase() +
                                      ref.read(userIdProvider).substring(1));
                        }
                        GoRouter.of(context)
                            .pushReplacementNamed(Routes.loanCollection);
                      } else if (posPrint is IminUtils) {
                        IminUtils iminUtilsPrinter = posPrint;
                        for (var i = 0; i < printList!.length; i++) {
                          iminUtilsPrinter.printReceiptMoneyCollection(
                              // branch: printList[i].memName!,
                              branch: ref.watch(brNameProvider),
                              receiptNo: printList[i]
                                  .receiptNo!
                                  .toString()
                                  .replaceAll("/", ""),
                              groupId: printList[i].groupId!,
                              groupName: printList[i].groupName!,
                              loanNo: printList[i].loanNo!,
                              name: printList[i].memName!,
                              collectedAmt: printList[i]
                                  .collectedAmt!
                                  .toDouble()
                                  .toString(),
                              date: DateFormat('dd-MMM-yyyy hh:mm a').format(
                                  DateTime.parse(printList[i].collectedDate!)),
                              collectedBy:
                                  ref.read(userIdProvider)[0].toUpperCase() +
                                      ref.read(userIdProvider).substring(1));
                        }
                        GoRouter.of(context)
                            .pushReplacementNamed(Routes.homeScreen);
                      }

                      // _showtBottomSheet1();
                    },
            ),
          ],
        );
      },
    );
  }

//zzzz
  String seqNo = '';
  Future<void> SummitValueIndex(List<ResultEntity> data,
      List<TextEditingController> lstTxtCtrl, WidgetRef ref) async {
    DateTime now = DateTime.now();
    DateTime thisYear = DateTime(now.year, 1, 1);
    int days = now.difference(thisYear).inDays + 1;
    List<String> loanNo = [];
    String? receiptNoString;
    final loanList = ref.read(lnsavedataProvider.notifier);
    final receiptNoList = ref.read(recieptNoProvider.notifier);

    loanNo.clear();
    loanList.update((state) => []);
    receiptNoList.update((state) => []);

    Future<String> seq() async {
      final kk = await ref.read(sqlHelperUseCaseProvider).getSqlData().mapRight(
          (right) => right.readonlySuffixFromDbReceiptTable(days.toString()));
      kk.fold((left) => debugPrint(left.message), (right) {
        if (right.isEmpty) {
          seqNo = "0001";
          return seqNo;
        } else if (right.length > 0) {
          seqNo =
              (int.parse(right.last.sequence!) + 1).toString().padLeft(4, '0');
        }
      });
      return seqNo;
    }

    loanList.update((state) => state = []);
    for (var i = 0; i < lstTxtCtrl.length; i++) {
      if (lstTxtCtrl[i].text != '') {
        loanNo.add(data[i].lonaNo.toString());
      }
      try {
        await ref
            .read(sqlHelperUseCaseProvider)
            .getSqlData()
            .mapRight((right) async {
          if (loanNo.contains(data[i].lonaNo)) {
            String receipt = await seq();
            return right.insertDataToReceiptDb(ReceiptTable(
                branchId: int.parse(data[i].brId!),
                prefix: int.parse(lstTxtCtrl[i].text),
                sequence: receipt,
                suffix: days));
          }
        });
      } catch (e) {
        debugPrint(e.toString());
      }
      ReceiptTable receiptTable = ReceiptTable();
      await ref
          .read(sqlHelperUseCaseProvider)
          .getSqlData()
          .mapRight((right) => right.readAllDataFromDbReceiptTable())
          .fold((left) => left.message, (right) {
        if (right.length > 0 && loanNo.contains(data[i].lonaNo)) {
          receiptTable.branchId = right.last.branchId;
          receiptTable.prefix = right.last.prefix;
          receiptTable.sequence = seqNo;
          receiptTable.suffix = right.last.suffix;
          receiptNoString =
              "${receiptTable.sequence}/-${ref.read(userIdProvider)}";
          // debugPrint("updated recipt number : $receiptNoString");
          // "${receiptTable.sequence}/${data[i].brId}/${data[i].brId}/${receiptTable.suffix}";
          // "${receiptTable.sequence}/${data[i].brId}/${data[i].prdId}/${receiptTable.suffix}";
// todo
        }
      });

      Remittedldb remittedData = Remittedldb();
      var dateTimeNow = DateTime.now().toString();
      if (loanNo.contains(data[i].lonaNo)) {
        remittedData.brId = data[i].brId;
        remittedData.prId = data[i].prdId;
        remittedData.groupId = data[i].groupCode!;
        remittedData.collectedAmount = int.parse(lstTxtCtrl[i].text);
        remittedData.collectedDate = dateTimeNow;
        remittedData.ReceiptNo = receiptNoString;
        remittedData.groupName = data[i].groupName;
        remittedData.sync = 0;
        remittedData.loanNo = data[i].lonaNo;
        remittedData.loanAmt = data[i].loanAmt.toString();
        remittedData.status = "Collected";
        remittedData.loginId = ref.read(userIdProvider);
        remittedData.memName = data[i].memberName;
        remittedData.newCollectedDate = DateTime.now().toString();
        ref.read(recieptNoProvider.notifier).update((state) {
          state.add(receiptNoString!);
          return state;
        });
        await ref.read(sqlHelperProvider).insertDataToDbRemitted(remittedData);
        loanList.update((state) {
          state.add(LoanAmountlist(
              brId: remittedData.brId,
              prId: remittedData.prId,
              groupId: remittedData.groupId.toString(),
              receiptNo: remittedData.ReceiptNo,
              collectedAmt: remittedData.collectedAmount!.toInt(),
              collectedDate: remittedData.collectedDate,
              createdby: ref.read(userIdProvider),
              groupName: remittedData.groupName,
              lnAmt: double.parse(remittedData.loanAmt!).toInt(),
              loanNo: remittedData.loanNo,
              loginId: remittedData.loginId,
              memName: remittedData.memName,
              status: "Collected"));
          return state;
        });
      }
    }
    await ref.read(saveLnAmtProvider).fold((left) => debugPrint(left.message),
        (right) async {
      if (right.status == AppString.SUCCESS) {
        debugPrint("Response  1 :" "$right");
        await ref
            .read(sqlHelperProvider)
            .updateSyncValueList(ref.read(recieptNoProvider), true);
      } else {
        authsnackbar(right.statusCode, context, 40);
        debugPrint("failed");
      }
    });

    await _showPrintAlertDialog(printList: ref.read(lnsavedataProvider));
  }

  Future<void> _showSummittDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('RMFL Collection',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.w700)),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure want to save ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                setState(() {
                  debugPrint("1 : " + loanNo.length.toString());
                  isSubmit = false;
                  loanNo.clear();
                  debugPrint("1 : " + loanNo.length.toString());
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: isSave
                  ? null
                  : () async {
                      setState(() {
                        isSave = !isSave;
                        totalAmt = 0;
                        sumAmt(controllers);
                        SummitValueIndex(data, controllers, ref);
                      });

                      Navigator.of(context).pop();
                    },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    totalAmt = 0;
  }

  Future<void> _show30tDialog(BuildContext context) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("RMFL Collection",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.w700)),
          content: const Text("Under Moratorium Period"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"))
          ],
        );
      },
    );
  }

  bool checkBox = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var collectedData = ref.watch(collectionListProvider);
    if (collectedData.value != null) {
      collectedData.value!.fold((left) => null, (right) {
        collectedRecord = right.result!;
      });
    }
    return Form(
      key: formKey,
      child: generalsession(
        ref: ref,
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            toolbarHeight: size.height * 0.06,
            automaticallyImplyLeading: false,
            title: Text("Loan Collection",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white)),
            centerTitle: false,
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
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 3),
                      padding: const EdgeInsets.only(left: Apppadding.p10),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 0.5),
                              right: BorderSide(width: 0.5))),
                      height: size.height * 0.06,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              "Group name",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              widget.groupbyData.groupName!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: size.height * 0.06,
                    color: Colors.black,
                    width: 0.5,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 3),
                      padding: const EdgeInsets.only(left: Apppadding.p10),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 0.5),
                              right: BorderSide(width: 0.5))),
                      height: size.height * 0.06,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              "Group code",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              widget.groupbyData.groupCode!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: data.isEmpty
                    ? Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 224, 224, 224),
                        highlightColor:
                            const Color.fromARGB(255, 245, 245, 245),
                        enabled: true,
                        child: const SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ContentPlaceholder(
                                lineType: ContentLineType.threeLines,
                              ),
                              SizedBox(height: 13.0),
                              ContentPlaceholder(
                                lineType: ContentLineType.threeLines,
                              ),
                              SizedBox(height: 13.0),
                              ContentPlaceholder(
                                lineType: ContentLineType.threeLines,
                              ),
                              SizedBox(height: 13.0),
                              ContentPlaceholder(
                                lineType: ContentLineType.threeLines,
                              ),
                              SizedBox(height: 13.0),
                              ContentPlaceholder(
                                lineType: ContentLineType.threeLines,
                              ),
                              SizedBox(height: 13.0),
                              ContentPlaceholder(
                                lineType: ContentLineType.threeLines,
                              ),
                              ContentPlaceholder(
                                lineType: ContentLineType.threeLines,
                              ),
                              SizedBox(height: 13.0),
                              ContentPlaceholder(
                                lineType: ContentLineType.threeLines,
                              ),
                              SizedBox(height: 13.0),
                            ],
                          ),
                        ))
                    : ScrollConfiguration(
                        behavior: const ScrollBehavior(),
                        child: GlowingOverscrollIndicator(
                          showTrailing: true,
                          axisDirection: AxisDirection.down,
                          color: Colors.green,
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: const EdgeInsets.only(bottom: 120),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.symmetric(
                                    vertical: AppMargin.m10,
                                    horizontal: AppMargin.m10),
                                padding: const EdgeInsets.only(
                                  left: Apppadding.p8,
                                ),
                                height: size.height * 0.20,
                                width: size.width,
                                child: Material(
                                  elevation: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: Apppadding.p8,
                                        top: Apppadding.p10,
                                        right: Apppadding.p10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                data[index].memberName!,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                              ),
                                            ),
                                            Text(
                                              data[index].lonaNo!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "EMI",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                ),
                                                Text(
                                                  data[index]
                                                      .emiAmt!
                                                      .toStringAsFixed(2),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Loan O/S",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                ),
                                                Text(
                                                  data[index]
                                                      .loanOs!
                                                      .toStringAsFixed(2),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Over Due",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                ),
                                                Text(
                                                  data[index]
                                                      .loanOverdue!
                                                      .toStringAsFixed(0),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: SizedBox(
                                              width: size.width * 0.8,
                                              child: Focus(
                                                onFocusChange: (value) {
                                                  if (!value) {
                                                    if (int.parse(
                                                            controllers[index]
                                                                .text) <
                                                        50) {
                                                      controllers[index].text =
                                                          '';
                                                    }
                                                  }
                                                },
                                                child: TextFormField(
                                                  autofocus: false,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  validator: (value) {
                                                    // validator: (value) {
                                                    if (collectedRecord
                                                            .where((element) =>
                                                                element.loanNo!
                                                                    .toLowerCase() ==
                                                                data[index]
                                                                    .lonaNo!
                                                                    .toLowerCase())
                                                            .isNotEmpty &&
                                                        controllers[index]
                                                                .text !=
                                                            "") {
                                                      return "Amount is Already collected for this Account";
                                                    }
                                                    if (controllers[index]
                                                            .text ==
                                                        '') {
                                                      return null;
                                                    } // _formKey.currentState!.validate();
                                                    else if (double.parse(
                                                            controllers[index]
                                                                .text) <
                                                        50) {
                                                      return "Minimum Amount Rs.50";
                                                    } else if (double.parse(
                                                            controllers[index]
                                                                .text) >
                                                        data[index].loanOs!) {
                                                      return "Amount is higher than LoanO/S";
                                                    } else if (double.parse(
                                                            controllers[index]
                                                                .text) >
                                                        data[index].emiAmt! *
                                                            10) {
                                                      return "Amount collected exceeds 10 times of EMI";
                                                    }
                                                    //todo
                                                    // else if(double.parse(controllers[index]
                                                    //           .text) != 0 || double.parse(controllers[index]
                                                    //           .text) > data[index].loanOverdue! ){
                                                    //             return "Amount exceeds loan overdue";
                                                    //           }
                                                    // else if(double.parse(controllers[index]
                                                    //             .text) > data[index].loanOverdue!){
                                                    //               return "Amount exceeds loan overdue";
                                                    //             }
                                                    return null;
                                                  },
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9]')),
                                                  ],
                                                  onChanged: (String value) {
                                                    // controllers[index].text = value;
                                                    if (collectedRecord
                                                        .where((element) =>
                                                            element.loanNo!
                                                                .toLowerCase() ==
                                                            data[index]
                                                                .lonaNo!
                                                                .toLowerCase())
                                                        .isNotEmpty) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .clearSnackBars();
                                                      var errorSnack = authsnackbar(
                                                          "Amount is collected for this Account Today",
                                                          context,
                                                          50);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              errorSnack);
                                                    }

                                                    DateTime startDate =
                                                        DateTime.parse(
                                                            data[index]
                                                                .openingDt!);
                                                    DateTime endDate =
                                                        DateTime.parse(
                                                            data[index]
                                                                .businessDate!);

                                                    if (endDate
                                                            .difference(
                                                                startDate)
                                                            .inDays <
                                                        30) {
                                                      debugPrint(
                                                          "Under Moratorium days :${endDate.difference(startDate)}");
                                                      value = "";
                                                      debugPrint(
                                                          "Under Moratorium Period");
                                                      debugPrint(value);
                                                      _show30tDialog(context);
                                                    } else {
                                                      debugPrint(
                                                          " Not Under Moratorium Period");
                                                    }
                                                    sumAmt(controllers);

                                                    if (double.parse(
                                                            controllers[index]
                                                                .text) >
                                                        data[index].loanOs!) {
                                                      // controllers[index].text =
                                                      //     '';
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              authsnackbar(
                                                                  "Amount is higher than LoanO/S",
                                                                  context,
                                                                  50));

                                                      setState(() {});
                                                    } else if (double.parse(
                                                            controllers[index]
                                                                .text) >
                                                        data[index].emiAmt! *
                                                            10) {
                                                      // controllers[index].text =
                                                      //     '';
                                                      var _errorSnack =
                                                          authsnackbar(
                                                              "Amount collected exceeds 10 times of EMI",
                                                              context,
                                                              50);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              _errorSnack);
                                                      setState(() {});
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      controllers[index],
                                                  decoration:
                                                      const InputDecoration(
                                                          floatingLabelAlignment:
                                                              FloatingLabelAlignment
                                                                  .center,
                                                          label: Text(
                                                            'Enter Amount',
                                                            // style: Theme.of(context)
                                                            //     .textTheme
                                                            //     .titleMedium,
                                                          ),
                                                          enabledBorder:
                                                              UnderlineInputBorder()),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              )
            ]),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(
                left: Apppadding.p5, right: Apppadding.p10),
            height: size.height * 0.14,
            width: size.width,
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AbsorbPointer(
                              child: Checkbox(
                                checkColor: Colors.grey,
                                value: checkBox,
                                onChanged: (value) {
                                  checkBox = !checkBox;
                                  setState(() {});
                                },
                              ),
                            ),
                            const Flexible(
                                child: Text(
                              "Send SMS",
                              style: TextStyle(color: Colors.grey),
                              maxLines: 1,
                            )),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: size.width * 0.13),
                        child: Row(
                          children: [
                            const Text("Total : "),
                            Text("₹$totalAmt")
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 35,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: isSubmit
                              ? null
                              : () async {
                                  loanNo.clear();

                                  await Future.delayed(
                                    const Duration(microseconds: 0),
                                    () {
                                      for (var i = 0;
                                          i < controllers.length;
                                          i++) {
                                        if (controllers[i].text != '') {
                                          setState(() {
                                            isSubmit = true;
                                          });
                                          // debugPrint("opening date : ${data[i].openingDt!}");
                                          loanNo.add(data[i].lonaNo.toString());
                                        }
                                      }
                                    },
                                  );

                                  if (loanNo.isNotEmpty) {
                                    if (formKey.currentState!.validate()) {
                                      _showSummittDialog();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    }
                                  } else if (loanNo.isEmpty) {
                                    isSubmit = false;
                                    var errorSnack = authsnackbar(
                                        "Please enter the amount", context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(errorSnack);
                                  }
                                },
                          child: Text(
                            "Submit",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                          ),
                          style: ElevatedButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitlePlaceholder extends StatelessWidget {
  final double width;

  const TitlePlaceholder({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: 12.0,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          const SizedBox(height: 8.0),
          Container(
            width: width,
            height: 12.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

enum ContentLineType {
  twoLines,
  threeLines,
}

class ContentPlaceholder extends StatelessWidget {
  final ContentLineType lineType;

  const ContentPlaceholder({
    Key? key,
    required this.lineType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: const Color.fromARGB(255, 15, 145, 4),
                  margin: const EdgeInsets.only(bottom: 12.0),
                ),
                if (lineType == ContentLineType.threeLines)
                  Container(
                    width: double.infinity,
                    height: 10.0,
                    color: const Color.fromARGB(255, 15, 145, 4),
                    margin: const EdgeInsets.only(bottom: 12.0),
                  ),
                Container(
                  width: 100.0,
                  height: 10.0,
                  color: const Color.fromARGB(255, 15, 145, 4),
                  margin: const EdgeInsets.only(bottom: 12.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
