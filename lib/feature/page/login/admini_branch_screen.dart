import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menthee_flutter_project/feature/page/splash/splash_screen.dart';
import '/core/assets_manager.dart';
import '/core/value_manger.dart';
import '/data/datasource/loacal_database/shared_pref.dart';
import '/data/model/user_mapping_req_res.dart';
import '/feature/page/login/admin_login_screen.dart';
import '/feature/provider/mobile_num_access_provider.dart';
import '../../../core/router.dart';
import '../../../main.dart';
import '../../provider/admin_login_provider.dart';
import '../../provider/login_provider.dart';
import '../../provider/network_listener_provider.dart';
import '../common_widgets/common_methods.dart';

final branchMapingTextProvider = StateProvider<String>((ref) {
  return '';
});
String branchName = "";

class AdminBranchScreen extends ConsumerStatefulWidget {
  const AdminBranchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminBranchScreenState();
}

class _AdminBranchScreenState extends ConsumerState<AdminBranchScreen> {
  var mobileNumberController = TextEditingController();
  List<String> userMappingList = [];
  List<UsermappingResponse>? allUserMappingList = [];
  List<UserInsertReq> userInsert = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        ref.watch(mobileNumberProvider.notifier).listenForPermission();
        mobileNumberController.text =
            ref.watch(mobileNumberProvider).mobileNumber;
        ref.watch(branchMapingTextProvider.notifier).update((state) => '');
        debugPrint("mobile no: ${mobileNumberController.text}${ref.watch(mobileNumberProvider).mobileNumber}");
        debugPrint("branchMappingText : ${ref.watch(branchMapingTextProvider)}");
        setState(() {});
      },
    );

    ref.read(loginProvider.notifier).result.fold((left) => null, (right) {
      branchNamelist = right.result!.branchlist!.map((e) => e.brName).toList();
      branchIdList = right.result!.branchlist!.map((e) => e.brId).toList();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(branchMapingTextProvider.notifier).update((state) => '');
    });

    debugPrint("token id :${ref.read(tokenProvider)}");
  }

  List branchIdList = [];
  List branchNamelist = [];

  final GlobalKey<FormState> _formKey = GlobalKey();
  String? selectedValue;
  final TextEditingController dropDowntextEditingController =
      TextEditingController();
  List<String>? multiSelectedValue = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final loginAccess = ref.read(loginProvider.notifier);
    return Container(
        height: size.height,
        width: size.width,
        color: Theme.of(context).colorScheme.primary,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: size.height * 0.27,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(160))),
                      child: Container(
                        margin: const EdgeInsets.all(Apppadding.p5),
                        child: Image.asset(
                          ImageAssets.repcoLogo,
                          scale: 2.1,
                        ),
                      )),
                  const Expanded(
                      child: SizedBox(
                    height: 15,
                  )),
                  Padding(
                    padding: const EdgeInsets.all(AppSize.s12),
                    child: Material(
                      shadowColor: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                      elevation: AppSize.s12,
                      child: Container(
                        constraints: BoxConstraints(
                            maxHeight: size.height * 0.30,
                            minHeight: size.height * 0.15),
                        padding: const EdgeInsets.all(Apppadding.p8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: DropdownButton2<String>(
                                    underline: Container(
                                      color: Colors.amber,
                                      width: size.width,
                                    ),
                                    isExpanded: true,
                                    hint: Text(
                                      'Select Branch',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                    items: branchNamelist
                                        .map((e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(e.toString())))
                                        .toList(),
                                    value: selectedValue,
                                    onChanged: (value) {
                                      final i = branchNamelist.indexWhere(
                                          (element) =>
                                              element
                                                  .toString()
                                                  .toLowerCase() ==
                                              value.toString().toLowerCase());
                                      ref
                                          .read(branchMapingTextProvider
                                              .notifier)
                                          .update(
                                              (state) => value.toString());
                                      ref
                                          .read(branchMapingTextProvider
                                              .notifier)
                                          .update((state) => branchIdList[i]);
                                      //karthi
                                      ref
                                          .read(loginProvider.notifier)
                                          .getUserMappingUseCase(
                                              brId: branchIdList[i],
                                              password: "",
                                              pkId: "")
                                          .then((value) {
                                        value.fold((left) => debugPrint(left.toString()),
                                            (right) {
                                          setState(() {
                                            userMappingList = right!
                                                .where((element) =>
                                                    element.brId ==
                                                    branchIdList[i])
                                                .map((e) => e.usrid!)
                                                .toSet()
                                                .toList();
                                            allUserMappingList = right
                                                .where((element) =>
                                                    element.brId ==
                                                    branchIdList[i])
                                                .toSet()
                                                .toList();
                                            debugPrint(
                                                "userMappingList :${userMappingList.length}");
                                          });
                                        });
                                      });
                                      branchName = value!;

                                      //karthi
                                      setState(() {
                                        selectedValue = value;
                                        // selectedValue = value as String;
                                        multiSelectedValue!.clear();
                                      });
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      height: 40,
                                    ),
                                    dropdownStyleData:
                                        const DropdownStyleData(
                                      maxHeight: 200,
                                    ),
                                    menuItemStyleData:
                                        const MenuItemStyleData(
                                      height: 40,
                                    ),
                                    dropdownSearchData: DropdownSearchData(
                                      searchController:
                                          dropDowntextEditingController,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value == '' ||
                                                value.isEmpty) {
                                              return 'Please Select the branch';
                                            }
                                            setState(() {});
                                            return null;
                                          },
                                          expands: true,
                                          maxLines: null,
                                          controller:
                                              dropDowntextEditingController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            hintText: 'Search for an item...',
                                            hintStyle:
                                                const TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return (item.value
                                            .toString()
                                            .toLowerCase()
                                            .contains(
                                                searchValue.toLowerCase()));
                                      },
                                    ),
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        dropDowntextEditingController.clear();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              ref
                                      .read(mobileNumberProvider)
                                      .mobileNumber
                                      .isEmpty
                                  ? Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Center(
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              if (mobileNumberController
                                                      .text.isEmpty ||
                                                  mobileNumberController.text ==
                                                      "") {
                                                return "Enter The Mobile Number ";
                                              } else if (mobileNumberController
                                                          .text.length <
                                                      10 ||
                                                  mobileNumberController
                                                          .text.length >
                                                      10) {
                                                return "Enter Valid Mobile Number";
                                              }
                                              return null;
                                            },
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            onChanged: (value) {
                                              mobileNumberController.text =
                                                  value;
                                              mobileNumberController.selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset:
                                                              mobileNumberController
                                                                  .text
                                                                  .length));
                                            },
                                            // onChanged: (value) {},
                                            // onEditingComplete: () {
                                            //   ref
                                            //       .read(
                                            //           mobileNumberProvider.notifier)
                                            //       .updateMobileNo(
                                            //           mobileNumberController.text);
                                            //    mobileNumberController.text = ref
                                            //        .watch(mobileNumberProvider)
                                            //        .mobileNumber;
                                            // },
                                            enabled: true,
                                            controller: mobileNumberController,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                border: UnderlineInputBorder(),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1.5)),
                                                labelText: "Mobile Number",
                                                // hintText: "User Name",
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1))),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Center(
                                          child: TextFormField(
                                            enabled: false,
                                            controller: mobileNumberController,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                                border: UnderlineInputBorder(),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1.5)),
                                                labelText: "Mobile Number",
                                                // hintText: "User Name",
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1))),
                                          ),
                                        ),
                                      ),
                                    ),
                              userMappingList.length > 0
                                  ? Expanded(
                                      flex: 3,
                                      child: SizedBox(
                                          height: 200,
                                          child: DropdownSearch<
                                              String>.multiSelection(
                                            autoValidateMode:
                                                AutovalidateMode.disabled,
                                            items: userMappingList,
                                            dropdownDecoratorProps:
                                                const DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                labelText: "Select User",
                                              ),
                                            ),
                                            popupProps:
                                                PopupPropsMultiSelection.menu(
                                              showSearchBox: true,
                                              // showSelectedItems: true,
                                              disabledItemFn: (String s) =>
                                                  s.contains('Disabled'),
                                            ),
                                            validator: (value) {
                                              if (multiSelectedValue!.isEmpty) {
                                                // setState(() {});
                                                return 'Atleast Select One User ';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                multiSelectedValue = value;
                                                var testVariable =
                                                    allUserMappingList!
                                                        .where((element) =>
                                                            multiSelectedValue!
                                                                .contains(
                                                                    element
                                                                        .usrid))
                                                        .toSet()
                                                        .toList();

                                                testVariable.forEach(
                                                  (element) {
                                                    userInsert.add(UserInsertReq(
                                                        usrid: element.usrid,
                                                        userName:
                                                            element.userName,
                                                        usrRoleId:
                                                            element.usrRoleId,
                                                        password: "Welcome@123",
                                                        brId: element.brId,
                                                        isFirstLogin: element
                                                            .isFirstLogin,
                                                        pkId: element.pkId,
                                                        empId: element.EmpId,
                                                        defaultRoleId: element
                                                            .DefaultRoleId,
                                                        isActive: true,
                                                        id: 0));
                                                  },
                                                );
                                                // var body = userInsertReqToJson(
                                                //     userInsert);
                                                // print("body : $body");
                                                // print(testVariable.length);
                                                // print(
                                                //     "multiSelectedValue :${multiSelectedValue!.length}");
                                              });
                                            },
                                            selectedItems: multiSelectedValue!,
                                          )),
                                    )
                                  : Container()
                            ]),
                      ),
                    ),
                  ),
                  const Expanded(
                      child: SizedBox(
                    height: 15,
                  )),
                  Padding(
                    padding: const EdgeInsets.all(Apppadding.p20),
                    child: FloatingActionButton(
                      elevation: AppSize.s10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      onPressed: () async {
                        if (selectedValue != null) {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(mobileNumberProvider.notifier)
                                .updateMobileNo(mobileNumberController.text);
                            await showBranchMappingDialog(
                                ref
                                    .read(mobileNumberProvider)
                                    .mobileNumber
                                    .toString(),
                                context,
                                ref,
                                userInsert);

                            // var saveBrName;
                            // await Future.delayed(
                            //   Duration(milliseconds: 500),
                            //   () async {
                            //     saveBrName = await Helper.getbranchName();
                            //   },
                            // );

                            // print("save brName : $saveBrName");
                          }
                        } else if (selectedValue == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              authsnackbar(
                                  "Please Select The Branch", context));
                        }
                      },
                      child: const Icon(Icons.arrow_forward_ios),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

Future<void> showBranchMappingDialog(String phoneNum, BuildContext context,
    WidgetRef ref, List<UserInsertReq> userList) async {
  await Helper.setPh(phoneNum);
  debugPrint("txdt ph : ${await Helper.getPh().toString()} ");
  debugPrint("Mobile Number: ${ref.read(mobileNumberProvider).mobileNumber}");
  await Helper.setPh(phoneNum);
  String? ph = await Helper.getPh();
  debugPrint("txdt ph : $ph");
  debugPrint("Mobile Number: ${ref.read(mobileNumberProvider).mobileNumber}");

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Branch Mapping"),
      content: const Text("Do you want to map the branch ?"),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No')),
        ElevatedButton(
            onPressed: () async {
              if (ref.read(connectivityStatusProviders) ==
                  ConnectivityStatus.connected) {
                await Helper.setBranchName(branchName);
                await ref
                    .read(brNameProvider.notifier)
                    .update((state) => state = branchName);
                debugPrint("branch Name : ${ref.read(brNameProvider)}");
                await ref
                    .read(branchMapingProvider)
                    .fold((left) => print(left.message), (right) {
                  if (right.statusCode == "2") {
                    if (right.result.message == "Your device already mapped") {
                      var messageSnack =
                          authsnackbar(right.result.message, context);
                      ScaffoldMessenger.of(
                        navigatorKey.currentState!.context,
                      ).showSnackBar(messageSnack);
                      ref
                          .read(branchMapingIscheckedProvider.notifier)
                          .update((state) => true);
                      debugPrint(
                          "check bool ${ref.read(branchMapingIscheckedProvider.notifier).update((state) => true)}");
                      Navigator.pop(context);
                      showReBranchMappingDialog(context, ref, userList);
                    }
                    ;
                  } else if (right.statusCode == "1") {
                    ref
                        .read(loginProvider.notifier)
                        .insertUserProvider(userList)
                        .then((value) {
                      print(value);
                    });
                    var messageSnack =
                        authsnackbar(right.result.message.toString(), context);
                    ScaffoldMessenger.of(
                      navigatorKey.currentState!.context,
                    ).showSnackBar(messageSnack);
                    GoRouter.of(context)
                        .pushReplacementNamed(Routes.loginScreen);
                  }
                });
              } else {
                var errorSnack =
                    authsnackbar("Internet Connection Unavailable", context);
                ScaffoldMessenger.of(context).showSnackBar(errorSnack);
                Navigator.pop(context);
              }
            },
            child: const Text('Yes'))
      ],
    ),
  );
}

showReBranchMappingDialog(
    BuildContext context, WidgetRef ref, List<UserInsertReq> userList) async {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Update Branch Mapping"),
      content: const Text("Do you want to remap the branch ?"),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No')),
        ElevatedButton(
            onPressed: () async {
              ref
                  .read(loginProvider.notifier)
                  .insertUserProvider(userList)
                  .then((value) {
                debugPrint(value.toString());
              });
              await ref
                  .read(branchMapingProvider)
                  .fold((left) => debugPrint(left.message), (right) {
                if (right.statusCode == "1") {
                  var errorSnack =
                      authsnackbar(right.result.message.toString(), context);
                  ScaffoldMessenger.of(
                    navigatorKey.currentState!.context,
                  ).showSnackBar(errorSnack);

                  ref
                      .read(branchMapingIscheckedProvider.notifier)
                      .update((state) => false);
                  debugPrint(
                      "check bool ${ref.read(branchMapingIscheckedProvider)}");
                  GoRouter.of(context).pushReplacementNamed(Routes.loginScreen);
                } else if (right.statusCode == "2") {
                  var errorSnack =
                      authsnackbar(right.result.message.toString(), context);
                  ScaffoldMessenger.of(
                    navigatorKey.currentState!.context,
                  ).showSnackBar(errorSnack);

                  ref
                      .read(branchMapingIscheckedProvider.notifier)
                      .update((state) => false);
                  debugPrint(
                      "check bool ${ref.read(branchMapingIscheckedProvider)}");
                }
              });
            },
            child: const Text('Yes'))
      ],
    ),
  );
}
