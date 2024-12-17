import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketvoucherControler extends GetxController {
  // Controllers for text fields
  final TextEditingController ticketNumberController = TextEditingController();
  final TextEditingController sectorController = TextEditingController();
  final TextEditingController segmentsController = TextEditingController();
  final TextEditingController basicFareController =
      TextEditingController(text: '0');
  final TextEditingController otherTaxesController =
      TextEditingController(text: '0');

  // Observable dropdown values
  var selectedAirline = ''.obs;
  var selectedSectorType = 'DOMESTIC'.obs;
  RxBool isTaxFormVisible = false.obs;
  RxBool morecharges = false.obs;
  RxBool Commissions  = false.obs;



  // Dropdown options
  final List<String> airlines = ['Airline A', 'Airline B', 'Airline C'];
  final List<String> sectorTypes = ['DOMESTIC', 'INTERNATIONAL'];

  @override
  void onClose() {
    // Dispose of controllers
    ticketNumberController.dispose();
    sectorController.dispose();
    segmentsController.dispose();
    basicFareController.dispose();
    otherTaxesController.dispose();
    super.onClose();
  }
}
