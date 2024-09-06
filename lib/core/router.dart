import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/feature/page/login/admini_branch_screen.dart';
import '/feature/page/login/change_password_screen.dart';
import '/feature/page/login/login_screen.dart';
import '/feature/page/non_remitted_collection/non_remitted_collection.dart';
import '/feature/page/splash/splash_screen.dart';
import '/main.dart';

import '../feature/page/collection_list_report.dart/collection_list_report.dart';
import '../feature/page/collection_summary_report/collection_summary_report.dart';
import '../feature/page/home/home_screen.dart';
import '../feature/page/loan_collection/loan_collection_group_screen.dart';
import '../feature/page/loan_collection/loan_filter_screen.dart';
import '../feature/page/login/admin_login_screen.dart';

class Routes {
  static const String splashScreen = '/';
  static const String loginScreen = '/loginScreen';
  static const String adminLoginScreen = 'adminloginScreen';
  static const String signinScreen = 'signinScreen';
  static const String collectionReportSummary = 'collectionReport';
  static const String collectopmListReport = 'collectopmListReport';
  static const String loanCollection = 'loanCollection';
  static const String loanCollectionGroupScrn = 'loanCollectionGroupScrn';
  static const String homeScreen = 'home';
  static const String settingScreen = 'settingsScreen';
  static const String nonRemittedCollectionScreen = 'nonRemittedCollection';
  static const String adminBranchScreen = 'adminBranchScreen';
  static const String loanFilterScreen = 'loanfilterScreen';
  static const String changePasswordScreen = 'changePassword';
}

final goRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Routes.splashScreen,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Routes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
          path: Routes.loginScreen,
          name: Routes.loginScreen,
          builder: (context, state) => const LoginScreen(),
          routes: [
            GoRoute(
              path: Routes.changePasswordScreen,
              name: Routes.changePasswordScreen,
              builder: (context, state) => const ChnagePasswordScreen(),
            ),
            GoRoute(
                path: Routes.homeScreen,
                name: Routes.homeScreen,
                builder: (context, state) => HomeScreen(),
                routes: [
                  GoRoute(
                      path: Routes.loanCollectionGroupScrn,
                      name: Routes.loanCollectionGroupScrn,
                      pageBuilder: (context, state) => MaterialPage(
                          key: state.pageKey, child: const LoanCollectionGroupScrn()),
                      routes: [
                        GoRoute(
                          path: Routes.loanFilterScreen,
                          name: Routes.loanFilterScreen,
                          pageBuilder: (context, state) => MaterialPage(
                              key: state.pageKey,
                              child: const LoanFiltterScreen(),
                              fullscreenDialog: true),
                        )
                      ]),
                  GoRoute(
                    path: Routes.loanCollection,
                    name: Routes.loanCollection,
                    pageBuilder: (context, state) => MaterialPage(
                        key: state.pageKey, child: const LoanCollectionGroupScrn()),
                  ),
                  GoRoute(
                    path: Routes.collectopmListReport,
                    name: Routes.collectopmListReport,
                    pageBuilder: (context, state) => MaterialPage(
                        key: state.pageKey, child: const CollectopmListReport()),
                  ),
                  GoRoute(
                    path: Routes.collectionReportSummary,
                    name: Routes.collectionReportSummary,
                    pageBuilder: (context, state) => MaterialPage(
                        key: state.pageKey,
                        child: CollectionSummaryReportScreen()),
                  ),
                  GoRoute(
                    path: Routes.nonRemittedCollectionScreen,
                    name: Routes.nonRemittedCollectionScreen,
                    pageBuilder: (context, state) => MaterialPage(
                        key: state.pageKey,
                        child: const NonRemittedCollectionScreen()),
                  )
                ]),
            GoRoute(
                path: Routes.adminLoginScreen,
                name: Routes.adminLoginScreen,
                builder: (context, state) => const AdminLoginScreen(),
                routes: [
                  GoRoute(
                    path: Routes.adminBranchScreen,
                    name: Routes.adminBranchScreen,
                    pageBuilder: (context, state) => MaterialPage(
                        key: state.pageKey, child: const AdminBranchScreen()),
                  ),
                ])
          ]),
    ]);
