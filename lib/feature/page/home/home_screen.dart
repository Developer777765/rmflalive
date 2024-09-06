import 'dart:async';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/data/datasource/loacal_database/sql_helper_repco.dart';
import '/feature/page/common_widgets/common_methods.dart';
import '/feature/page/unknown/unknown_screen.dart';
import '/feature/provider/auto_logout_provider.dart';
import '/feature/provider/loan_collection_response_provider.dart';
import '/feature/provider/login_provider.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/assets_manager.dart';
import '../../../core/router.dart';
import '../../../core/string_manger.dart';
import '../../../core/value_manger.dart';
import '../../../data/datasource/loacal_database/money_collection_datasource.dart';
import '../../../domain/entity/save_loan_amt_req_entity.dart';
import '../../provider/network_listener_provider.dart';
import '../../provider/save_ln_amt_provider.dart';
import '../loan_collection/loan_collection_group_screen.dart';
import '../login/login_screen.dart';
import '../non_remitted_collection/non_remitted_collection.dart';
import 'home_page_dropdown_state.dart';

enum Options { sync, download, logout }

final isBoolProvider = StateProvider<bool>((ref) {
  return false;
});

final productIdProvider = StateProvider<String>((ref) {
  return "";
});

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isHomeloading = true;

  Future<void> _showUnapprovedAlert(BuildContext context) async {
    //temp change with 'if (ref.read(userAlertProvider) == true)'. section within '' is the original code
    if (ref.read(userAlertProvider) == true) {
      // if (ref.read(userAlertProvider) != true) {
      setState(() {});
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              title: Text(
                "Alert!",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              content: const Text(
                  "You can't continue this application, because your previous collection amounts have not yet been approved. You can only continue this application if your collection is approved."),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      // context.pushReplacement(Routes.loginScreen);
                      (ref.read(userAlertProvider.notifier).state = false);
                      SystemNavigator.pop();
                    },
                    child: const Text("EXIT"))
              ],
            ),
          );
        },
      );
    }
  }

  Future<String> getDownloadsPath() async {
    final Directory? downloadsDir = await getDownloadsDirectory();
    return await downloadsDir!.path;
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      _isHomeloading = true;
      setState(() {});
      await _showUnapprovedAlert(context);
      await unsyncData();
      await unsyncDataUpdate();
      await _refreshdbWithInternet();
      _isHomeloading = false;
      setState(() {});
    });

    super.initState();
  }

  Future<void> noInternetShowDialoge() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Alert!"),
          content: const Text(
              "Internet connection unavailable Please turn on your internet"),
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

  Future<void> showLogoutDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text("Alert!"),
          content: const Text("Do you want to logout ?"),
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

  Future<void> unsyncData() async {
    final ss = await ref.read(sqlHelperProvider).getUnsyncedData(0);
    await ref.read(badgeCountProvider.notifier).update((state) => ss.length);
  }

  Future<void> _refreshdbWithInternet() async {
    if (ref.read(connectivityStatusProviders) == //zzzz
        ConnectivityStatus.connected) {
      await ref
          .read(loanCollectionListProvider)
          .fold((left) => debugPrint(left.message), (right) async {
        // ref.read(productIdProvider.notifier).update((state) => state = right.result.)
        final res = ref.read(sqlHelperProvider);
        await res.refreshLoanListTable();
        // await res.deleteTable();
        await ref
            .read(moneyCollectionDataSourceProvider)
            .insertDataToDb(right.result);
        debugPrint("loan list res : ${right.result}");
      });
    }
  }

  final container = ProviderContainer();
  Future<void> _refreshdbWithInternetForMenu(
      BuildContext context, bool message) async {
    if (ref.read(connectivityStatusProviders) == //zzzz
        ConnectivityStatus.connected) {
      await ref
          .read(loanCollectionListProvider)
          .fold((left) => debugPrint(left.message), (right) async {
        final res = ref.read(sqlHelperProvider);
        await res.refreshLoanListTable();
        var errorSnack =
            authsnackbar(message ? "Synced" : " Downloaded", context);
        ScaffoldMessenger.of(context).showSnackBar(errorSnack);
      });
    } else {
      var errorSnack = authsnackbar(" No Internet Connection ", context);
      ScaffoldMessenger.of(context).showSnackBar(errorSnack);
    }
  }

  Future<void> unsyncDataUpdate() async {
    final ss = await ref.read(sqlHelperProvider).getUnsyncedData(0);
    debugPrint("Unsync data length  : ${ss.length}");
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
            createdby: ref.watch(userIdProvider),
            groupName: ss[i].groupName.toString(),
            lnAmt: double.parse(ss[i].loanAmt!).toInt(),
            loanNo: ss[i].loanNo,
            loginId: ss[i].loginId,
            memName: ss[i].memName!,
            status: ss[i].status!));
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

  List<String> images = [
    ImageAssets.repoco4,
    ImageAssets.repoco5,
    ImageAssets.repoco5,
    ImageAssets.repoco5
  ];
  bool sample = false;

  @override
  void didChangeDependencies() {
    for (String imagePath in images) {
      precacheImage(AssetImage(imagePath), context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    unsyncData();

    final menuList = ref.read(menuListProvider);
    final dropDwonController = ref.watch(HomePageDropDownProvider.notifier);
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        return showExitPopup(context);
      },
      child: generalsession(
        ref: ref,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Loan Collection",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
            centerTitle: false,
            actions: [
              InkWell(
                onTap: () {
                  // _refreshdbWithInternet();
                },
                child: Text(
                  ref.read(userIdProvider).substring(0, 1).toUpperCase() +
                      ref
                          .read(userIdProvider)
                          .substring(1, ref.read(userIdProvider).length),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
              ref.watch(badgeCountProvider) == 0
                  ? Container()
                  : BadgeWidget(
                      icon: Icons.sync,
                      onPressed: () {
                        if (ref.read(connectivityStatusProviders) == //zzzz
                            ConnectivityStatus.connected) {
                          unsyncDataUpdate();
                        } else {
                          var errorSnack =
                              authsnackbar(" No Internet Connection ", context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(errorSnack);
                        }

                        Future.delayed(
                          const Duration(milliseconds: 500),
                          () {
                            setState(() {});
                          },
                        );
                      },
                    ),
              PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onSelected: (value) =>
                    dropDwonController.changeValue(value, context), //zzzz
                itemBuilder: (context) {
                  return [
                    _buildPopupMenuItem("Sync", Icons.sync, Options.sync.index,
                        () async {
                      if (ref.read(connectivityStatusProviders) == //zzzz
                          ConnectivityStatus.connected) {
                        setState(() {});
                        showDialog(
                          barrierColor: const Color.fromARGB(78, 4, 40, 6),
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => const Center(
                            child: SizedBox(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(
                                strokeWidth: 7,
                                color: Color.fromARGB(255, 1, 42, 2),
                              ),
                            ),
                          ),
                        );

                        debugPrint(
                            ref.read(connectivityStatusProviders).toString());
                        await _refreshdbWithInternetForMenu(context, true);
                        debugPrint("sync done");
                        Navigator.of(context).pop();
                        setState(() {});
                      } else {
                        var errorSnack =
                            authsnackbar(" No Internet Connection ", context);
                        ScaffoldMessenger.of(context).showSnackBar(errorSnack);
                      }
                    }),
                    _buildPopupMenuItem(
                        "Download", Icons.download, Options.download.index, () {
                      _refreshdbWithInternetForMenu(context, false);
                    }),
                    _buildPopupMenuItem(
                        "Logout", Icons.logout, Options.logout.index, () {
                      // showLogoutDialog(context);
                      debugPrint("logout test ");
                    }),
                  ];
                },
              )
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                    Color(0xff006334),
                    Color(0xff10DC79),
                  ])),
            ),
          ),
          body: _isHomeloading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xff006334)),
                )
              : Padding(
                  padding: const EdgeInsets.all(Apppadding.p8),
                  child: GridView.builder(
                    //zzzz
                    itemCount: ref.read(menuListProvider)!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return menuList!.isEmpty
                          ? const Center(
                              child: Text("No Menus Assign For This User "))
                          : HomeContainers(
                              menu: menuList[index].menuCode!,
                              size: size,
                              text: menuList[index].menuName!,
                              imageName: images[index],
                              ref: ref,
                            );
                    },
                  ),
                ),

          // Container(
          //     child: Center(
          //   child: DropdownSearchFormField(
          //     hintText: "1213",
          //     items: [
          //       "1",
          //       "2",
          //       "3",
          //       "4",
          //     ],
          //   ),
          // )),
        ),
      ),
    );
  }
}

class HomeContainers extends StatelessWidget {
  HomeContainers(
      {super.key,
      required this.size,
      required this.text,
      required this.menu,
      required this.imageName,
      required this.ref});

  final Size size;

  final String imageName;
  final String text;
  final String menu;
  final WidgetRef ref;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint(menu);

        if (menu == "Menu01") {
          ref.read(isBoolProvider.notifier).state = true;
          context.goNamed(Routes.loanCollectionGroupScrn);
        } else if (menu == "Menu02") {
          context.goNamed(Routes.collectionReportSummary);
        } else if (menu == "Menu03") {
          context.goNamed(Routes.collectopmListReport);
        } else if (menu == "Menu04") {
          context.goNamed(Routes.nonRemittedCollectionScreen);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UnknownScreen(code: menu, name: text),
              ));
        }
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: Apppadding.p5),
        height: size.height * 0.24,
        width: size.width * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff006334),
                Color(0xff10DC79),
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Image.asset(
                imageName,
                scale: 4,
                color: const Color.fromARGB(255, 241, 237, 237),
              ),
            ),
            Center(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

PopupMenuItem _buildPopupMenuItem(
    String title, IconData iconData, int position, void Function()? ontap) {
  return PopupMenuItem(
    onTap: ontap,
    value: position,
    child: Row(
      children: [
        Icon(
          iconData,
          color: Colors.black,
        ),
        Text(title),
      ],
    ),
  );
}

Future<bool> showExitPopup(BuildContext context) async {
  bool? exitApp = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Exit App'),
      content: const Text('Do you want to exit an App?'),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          //return false when click on "NO"
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          //return true when click on "Yes"
          child: const Text('Yes'),
        ),
      ],
    ),
  );
  return exitApp ?? false;
}

// ignore: must_be_immutable
class BadgeWidget extends ConsumerWidget {
  BadgeWidget({super.key, required this.icon, required this.onPressed});
  IconData? icon;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Positioned(
            height: 16,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.red),
              constraints: const BoxConstraints(
                  maxHeight: AppSize.s16, maxWidth: AppSize.s16),
              child: Center(
                  child: Text(
                ref.watch(badgeCountProvider).toString(),
                style: const TextStyle(fontSize: 8, color: Colors.white),
              )),
            )),
        IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.white,
            )),
      ],
    );
  }
}
