import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/core/assets_manager.dart';
import '/core/router.dart';
import '/core/string_manger.dart';
import '/core/value_manger.dart';
import '/data/datasource/loacal_database/shared_pref.dart';
import '/feature/page/splash/splash_screen.dart';
import '/feature/provider/auto_logout_provider.dart';
import '/feature/provider/login_provider.dart';
import '/feature/provider/mobile_num_access_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entity/login_res_entity.dart';
import '../../provider/daily_statuscheck_provider.dart';
import '../../provider/network_listener_provider.dart';
import '../common_widgets/common_methods.dart';
import 'change_password_screen.dart';

final menuListProvider = StateProvider<List<MenuEntity>?>((ref) {
  return [];
});

final passwordVisibleProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final userAlertProvider = StateProvider<bool>((ref) {
  return false;
});

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with WidgetsBindingObserver {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void initState() {
    // WidgetsBinding.instance.removeObserver(this);
    ref.read(mobileNumberProvider.notifier).listenForPermission();

    super.initState();
  }

  void passwordVisibleState() {
    ref.read(passwordVisibleProvider.notifier).update((state) => !state);
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    _userController.clear();
    _passController.clear();
    // FocusScope.of(context).unfocus();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      final SharedPreferences prefs = await _prefs;
      prefs.remove("stringValue");
      debugPrint('App is about to terminate');
    }
  }

  void _onSummit(bool isReset) async {
    ref.read(mobileNumberProvider.notifier).listenForPermission();
    setState(() {});
    String? txtphNo = await Helper.getPh();
    debugPrint("phone no : $txtphNo");
    debugPrint("mobile:"
        "${ref.read(mobileNumberProvider).mobileNumber}");
    if (_formKey.currentState!.validate()) {
      ref.read(connectivityStatusProviders);
      if (ref.read(connectivityStatusProviders) == //zzzz
          ConnectivityStatus.connected) {
        if (txtphNo != '' ||
            ref.read(mobileNumberProvider).mobileNumber != '') {
          isLoadind = true;
          setState(() {});
          final loginUser = ref.read(loginProvider.notifier);
          await loginUser.checkLoginUser(
              ref: ref,
              uniqueID: ref.read(androidUniqueIdProvider),
              username: _userController.text.trim(),
              pass: _passController.text.trim(),
              mobilenum: ref
                      .watch(mobileNumberProvider)
                      .mobileNumber
                      .toString()
                      .isEmpty
                  ? txtphNo!
                  : ref.watch(mobileNumberProvider).mobileNumber.toString(),
              isAdmin: false);

          loginUser.result.fold((left) => debugPrint(left.message),
              (right) async {
            ref
                .read(menuListProvider.notifier)
                .update((state) => right.result!.menus);
            if (right.result!.status == AppString.SUCCESS) {
              ref
                  .read(userIdProvider.notifier)
                  .update((state) => right.result!.usrId.toString());
              ref
                  .read(brIdProvider.notifier)
                  .update((state) => right.result!.brId.toString());
              ref.watch(autoLogoutProvider.notifier).start();
              if (right.result!.isFirstLogin! && isReset == false) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChnagePasswordScreen(),
                    ));
                // context.goNamed(Routes.changePasswordScreen);
              } else if (!right.result!.isFirstLogin! && isReset == false) {
                context.goNamed(Routes.homeScreen);
              } else if (isReset) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChnagePasswordScreen(),
                    ));
              }
              final SharedPreferences prefs = await _prefs;
              prefs.setString('log', right.result.toString());
              ref
                  .read(brIdProvider.notifier)
                  .update((state) => right.result!.brId!);

              ref
                  .read(userIdProvider.notifier)
                  .update((state) => right.result!.usrId.toString());

              ref
                  .read(brIdProvider.notifier)
                  .update((state) => right.result!.brId.toString());

              ref.watch(autoLogoutProvider.notifier).start();
              _userController.clear();
              _passController.clear();
              statuscheck(_userController.text.trim());
              isLoadind = false;
              setState(() {});
            } else if (right.result!.status == AppString.Failed) {
              var errorSnack =
                  authsnackbar('${right.result!.errorMessage}❕', context);
              ScaffoldMessenger.of(context).showSnackBar(errorSnack);
              isLoadind = false;
              setState(() {});
            }
          });
        } else {
          isLoadind = false;
          var errorSnack =
              authsnackbar(" Do The Branch Mapping❕ ", context, 40);
          ScaffoldMessenger.of(context).showSnackBar(errorSnack);
          setState(() {});
        }
      } else {
        isLoadind = false;
        var errorSnack = authsnackbar(" No Internet Connection❕ ", context, 40);
        ScaffoldMessenger.of(context).showSnackBar(errorSnack);
        setState(() {});
      }
    }
  }

  void statuscheck(String username) {
    bool botom = false;
    ref.read(dailyStatusCheckProvider).fold(
        (left) => debugPrint("!!!! Failure Meaasge :${left.message}"), (right) {
      debugPrint("Success");
      debugPrint("!!!!!!${right.result!}");
      debugPrint("!!!!!!${right.result!.length}");
      if (right.result!.isNotEmpty && right.statusCode == "1") {
        //todo
        botom = true;
        ref.read(userAlertProvider.notifier).update((state) => botom);
      } else {
        ref.read(userAlertProvider.notifier).update((state) => botom);
      }
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoadind = false;
  @override
  Widget build(BuildContext context) {
    ref.watch(mobileNumberProvider.notifier).listenForPermission();

    final passwordVisible = ref.watch(passwordVisibleProvider);
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
        height: size.height,
        width: size.width,
        color: Theme.of(context).colorScheme.primary,
        child: SafeArea(
          child: Scaffold(
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
                  const Expanded(flex: 2, child: SizedBox()),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => MyHomePage(),
                  //           ));
                  //     },
                  //     child: Text("test")),
                  Padding(
                    padding: const EdgeInsets.all(AppSize.s12),
                    child: Material(
                      shadowColor: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                      elevation: AppSize.s12,
                      child: Container(
                        constraints: BoxConstraints(
                            maxHeight: size.height * 0.25,
                            minHeight: size.height * 0.20),
                        padding: const EdgeInsets.all(Apppadding.p8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      enableSuggestions: true,

                                      // focusNode: _focusNode1,
                                      textInputAction: TextInputAction.next,

                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      controller: _userController,
                                      autofocus: false,

                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          HapticFeedback.heavyImpact();
                                          return "Please enter valid user name";
                                        }
                                        return null;
                                      },
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      decoration: InputDecoration(
                                          labelText: "User Name",
                                          // hintText: "User Name",
                                          prefixIcon: Icon(Icons.person_outline,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 1))),
                                    ),
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      // focusNode: _focusNode2,
                                      textInputAction: TextInputAction.send,
                                      autofocus: false,
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      enableSuggestions: true,

                                      // obscuringCharacter: "*",
                                      controller: _passController,
                                      validator: (value) {
                                        if (value!.isEmpty || value == "") {
                                          HapticFeedback.heavyImpact();
                                          return 'Enter the valid Pasword';
                                        }
                                        return null;
                                      },

                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      obscureText: passwordVisible,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                                passwordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            onPressed: () {
                                              passwordVisibleState();
                                            },
                                          ),
                                          prefixIcon: Icon(Icons.lock_outline,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant),
                                          labelText: "Password",
                                          // hintText: "Password",

                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 1))),
                                    ),
                                  )
                                ]),
                            isLoadind
                                ? const Align(
                                    child: Center(
                                        child: CircularProgressIndicator
                                            .adaptive()),
                                  )
                                : const SizedBox(
                                    height: 1,
                                    width: 1,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox())
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.only(
                  bottom: Apppadding.p5, top: Apppadding.p5),
              height: size.height * 0.19,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.only(topRight: Radius.circular(150)),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: AppSize.s10,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      child: const SizedBox(
                          height: 60, child: Icon(Icons.arrow_forward_ios)),
                      onPressed: () => _onSummit(false)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            context.goNamed(Routes.adminLoginScreen);
                            passwordVisibleState();
                          },
                          child: Text(
                            "Login As Admin",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline),
                          )),
                      TextButton(
                          onPressed: () {
                            _onSummit(true);
                          },
                          child: Text(
                            "Reset Password",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
