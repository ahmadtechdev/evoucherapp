
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryTicketController extends GetxController {
  // Text Editing Controllers
  late TextEditingController phoneNoController;
  late TextEditingController paxNameController;
  late TextEditingController pnrController;
  late TextEditingController ticketNumberController;
  late TextEditingController airLineController;
  late TextEditingController sectorController;
  late TextEditingController segmentsController;
  late TextEditingController sectorTypeController;
  late TextEditingController basicFareController;
  late TextEditingController otherTaxesController;

  // Tax Controllers
  late TextEditingController emdController;
  late TextEditingController ccController;
  late TextEditingController spController;
  late TextEditingController rgController;
  late TextEditingController ydController;
  late TextEditingController e3Controller;
  late TextEditingController ioController;
  late TextEditingController yiController;
  late TextEditingController xzController;
  late TextEditingController pkController;
  late TextEditingController zrController;
  late TextEditingController yqController;

  // Changes Controllers
  late TextEditingController basicFareCHGSController;
  late TextEditingController basicFareCHGSPKRController;
  late TextEditingController totalFareCHGSController;
  late TextEditingController totalFareCHGSPKRController;
  late TextEditingController partyCommController;
  late TextEditingController partyCommPKRController;
  late TextEditingController partyWHTController;
  late TextEditingController partyWHTPKRController;

  // Supplier Controllers
  late TextEditingController issueFromController;
  late TextEditingController consultantNameController;
  late TextEditingController remarksController;

  // Commission Controllers
  late TextEditingController airLineCommController;
  late TextEditingController airLineCommPKRController;
  late TextEditingController airLineWHTController;
  late TextEditingController airLineWHTPKRController;
  late TextEditingController psfController;
  late TextEditingController psfPKRController;
  late TextEditingController totalBuyingController;
  late TextEditingController profitController;
  late TextEditingController lossController;
  late TextEditingController totalDebitController;
  late TextEditingController totalCreditController;
  late TextEditingController pkrTotalSellingController;
  late TextEditingController totalController;


  // Date Fields (unchanged)
  final Rx<DateTime> todayDate = DateTime.now().obs;
  final Rx<DateTime> issuanceDate = DateTime.now().obs;
  final Rx<DateTime?> travelDateTime = Rx<DateTime?>(null);
  final Rx<DateTime?> returnDateTime = Rx<DateTime?>(null);

  final Rx<DateTimeRange> dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  ).obs;

  // Observable fields for dropdown/selection values
  final RxString customerAccount = RxString('');
  final RxString supplierDetail = RxString('');

  // Toggle fields
  final RxBool isAddMoreTaxesEnabled = false.obs;
  final RxBool isAddMoreChangesEnabled = false.obs;
  final RxBool isAddMoreCommissionsEnabled = false.obs;
  final RxBool isAdditionalDetailsEnabled = false.obs;



  // Additional details
  final RxList<Map<String, dynamic>> additionalDetails = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    initializeControllers();
  }

  void initializeControllers() {
    // Initialize basic info controllers
    phoneNoController = TextEditingController();
    paxNameController = TextEditingController();
    pnrController = TextEditingController();
    ticketNumberController = TextEditingController();
    airLineController = TextEditingController();
    sectorController = TextEditingController();
    segmentsController = TextEditingController();
    sectorTypeController = TextEditingController();
    basicFareController = TextEditingController();
    otherTaxesController = TextEditingController();

    // Initialize tax controllers
    emdController = TextEditingController();
    ccController = TextEditingController();
    spController = TextEditingController();
    rgController = TextEditingController();
    ydController = TextEditingController();
    e3Controller = TextEditingController();
    ioController = TextEditingController();
    yiController = TextEditingController();
    xzController = TextEditingController();
    pkController = TextEditingController();
    zrController = TextEditingController();
    yqController = TextEditingController();

    // Initialize changes controllers
    basicFareCHGSController = TextEditingController();
    basicFareCHGSPKRController = TextEditingController();
    totalFareCHGSController = TextEditingController();
    totalFareCHGSPKRController = TextEditingController();
    partyCommController = TextEditingController();
    partyCommPKRController = TextEditingController();
    partyWHTController = TextEditingController();
    partyWHTPKRController = TextEditingController();

    // Initialize supplier controllers
    issueFromController = TextEditingController();
    consultantNameController = TextEditingController();
    remarksController = TextEditingController();

    // Initialize commission controllers
    airLineCommController = TextEditingController();
    airLineCommPKRController = TextEditingController();
    airLineWHTController = TextEditingController();
    airLineWHTPKRController = TextEditingController();
    psfController = TextEditingController();
    psfPKRController = TextEditingController();
    totalBuyingController = TextEditingController();
    profitController = TextEditingController();
    lossController = TextEditingController();
    totalDebitController = TextEditingController();
    totalCreditController = TextEditingController();
    pkrTotalSellingController = TextEditingController();
    totalController = TextEditingController();
  }

  @override
  void onClose() {
    // Dispose all controllers
    phoneNoController.dispose();
    paxNameController.dispose();
    pnrController.dispose();
    ticketNumberController.dispose();
    airLineController.dispose();
    sectorController.dispose();
    segmentsController.dispose();
    sectorTypeController.dispose();
    basicFareController.dispose();
    otherTaxesController.dispose();

    emdController.dispose();
    ccController.dispose();
    spController.dispose();
    rgController.dispose();
    ydController.dispose();
    e3Controller.dispose();
    ioController.dispose();
    yiController.dispose();
    xzController.dispose();
    pkController.dispose();
    zrController.dispose();
    yqController.dispose();

    basicFareCHGSController.dispose();
    basicFareCHGSPKRController.dispose();
    totalFareCHGSController.dispose();
    totalFareCHGSPKRController.dispose();
    partyCommController.dispose();
    partyCommPKRController.dispose();
    partyWHTController.dispose();
    partyWHTPKRController.dispose();

    issueFromController.dispose();
    consultantNameController.dispose();
    remarksController.dispose();

    airLineCommController.dispose();
    airLineCommPKRController.dispose();
    airLineWHTController.dispose();
    airLineWHTPKRController.dispose();
    psfController.dispose();
    psfPKRController.dispose();
    totalBuyingController.dispose();
    profitController.dispose();
    lossController.dispose();
    totalDebitController.dispose();
    totalCreditController.dispose();
    pkrTotalSellingController.dispose();
    totalController.dispose();


    super.onClose();
  }

  // Helper method to get tax controller
  TextEditingController getTaxController(String fieldName) {
    switch (fieldName) {
      case 'EMD':
        return emdController;
      case 'CC':
        return ccController;
      case 'SP':
        return spController;
      case 'RG':
        return rgController;
      case 'YD':
        return ydController;
      case 'E3':
        return e3Controller;
      case 'IO':
        return ioController;
      case 'YI':
        return yiController;
      case 'XZ':
        return xzController;
      case 'PK':
        return pkController;
      case 'ZR':
        return zrController;
      case 'YQ':
        return yqController;
      default:
        throw Exception('Invalid tax field name: $fieldName');
    }
  }

  // Helper method to get charge controller
  TextEditingController getChargeController(String fieldName) {
    switch (fieldName) {
      case 'Basic Fare CHGS %':
        return basicFareCHGSController;
      case 'Basic Fare CHGS PKR':
        return basicFareCHGSPKRController;
      case 'Total Fare CHGS':
        return totalFareCHGSController;
      case 'Total Fare CHGS PKR':
        return totalFareCHGSPKRController;
      case 'Party Comm %':
        return partyCommController;
      case 'Party Comm PKR':
        return partyCommPKRController;
      case 'Party WHT %':
        return partyWHTController;
      case 'Party WHT PKR':
        return partyWHTPKRController;
      default:
        throw Exception('Invalid charge field name: $fieldName');
    }
  }
}