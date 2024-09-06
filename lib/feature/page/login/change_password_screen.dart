import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/core/assets_manager.dart';
import '/core/base_utilites.dart';
import '/core/crypto_utils.dart';
import '/core/router.dart';
import '/core/value_manger.dart';
import '/data/model/user_mapping_req_res.dart';
import '/feature/page/common_widgets/common_methods.dart';
import '/feature/provider/login_provider.dart';

class ChnagePasswordScreen extends ConsumerStatefulWidget {
  const ChnagePasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChnagePasswordScreenState();
}

class _ChnagePasswordScreenState extends ConsumerState<ChnagePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? brID;
  String? pkId;
  bool? btnPress = false;
  bool isOldPassword = true;
  bool isNewPassword = true;
  bool isConfirmPassword = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      method();
    });
  }

  method() async {
    await ref.read(loginProvider.notifier).result.fold((left) => null, (right) {
      brID = right.result!.brId;
      pkId = right.result!.pkID;
      debugPrint("pkId :$pkId");
      debugPrint("brID :$brID");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height * 0.50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.27,
                          width: MediaQuery.of(context).size.width,
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
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Expanded(flex: 4, child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.45,
                          minHeight: MediaQuery.of(context).size.height * 0.20),
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: BaseUtilites.commonTextFeild(
                                    TextInputAction.next,
                                    AutovalidateMode.onUserInteraction,
                                    _oldPasswordController,
                                    false,
                                    "Please Enter Valid Password",
                                    Theme.of(context).textTheme.titleSmall,
                                    InputDecoration(
                                        labelText: "Old Password",
                                        prefixIcon: Icon(
                                          Icons.lock_clock_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(isOldPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              isOldPassword = !isOldPassword;
                                            });
                                          },
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 1))),
                                    (value) {
                                  setState(() {
                                    _oldPasswordController.text = value;
                                    _oldPasswordController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: _oldPasswordController
                                                .text.length));
                                  });
                                }, (validate) {
                                  if (validate!.isEmpty) {
                                    return "This Field Is Required";
                                  } else {
                                    return null;
                                  }
                                }, isOldPassword),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: BaseUtilites.commonTextFeild(
                                    TextInputAction.next,
                                    AutovalidateMode.onUserInteraction,
                                    _newPasswordController,
                                    false,
                                    "Please Enter Valid Password",
                                    Theme.of(context).textTheme.titleSmall,
                                    InputDecoration(
                                        labelText: "Change Password",
                                        prefixIcon: Icon(
                                          Icons.lock_reset_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(isNewPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              isNewPassword = !isNewPassword;
                                            });
                                          },
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 1))),
                                    (value) {
                                  setState(() {
                                    _newPasswordController.text = value;
                                    _newPasswordController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: _newPasswordController
                                                .text.length));
                                  });
                                }, (validate) {
                                  if (validate!.isEmpty) {
                                    return "This Field Is Required";
                                  } else {
                                    return null;
                                  }
                                }, isNewPassword),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: BaseUtilites.commonTextFeild(
                                    TextInputAction.next,
                                    AutovalidateMode.onUserInteraction,
                                    _confirmPasswordController,
                                    false,
                                    "Please Enter Valid Password",
                                    Theme.of(context).textTheme.titleSmall,
                                    InputDecoration(
                                        labelText: "Confirm Password",
                                        prefixIcon: Icon(
                                          Icons.key,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(isConfirmPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              isConfirmPassword =
                                                  !isConfirmPassword;
                                            });
                                          },
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(width: 1))),
                                    (value) {}, (validate) {
                                  if (validate!.isEmpty) {
                                    return "This Field is Required";
                                  } else if (_newPasswordController.text !=
                                      _confirmPasswordController.text) {
                                    return "Password is mismatch";
                                  } else {
                                    return null;
                                  }
                                }, isConfirmPassword),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Expanded(flex: 2, child: SizedBox()),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.12,
                width: MediaQuery.of(context).size.width * 0.45,
                child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.redAccent)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                        Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      context.goNamed(Routes.loginScreen);
                    }),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.12,
                width: MediaQuery.of(context).size.width * 0.45,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.primary)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref
                            .read(loginProvider.notifier)
                            .changePasswordProvider(ChangePasswordReq(
                                oldPassword: CryptoUtils.encrypt(
                                    _oldPasswordController.text),
                                password: CryptoUtils.encrypt(
                                    _newPasswordController.text),
                                pkId: pkId!))
                            .then((value) {
                          value.fold((left) => debugPrint(left.message), (right) {
                            if (right!.response ==
                                "Password Change Successfull") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  authsnackbar("Password Changed Successfull",
                                      context, 40));
                              // context.goNamed(Routes.loginScreen);
                              // GoRouter.of(context).pop();
                              Navigator.pop(context);
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => LoginScreen(),
                              //     ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  authsnackbar(right.response!, context));
                            }
                          });
                        });
                      } else {
                        debugPrint("nthing happen");
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
