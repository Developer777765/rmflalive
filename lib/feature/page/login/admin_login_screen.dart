import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/core/assets_manager.dart';
import '/core/router.dart';
import '/core/value_manger.dart';
import '/feature/page/common_widgets/common_methods.dart';
import '/feature/page/splash/splash_screen.dart';
import '../../../core/string_manger.dart';
import '../../provider/auto_logout_provider.dart';
import '../../provider/login_provider.dart';
import '../../provider/mobile_num_access_provider.dart';
import '../../provider/network_listener_provider.dart';
import 'login_screen.dart';

final adminUserNameProvider = StateProvider<String>((ref) {
  return '';
});

final tokenProvider = StateProvider((ref) {
  return "";
});

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _onSummit() async {
    if (_formKey.currentState!.validate()) {
      final loginAccess = ref.read(loginProvider.notifier);
      if (ref.read(connectivityStatusProviders) ==
          ConnectivityStatus.connected) {
        _isLoadind = true;
        setState(() {});
        await loginAccess.checkLoginUser(
            ref: ref,
            uniqueID: ref.read(androidUniqueIdProvider),

            ///not used
            username: _userController.text.trim(),
            pass: _passController.text.trim(),
            mobilenum: ref.watch(mobileNumberProvider).mobileNumber.toString(),
            isAdmin: true);
        ref
            .read(adminUserNameProvider.notifier)
            .update((state) => _userController.text.trim());

        loginAccess.result.fold((left) => debugPrint(left.message),
            (right) => debugPrint(right.status.toString()));
        ref
            .read(loginProvider.notifier)
            .result
            .fold((left) => debugPrint(left.message), (right) {
          if (right.result!.status == AppString.SUCCESS) {
            ref
                .read(userIdProvider.notifier)
                .update((state) => right.result!.usrId.toString());

            ref
                .read(brIdProvider.notifier)
                .update((state) => right.result!.brId.toString());

            ref.watch(autoLogoutProvider.notifier).start();
            context.goNamed(Routes.adminBranchScreen);

            _userController.clear();
            _passController.clear();
            _isLoadind = false;
            setState(() {});
          } else if (right.result!.statusCode == '2') {
            var errorSnack =
                authsnackbar(right.result!.errorMessage.toString(), context);
            ScaffoldMessenger.of(context).showSnackBar(errorSnack);
            _isLoadind = false;
            setState(() {});
            FocusManager.instance.primaryFocus?.unfocus();
          }
        });
      } else {
        var errorSnack = authsnackbar("No Internet Connection ", context, 40);
        ScaffoldMessenger.of(context).showSnackBar(errorSnack);
        _isLoadind = false;
        setState(() {});
      }
    }
  }

  bool _isLoadind = false;
  @override
  Widget build(BuildContext context) {
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
                  // Text(
                  //   ref.watch(exeptionprovider.notifier).state,
                  //   style: TextStyle(color: Colors.black),
                  // ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         ref
                  //             .watch(exeptionprovider.notifier)
                  //             .update((state) => exception);
                  //       });
                  //     },
                  //     child: Text("press")),
                  Container(
                      height: size.height * 0.27,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(160))),
                      child: Image.asset(
                        ImageAssets.repcoLogo,
                        scale: 2.1,
                      )),
                  const Expanded(flex: 2, child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.all(AppSize.s12),
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      shadowColor: Theme.of(context).colorScheme.primary,
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
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    autofocus: false,
                                    controller: _userController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter valid user name";
                                      }
                                      return null;
                                    },
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                    decoration: InputDecoration(
                                        labelText: "Admin Name",
                                        // hintText: "User Name",
                                        prefixIcon: Icon(Icons.person,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(width: 1))),
                                  ),
                                  TextFormField(
                                    textInputAction: TextInputAction.done,
                                    autofocus: false,
                                    controller: _passController,
                                    validator: (value) =>
                                        (value!.isEmpty || value == "")
                                            ? 'Enter the valid Pasword'
                                            : null,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                    obscureText: passwordVisible,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          onPressed: () {
                                            ref
                                                .read(passwordVisibleProvider
                                                    .notifier)
                                                .update((state) => !state);
                                            setState(() {});
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
                                  )
                                ]),
                            _isLoadind
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
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: size.height * 0.15,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.only(topRight: Radius.circular(150)),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: AppMargin.m18),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: AppSize.s10,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                        ),
                        onPressed: _onSummit,
                        child: const SizedBox(
                            height: 60, child: Icon(Icons.arrow_forward_ios))),
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

// Future<void> _show(BuildContext context) async {
//   return showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text(
//           "Alert!",
//           style:
//               Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 16),
//         ),
//         content: Text(""),
//         actions: [
//           ElevatedButton(
//               onPressed: () {
//                 context.pushReplacement(Routes.loginScreen);
//               },
//               child: Text("EXIT"))
//         ],
//       );
//     },
//   );
// }
