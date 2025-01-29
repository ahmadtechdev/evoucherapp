import 'package:evoucher_new/views/authentication/cotnroller/auth_controller.dart';
import 'package:evoucher_new/views/bottom_bar/hotel_voucher/entry_hotel_voucher/entry_hotel_controller.dart';
import 'package:evoucher_new/views/bottom_bar/hotel_voucher/hotel_sale_register/hotel_sale_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common/color_extension.dart';
import 'service/session_manager.dart';
import 'views/bottom_bar//finance_voucher/controller/entry_controller.dart';
import 'views/home/home.dart';
import 'views/side_bar/accounts/accounts/controller/account_controller.dart';
import 'views/side_bar/incomes_report/controller/income_controller.dart';
import 'views/welcome_view.dart';

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

    Get.lazyPut(() => AccountsController(), fenix: true);
    Get.lazyPut(() => VoucherController(), fenix: true);
    Get.lazyPut(() => IncomesReportController(), fenix: true);
    Get.lazyPut(() => EntryHotelController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => HotelSaleRegisterController(), fenix: true);

    return GetMaterialApp(
      title: 'Flutter dome',
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
