import 'package:evoucher/views/home/report_grid_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widget/bottom_navigation.dart';
import '../../common/drawer.dart';
import '../../service/session_manager.dart';
import 'top_report_section.dart';
import 'home_dashboard/home_sales_dashboard.dart';

// Import your existing textfields

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final SessionManager sessionManager = Get.find<SessionManager>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            'assets/img/newLogo.png',
            scale: 3,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await sessionManager.logout();
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(currentIndex: 0),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReportSection(),
              SizedBox(height: 20),
              SalesDashboardWidget(),
              // SizedBox(height: 20),
              // SearchWidget(), // New section below the dashboard
              SizedBox(height: 20),
              ReportsGridSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 0,
      ),
    );
  }


}