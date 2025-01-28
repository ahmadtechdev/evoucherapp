// bottom_navigation.dart
import 'package:evoucher_new/views/other_voucher/other.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/color_extension.dart';
import '../views/finance_voucher/finance.dart';
import '../views/home/home.dart';
import '../views/hotel_voucher/hotel.dart';
import '../views/ticket_voucher/ticket.dart';
import '../views/visa_voucher/visa.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  // Optional parameter - only pass when on a bottom nav page
  final int? selectedIndex;

  const CustomBottomNavigationBar({
    super.key,
    this.selectedIndex,
  });

  void _handleNavigation(BuildContext context, int index) {
    // Navigate based on index
    switch (index) {
      case 0:
        Get.to(() => const Home());
        break;
      case 1:
        Get.to(() => const Finance());

        // Navigator.pushNamed(context, '/ticket');

        break;
      case 2:
        // Navigator.pushNamed(context, '/hotel');
        Get.to(() => const Ticket());

        break;
      case 3:
        // Navigator.pushNamed(context, '/visa');
        Get.to(() => const Hotel());
        break;
      case 4:
        // Navigator.pushNamed(context, '/ticket');
        Get.to(() => const Visa());
        break;
      case 5:
        // Navigator.pushNamed(context, '/other');
        Get.to(() => const Other_voucher());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Theme(
        // Override the theme to show unselected items when no index is provided
        data: Theme.of(context).copyWith(
          bottomNavigationBarTheme:
              BottomNavigationBarTheme.of(context).copyWith(
            selectedItemColor:
                selectedIndex != null ? TColor.secondary : TColor.white,
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: TColor.primary,
          unselectedItemColor: TColor.white,
          currentIndex: selectedIndex ??
              0, // Use 0 as default but style all items as unselected when null
          onTap: (index) => _handleNavigation(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Finance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.airplane_ticket),
              label: 'Ticket',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.hotel),
              label: 'Hotel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_travel),
              label: 'Visa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_travel),
              label: 'other',
            ),
          ],
        ),
      ),
    );
  }
}
