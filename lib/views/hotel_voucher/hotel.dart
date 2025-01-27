
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';
import '../../common/drawer.dart';
import '../../common_widget/bottom_navigation.dart';
import 'entry_hotel_voucher/entry_hotel_voucher.dart';
import 'hotel_sale_register/hotel_sale_register.dart';
import 'view_hotel_voucher/view_hotel_voucher.dart';

class Hotel extends StatefulWidget {
  const Hotel({super.key});

  @override
  State<Hotel> createState() => _HotelState();
}

class _HotelState extends State<Hotel> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        title: Text(
          'Hotel Vouchers',
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: TColor.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TColor.primary.withOpacity(0.1),
                  TColor.primary.withOpacity(0.3),
                ],
              ),
            ),
            height: 2.0,
          ),
        ),
      ),
      drawer: const CustomDrawer(currentIndex: 0),
      body: SingleChildScrollView(
        child: Container(
          width: media.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                TColor.white,
                TColor.primary.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              _buildVoucherOptions([
                VoucherOption(
                  title: 'Entry Hotel Voucher',
                  subtitle: 'Create a new hotel voucher entry',
                  icon: Icons.add_circle_outline,
                  color: TColor.primary,
                  onTap: () => Get.to(() => const EntryHotelVoucher()),
                ),
                VoucherOption(
                  title: 'View Hotel Voucher',
                  subtitle: 'Check existing voucher details',
                  icon: Icons.visibility_outlined,
                  color: TColor.primary,
                  onTap: () => Get.to(() => ViewHotelVoucher()),
                ),
                VoucherOption(
                  title: 'Hotel Sale Register',
                  subtitle: 'Register view details',
                  icon: Icons.app_registration,
                  color: TColor.primary,
                  onTap: () => Get.to(() => HotelSaleRegisterScreen()),
                ),
              ]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 3,
      ),
    );
  }

  Widget _buildVoucherOptions(List<VoucherOption> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: TColor.primary.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: option.onTap,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: option.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          option.icon,
                          color: option.color,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        option.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (option.subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            option.subtitle!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: TColor.primary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class VoucherOption {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final String? badge;
  final VoidCallback onTap;

  VoucherOption({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    this.badge,
    required this.onTap,
  });
}