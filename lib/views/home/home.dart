import 'package:flutter/material.dart';
import '../../common_widget/bottom_navigation.dart';
import '../../common_widget/drawer.dart';
import 'home_sales_dashboard.dart'; // Update this import path

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            'assets/img/newLogo.png',
            scale: 3,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Add logout functionality
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(currentIndex: 0),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SalesDashboardWidget(),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}