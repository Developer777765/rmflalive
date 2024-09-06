import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:menthee_flutter_project/feature/page/splash/splash_screen.dart';
import '../../../core/imin_printer/imin_utils.dart';
import '/domain/entity/save_loan_amt_req_entity.dart';
import '../../../core/string_manger.dart';
import '../../../core/sunmi_printer_utils.dart/sunmi_printer2.dart';
import '../../../core/value_manger.dart';
import '../../../data/datasource/loacal_database/sql_helper_repco.dart';
import '../../../data/model/remitted_screen_model.dart';
import '../../../domain/usecase/sql_helper_usecase.dart';
import '../../provider/auto_logout_provider.dart';
import '../../provider/check_collection_list_status_provider.dart';
import '../../provider/login_provider.dart';
import '../../provider/save_ln_amt_provider.dart';
import '../loan_collection/loan_collection_group_screen.dart';
import 'date_time_state.dart';

final lnsavedataProvider = StateProvider<List<LoanAmountlist>>((ref) {
  return [];
});

class NonRemittedCollectionScreen extends ConsumerStatefulWidget {
  const NonRemittedCollectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NonRemittedCollectionScreenState();
}

class _NonRemittedCollectionScreenState
    extends ConsumerState<NonRemittedCollectionScreen> {
  List<Remittedldb> _data = [];
  DateTime? lastRemittedDate;
  bool _isPageLoading = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () async {
      _isPageLoading = true;
      _data.clear();
      setState(() {});
      await unsyncDataUpdate();
      await updateCollectedList();
      await getRemittedlb(ref);
      _isPageLoading = false;
      setState(() {});
    });
    super.initState();
  }

  Future<void> getRemittedlb(WidgetRef ref) async {
    _data = await ref.watch(sqlHelperProvider).getDataByStatusListAndIds(
        ["Collected"], ref.read(userIdProvider), ref.read(brIdProvider));
  }

  Future<void> updateCollectedList() async {
    final reciepNoList = ref.read(receiptNoListProvider.notifier);
    reciepNoList.update((state) => []);
    await ref
        .read(sqlHelperUseCaseProvider)
        .getSqlData()
        .mapRight((right1) async {
      var getData = await right1.getDataByStatusListAndIds(
          ["Collected", "Remitted"],
          ref.read(userIdProvider),
          ref.read(brIdProvider));

      for (var i = 0; i < getData.length; i++) {
        reciepNoList.update((state) {
          state.add(getData[i].ReceiptNo);
          return state;
        });
      }

      await ref
          .read(collectionListStatusResProvider)
          .fold((left) => debugPrint(left.message), (right) async {
        for (var i = 0; i < right.result.checkStatusLists.length; i++) {
          if (right.result.checkStatusLists[i].status == "Approved" ||
              right.result.checkStatusLists[i].status == "Remitted") {
            await ref.read(sqlHelperProvider).updateCollectedStatus(
                right.result.checkStatusLists[i].receiptNo,
                right.result.checkStatusLists[i].status);
          } else if (right.result.checkStatusLists[i].status == "Collected") {
            ref.read(sqlHelperProvider).updateCollectedStatus(
                right.result.checkStatusLists[i].receiptNo,
                right.result.checkStatusLists[i].status);
          }
        }
        lastRemittedDate = right.result.lastRemitDate;
        getData = await right1.getDataByStatusListAndIds(
            ["Collected", "Remitted"],
            ref.read(userIdProvider),
            ref.read(brIdProvider));
        // setState(() {});
        right.status;
      });
    });
  }

  Future<void> unsyncData() async {
    final ss = await ref.read(sqlHelperProvider).getUnsyncedData(0);
    await ref.read(badgeCountProvider.notifier).update((state) => ss.length);
  }

  Future<void> unsyncDataUpdate() async {
    final ss = await ref.read(sqlHelperProvider).getUnsyncedData(0);
    debugPrint("Unsync data length  : ${ss.length}");
    if (ss.length > 0) {
      for (var i = 0; i < ss.length; i++) {
        await ref.read(lnsavedataProvider.notifier).update((state) => []);
        await ref.read(lnsavedataProvider.notifier).update((state) {
          state.add(LoanAmountlist(
            prId: ss[i].prId,
              brId: ss[i].brId,
              groupId: ss[i].groupId.toString(),
              receiptNo: ss[i].ReceiptNo,
              collectedAmt: ss[i].collectedAmount!.toInt(),
              collectedDate: ss[i].collectedDate!,
              createdby: ref.read(userIdProvider),
              groupName: ss[i].groupName.toString(),
              lnAmt: double.parse(ss[i].loanAmt!).toInt(),
              loanNo: ss[i].loanNo!,
              loginId: ss[i].loginId,
              memName: ss[i].memName!,
              status: ss[i].status));
          return state;
        });

        await ref.read(saveLnAmtProvider).fold((left) => debugPrint(left.message),
            (right) async {
          if (right.status == AppString.SUCCESS) {
            await ref
                .read(sqlHelperProvider)
                .updateSyncValue(ss[i].ReceiptNo, true);
          }
          return right.result;
        });
      }

      unsyncData();
    }
  }

  Future<void> _showPrintAlertDialog(
      {required String branch,
      required String receiptNo,
      required String groupId,
      required String groupName,
      required String loanNo,
      required String name,
      required String collectedAmt,
      required String date,
      required String collectedBy}) async {
    final printerBrand = ref.read(deviceModelProvider);
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                var posPrint = printerBrand ? Sunmi2() : IminUtils();

                if (posPrint is Sunmi2) {
                  Sunmi2 sunmi2Printer = posPrint;
                  await sunmi2Printer.printReceiptNonRemitted(
                    branch: ref.watch(brNameProvider),
                    receiptNo: receiptNo,
                    groupId: groupId,
                    groupName: groupName,
                    loanNo: loanNo,
                    name: name.toUpperCase(),
                    collectedAmt: collectedAmt,
                    date: date,
                    collectedBy: collectedBy,
                  );
                } else if (posPrint is IminUtils) {
                  IminUtils iminUtilsPrinter = posPrint;
                  await iminUtilsPrinter.printReceiptNonRemitted(
                    branch: ref.watch(brNameProvider),
                    receiptNo: receiptNo,
                    groupId: groupId,
                    groupName: groupName.toUpperCase(),
                    loanNo: loanNo,
                    name: name.toUpperCase(),
                    collectedAmt: collectedAmt,
                    date: date,
                    collectedBy: collectedBy,
                  );
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPrintAlertDialogList({List<Remittedldb>? printList}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Are you sure want to print receipt ?',
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.pop(context);
                var posPrint =
                    ref.read(deviceModelProvider) ? Sunmi2() : IminUtils();

                if (posPrint is Sunmi2) {
                  Sunmi2 sunmi2Printer = posPrint;
                  for (var i = 0; i < printList!.length; i++) {
                    await sunmi2Printer.printReceiptNonRemitted(
                        branch: ref.watch(brNameProvider),
                        receiptNo: printList[i].brId!,
                        groupId: printList[i]
                            .ReceiptNo
                            .toString()
                            .replaceAll("/", ""),
                        groupName: printList[i].groupName!,
                        loanNo: printList[i].loanNo!,
                        name: printList[i].memName!.toUpperCase(),
                        collectedAmt:
                            printList[i].collectedAmount!.toDouble().toString(),
                        date: DateFormat('dd-MMM-yyyy hh:mm a').format(
                          DateTime.parse(printList[i].newCollectedDate!),
                        ),
                        collectedBy: ref.read(userIdProvider)[0].toUpperCase() +
                            ref.read(userIdProvider).substring(1));
                  }
                } else if (posPrint is IminUtils) {
                  IminUtils iminUtilsPrinter = posPrint;
                  for (var i = 0; i < printList!.length; i++) {
                    await iminUtilsPrinter.printReceiptNonRemitted(
                        branch: ref.watch(brNameProvider),
                        receiptNo: printList[i].brId!,
                        groupId: printList[i]
                            .ReceiptNo
                            .toString()
                            .replaceAll("/", ""),
                        groupName: printList[i].groupName!,
                        loanNo: printList[i].loanNo!,
                        name: printList[i].memName!.toUpperCase(),
                        collectedAmt:
                            printList[i].collectedAmount!.toDouble().toString(),
                        date: DateFormat('dd-MMM-yyyy hh:mm a').format(
                          DateTime.parse(printList[i].newCollectedDate!),
                        ),
                        collectedBy: ref.read(userIdProvider)[0].toUpperCase() +
                            ref.read(userIdProvider).substring(1));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateTimeNow = ref.watch(currentDateTimeProvider);
    getRemittedlb(ref);
    Size size = MediaQuery.of(context).size;
    return generalsession(
      ref: ref,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Non Remitted Collection",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),
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
        body: _isPageLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: Apppadding.p10, horizontal: Apppadding.p8),
                  child: Column(
                    children: [
                      lastRemittedDate == null
                          ? Container()
                          : Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: size.width * 0.10,
                                    child: const Text("Last Remitted  Date"),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: size.width * 0.10,
                                    child: Text(
                                        DateFormat('dd-MM-yyyy  hh:mm:ss a')
                                            .format(lastRemittedDate!)),
                                  ),
                                )
                              ],
                            ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: size.width * 0.10,
                              child: const Text("Current Date"),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: size.width * 0.10,
                              child: Text(DateFormat('dd-MM-yyyy  hh:mm:ss a')
                                  .format(dateTimeNow)),
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: size.width,
                        height: 1,
                        color: Colors.black87,
                      ),
                      SizedBox(
                          height: size.height * 0.71,
                          width: size.width,
                          child: (_data.isEmpty && _isPageLoading == false)
                              ? const Center(
                                  child: Text(
                                    "No Records Found...",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                )
                              : ScrollConfiguration(
                                  behavior: const ScrollBehavior(),
                                  child: GlowingOverscrollIndicator(
                                    axisDirection: AxisDirection.down,
                                    color: Colors.green,
                                    child: ListView.builder(
                                        padding: const EdgeInsets.only(bottom: 30),
                                        itemCount: _data.length,
                                        itemBuilder: (context, index) {
                                          return _data.isEmpty
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Container(
                                                  margin: const EdgeInsets.symmetric(
                                                      vertical: AppMargin.m10,
                                                      horizontal: AppMargin.m8),
                                                  padding: const EdgeInsets.only(
                                                      left: Apppadding.p8),
                                                  height: 80,
                                                  width: size.width,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Material(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: Apppadding.p5),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 4,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                      TextSpan(
                                                                          text:
                                                                              "Receipt No :",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(color: Colors.grey)),
                                                                      TextSpan(
                                                                          text: _data[index].ReceiptNo.toString().replaceAll(
                                                                              "/",
                                                                              ""),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(color: Colors.black87)),
                                                                    ])),
                                                                RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                      TextSpan(
                                                                          text:
                                                                              "Loan No :",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(color: Colors.grey)),
                                                                      TextSpan(
                                                                          text: _data[index]
                                                                              .loanNo,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(color: Colors.black87)),
                                                                    ])),

                                                                // Text(
                                                                //   'Reciept No',
                                                                //   style: Theme.of(context).textTheme.bodyLarge,
                                                                // ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                      TextSpan(
                                                                          text:
                                                                              "Amount :",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(color: Colors.grey)),
                                                                      TextSpan(
                                                                          text: _data[index]
                                                                              .collectedAmount
                                                                              .toString(),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(color: Colors.black87)),
                                                                    ])),
                                                                RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                      TextSpan(
                                                                          text:
                                                                              "Status :",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(color: Colors.grey)),
                                                                      TextSpan(
                                                                          text: _data[index].sync == 1
                                                                              ? "Online"
                                                                              : "Offline",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(color: Colors.black87)),
                                                                    ])),
                                                              ],
                                                            ),
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  barrierDismissible:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      actionsAlignment:
                                                                          MainAxisAlignment.end,
                                                                      actionsPadding:
                                                                          EdgeInsets.zero,
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: const Text("Cancel")),
                                                                        TextButton(
                                                                            onPressed: () async {
                                                                              Navigator.pop(context);
                                                                              await _showPrintAlertDialog(branch: _data[index].brId.toString(), groupId: _data[index].groupId.toString(), date: DateFormat('dd-MMM-yyyy hh:mm a').format(DateTime.parse(_data[index].newCollectedDate!)), collectedAmt: _data[index].collectedAmount!.toDouble().toString(), name: _data[index].memName!, groupName: _data[index].groupName!, loanNo: _data[index].loanNo.toString(), receiptNo: _data[index].ReceiptNo.toString().replaceAll("/", ""), collectedBy: ref.read(userIdProvider)[0].toUpperCase() + ref.read(userIdProvider).substring(1));
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: const Text("OK")),
                                                                      ],
                                                                      contentPadding:
                                                                          EdgeInsets.zero,
                                                                      content:
                                                                          SizedBox(
                                                                        height:
                                                                            size.height * 0.42,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                  gradient: LinearGradient(colors: [
                                                                                    Theme.of(context).colorScheme.primary,
                                                                                    Theme.of(context).colorScheme.onTertiary
                                                                                  ]),
                                                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                                                              height: 30,
                                                                              width: size.width * 0.8,
                                                                              // padding: EdgeInsets.only(
                                                                              //     bottom: Apppadding.p5),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Container(),
                                                                                  const Text(
                                                                                    "    Print View",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: const Icon(
                                                                                      Icons.cancel,
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              padding: const EdgeInsets.all(5),
                                                                              child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                                Text("REPCO MICRO FINANCE LIMITED", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
                                                                                Row(
                                                                                  children: [
                                                                                    const Expanded(flex: 2, child: Text("Branch")),
                                                                                    Expanded(
                                                                                        flex: 3,
                                                                                        child: Text(
                                                                                          "Branch ${ref.read(brIdProvider)}",
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    const Expanded(flex: 2, child: Text("ReceiptNo")),
                                                                                    Expanded(
                                                                                        flex: 3,
                                                                                        child: Text(
                                                                                          _data[index].ReceiptNo.toString().replaceAll("/", ''),
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    const Expanded(flex: 2, child: Text("Group ID")),
                                                                                    Expanded(
                                                                                        flex: 3,
                                                                                        child: Text(
                                                                                          _data[index].groupId.toString(),
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    const Expanded(flex: 2, child: Text("Group Name")),
                                                                                    Expanded(
                                                                                        flex: 3,
                                                                                        child: Text(
                                                                                          _data[index].groupName.toString(),
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    const Expanded(flex: 2, child: Text("Loan No")),
                                                                                    Expanded(
                                                                                        flex: 3,
                                                                                        child: Text(
                                                                                          _data[index].loanNo.toString(),
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    const Expanded(flex: 2, child: Text("Name")),
                                                                                    Expanded(
                                                                                        flex: 3,
                                                                                        child: Text(
                                                                                          _data[index].memName.toString(),
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    const Expanded(flex: 2, child: Text("Collected Amt")),
                                                                                    Expanded(
                                                                                        flex: 3,
                                                                                        child: Text(
                                                                                          "Rs.${_data[index].collectedAmount}",
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    const Expanded(flex: 2, child: Text("Collected By")),
                                                                                    Expanded(flex: 3, child: Text(ref.read(userIdProvider)))
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    const Expanded(flex: 2, child: Text("Date")),
                                                                                    Expanded(
                                                                                        flex: 3,
                                                                                        child: Text(
                                                                                          DateFormat('dd-MMM-yyyy hh:mm a').format(DateTime.parse(_data[index].newCollectedDate!)),
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                              ]),
                                                                            )

                                                                            // Padding(
                                                                            //   padding: const EdgeInsets
                                                                            //           .only(
                                                                            //       bottom:
                                                                            //           8.0,
                                                                            //       right:
                                                                            //           10),
                                                                            //   child:
                                                                            //       ,
                                                                            // ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              icon: Icon(
                                                                Icons.print,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                        }),
                                  ),
                                ))
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: _data.isNotEmpty
            ? Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                height: 60,
                width: size.width,
                child: Center(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor:
                          Theme.of(context).colorScheme.primaryContainer),
                  child: const Text("Print"),
                  onPressed: () async {
                    await _showPrintAlertDialogList(printList: _data);
                  },
                )),
              )
            : null,
      ),
    );
  }
}
