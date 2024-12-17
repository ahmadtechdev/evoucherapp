import 'package:evoucher/service/session_manager.dart';
import 'package:evoucher/views/hotel_voucher/entry_hotel_controller.dart';
import 'package:evoucher/views/hotel_voucher/entry_hotel_voucher.dart';
import 'package:evoucher/views/side_bar/accounts/accounts/controller/account_controller.dart';
import 'package:evoucher/views/finance_voucher/controller/entry_controller.dart';
import 'package:evoucher/views/home/home.dart';
import 'package:evoucher/views/side_bar/incomes_report/controller/income_controller.dart';
import 'package:evoucher/views/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common/color_extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SessionManager
  final sessionManager = Get.put(SessionManager());
  await sessionManager.initializeSession();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    // Get.put( VoucherController());
    Get.lazyPut(() => AccountsController(), fenix: true);
    Get.lazyPut(() => VoucherController(), fenix: true);
    Get.lazyPut(() => IncomesReportController(), fenix: true);
    Get.lazyPut(() => HotelBookingController(), fenix: true);

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
        useMaterial3: true,
      ),
      home: GetX<SessionManager>(
        builder: (controller) {
          return controller.isLoggedIn ? const Home() : const WelcomeScreen();
        },
      ),
    );
  }
}

