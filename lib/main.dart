import 'package:evoucher/views/accounts/accounts/account_controller.dart';
import 'package:evoucher/views/finance_voucher/entry_controller.dart';
import 'package:evoucher/views/on_broading.dart';
import 'package:evoucher/views/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'common/color_extension.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.lazyPut(() => VoucherController());
    Get.lazyPut(() => AccountsController());

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

