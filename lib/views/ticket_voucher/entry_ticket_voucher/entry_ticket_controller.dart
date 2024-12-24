import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../service/api_service.dart';

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
  // final Rx<String?> selectedSectorType = Rx<String?>(null);
  final Map<String, String> sectorTypes = {
    'DOMESTIC': 'DOMESTIC',
    'INTERNATIONAL': 'INTERNATIONAL',
  }.obs;
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
  final Map<String, String> issueFrom = {
    'GDS': 'GDS (Airline Stock)',
    'B2B': 'B2B (XO)',
  }.obs;
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
  final RxBool isTicketReceivingDetailsEnabled = false.obs;

  // Additional details
  final RxList<Map<String, dynamic>> ticketReceivingDetails =
      <Map<String, dynamic>>[].obs;


  // Observable fields for reactive updates
  final RxBool isTotalFareReadOnly = false.obs;
  final RxBool isBasicFareCHGSReadOnly = false.obs;
// Add new observable for airlineWHT readonly state
  final RxBool isAirlineWHTReadOnly = true.obs;
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

    // Add listeners for reactive calculations
    _addListeners();
  }

  // Update the _addListeners method for better reactivity
  void _addListeners() {
    // Basic Fare CHGS listeners
    basicFareCHGSController.addListener(() {
      calculateBasicFareCHGS();
      checkAndUpdateReadOnlyStates();
      recalculateAll();
    });

    basicFareCHGSPKRController.addListener(() {
      calculateBasicFareCHGS();
      checkAndUpdateReadOnlyStates();
      recalculateAll();
    });

    // Total Fare CHGS listeners
    totalFareCHGSController.addListener(() {
      calculateTotalFareCHGS();
      checkAndUpdateReadOnlyStates();
      recalculateAll();
    });

    totalFareCHGSPKRController.addListener(() {
      calculateTotalFareCHGS();

      checkAndUpdateReadOnlyStates();
      recalculateAll();
    });

    // Party Commission listeners
    partyCommController.addListener(() {
      calculatePartyComm();
      recalculateAll();
    });

    partyCommPKRController.addListener(() {
      calculatePartyComm();
      recalculateAll();
    });

    // Party WHT listener
    partyWHTController.addListener(() {
      calculatePartyWHT();
      recalculateAll();
    });



    // Basic fields listeners
    basicFareController.addListener(recalculateAll);
    otherTaxesController.addListener(recalculateAll);

    // Tax field listeners
    for (var controller in [emdController, ccController, spController, rgController,
      ydController, e3Controller, ioController, yiController,
      xzController, pkController, zrController, yqController]) {
      controller.addListener(recalculateAll);
    }

    // Add new listeners for supplier calculations
    airLineCommController.addListener(() {
      if (!airLineCommController.text.endsWith('.')) {
        calculateAirlineComm();
        recalculateSupplierTotals();
      }
    });

    airLineCommPKRController.addListener(() {
      if (!airLineCommPKRController.text.endsWith('.')) {
        calculateAirlineComm();
        recalculateSupplierTotals();
      }
    });

    // Update PSF listeners
    psfController.addListener(() {
      if (!psfController.text.endsWith('.')) {
        calculatePSF();
        recalculateSupplierTotals();
      }
    });

    psfPKRController.addListener(() {
      if (!psfPKRController.text.endsWith('.')) {
        calculatePSF();
        recalculateSupplierTotals();
      }
    });

    airLineWHTController.addListener(() {
      calculateAirlineWHT();
      recalculateSupplierTotals();
    });


    // Add listener for pkrTotalSellingController to update profit/loss
    pkrTotalSellingController.addListener(() {
      calculateProfitLoss();
      calculateTotalDebitCredit();
    });

    // Add listener for totalBuyingController to update profit/loss
    totalBuyingController.addListener(() {
      calculateProfitLoss();
      calculateTotalDebitCredit();
    });
  }

  // ******************************************SuppplieR **********************************************

  void calculateAirlineComm() {
    final basicFare = double.tryParse(basicFareController.text) ?? 0.0;
    final airLineComm = double.tryParse(airLineCommController.text);
    final airLineCommPKR = double.tryParse(airLineCommPKRController.text);

    // Only calculate if we have valid numbers
    if (basicFare != 0.0) {
      if (airLineComm != null && airLineCommController.text.isNotEmpty) {
        // Calculate PKR value only if percentage is valid
        final calculatedPKR = (airLineComm / 100) * basicFare;
        if (calculatedPKR != double.tryParse(airLineCommPKRController.text)) {
          airLineCommPKRController.text = calculatedPKR.round().toString();
        }
      } else if (airLineCommPKR != null && airLineCommPKRController.text.isNotEmpty) {
        // Calculate percentage only if PKR value is valid
        final calculatedPercentage = (airLineCommPKR / basicFare) * 100;
        if (calculatedPercentage != double.tryParse(airLineCommController.text)) {
          airLineCommController.text = calculatedPercentage.toStringAsFixed(2);
        }
      }
    }

    checkAirlineWHTReadOnly();
    calculateAirlineWHT();
    update();
  }

  void checkAirlineWHTReadOnly() {
    final airLineComm = double.tryParse(airLineCommController.text) ?? 0.0;
    isAirlineWHTReadOnly.value = airLineComm == 0;
    update();
  }

  void calculateAirlineWHT() {
    final airLineCommPKR = double.tryParse(airLineCommPKRController.text) ?? 0.0;
    final airLineWHT = double.tryParse(airLineWHTController.text) ?? 0.0;

    if (airLineCommPKR != 0 && airLineWHT != 0) {
      airLineWHTPKRController.text = ((airLineWHT / 100) * airLineCommPKR).round().toString();
    } else {
      airLineWHTPKRController.text = '0';
    }
    update();
  }

  void calculatePSF() {
    final basicFare = double.tryParse(basicFareController.text) ?? 0.0;
    final psf = double.tryParse(psfController.text);
    final psfPKR = double.tryParse(psfPKRController.text);

    // Only calculate if we have valid numbers
    if (basicFare != 0.0) {
      if (psf != null && psfController.text.isNotEmpty) {
        // Calculate PKR value only if percentage is valid
        final calculatedPKR = (psf / 100) * basicFare;
        if (calculatedPKR != double.tryParse(psfPKRController.text)) {
          psfPKRController.text = calculatedPKR.toStringAsFixed(2);
        }
      } else if (psfPKR != null && psfPKRController.text.isNotEmpty) {
        // Calculate percentage only if PKR value is valid
        final calculatedPercentage = (psfPKR / basicFare) * 100;
        if (calculatedPercentage != double.tryParse(psfController.text)) {
          psfController.text = calculatedPercentage.toStringAsFixed(2);
        }
      }
    }
    update();
  }

  void calculateTotalBuying() {
    final total = double.tryParse(totalController.text) ?? 0.0;
    final airLineCommPKR = double.tryParse(airLineCommPKRController.text) ?? 0.0;
    final airLineWHTPKR = double.tryParse(airLineWHTPKRController.text) ?? 0.0;
    final psfPKR = double.tryParse(psfPKRController.text) ?? 0.0;

    final totalBuying = total - airLineCommPKR + airLineWHTPKR + psfPKR;
    totalBuyingController.text = totalBuying.round().toString();
    update();
  }

  void calculateProfitLoss() {
    final totalSelling = double.tryParse(pkrTotalSellingController.text) ?? 0.0;
    final totalBuying = double.tryParse(totalBuyingController.text) ?? 0.0;

    if (totalSelling > totalBuying) {
      profitController.text = (totalSelling - totalBuying).round().toString();
      lossController.text = '0';
    } else if (totalBuying > totalSelling) {
      lossController.text = ((totalBuying - totalSelling)*-1).round().toString();
      profitController.text = '0';
    } else {
      lossController.text = '0';
      profitController.text = '0';
    }
    update();
  }

  void calculateTotalDebitCredit() {
    final totalBuying = double.tryParse(totalBuyingController.text) ?? 0.0;

    totalDebitController.text = totalBuying.round().toString();
    totalCreditController.text = totalBuying.round().toString();
    update();
  }

  void recalculateSupplierTotals() {
    calculateTotalBuying();
    calculateProfitLoss();
    calculateTotalDebitCredit();
    update();
  }

  void recalculateAll() {
    // Keep existing calculations
    // calculateBasicFareCHGS();
    // calculateTotalFareCHGS();
    // calculatePartyComm();
    calculatePartyWHT();
    calculatePKRTotalSelling();
    calculateTotal();

    // Add supplier calculations
    calculateAirlineComm();
    calculateAirlineWHT();
    calculatePSF();
    recalculateSupplierTotals();

    update();
  }


  // ******************************************SuppplieR ENd **********************************************

  double calculateTotalBase() {
    final basicFare = double.tryParse(basicFareController.text) ?? 0.0;
    final otherTaxes = double.tryParse(otherTaxesController.text) ?? 0.0;
    final moreTaxes = _getSumOfMoreTaxes();
    return basicFare + otherTaxes + moreTaxes;
  }

  void checkAndUpdateReadOnlyStates() {
    // Check if total fare fields are filled
    final totalFareCHGS = double.tryParse(totalFareCHGSController.text) ?? 0.0;
    final totalFareCHGSPKR = double.tryParse(totalFareCHGSPKRController.text) ?? 0.0;

    if (totalFareCHGS != 0 && totalFareCHGSPKR != 0) {
      isBasicFareCHGSReadOnly.value = true;
    } else {
      isBasicFareCHGSReadOnly.value = false;
    }

    // Check if basic fare fields are filled
    final basicFareCHGS = double.tryParse(basicFareCHGSController.text) ?? 0.0;
    final basicFareCHGSPKR = double.tryParse(basicFareCHGSPKRController.text) ?? 0.0;

    if (basicFareCHGS != 0 && basicFareCHGSPKR != 0) {
      isTotalFareReadOnly.value = true;
    } else {
      isTotalFareReadOnly.value = false;
    }

    update();
  }
  //
  // void recalculateAll() {
  //   // calculateBasicFareCHGS();
  //   // calculateTotalFareCHGS();
  //   // calculatePartyComm();
  //   calculatePartyWHT();
  //   calculatePKRTotalSelling();
  //   calculateTotal();
  //   update();
  // }

  double _getSumOfMoreTaxes() {
    if (!isAddMoreTaxesEnabled.value) return 0.0;

    return [
      emdController, ccController, spController, rgController,
      ydController, e3Controller, ioController, yiController,
      xzController, pkController, zrController, yqController
    ].map((controller) => double.tryParse(controller.text) ?? 0.0)
        .fold(0.0, (sum, value) => sum + value);
  }

  void calculateBasicFareCHGS() {
    if (isBasicFareCHGSReadOnly.value) return;

    final basicFare = double.tryParse(basicFareController.text) ?? 0.0;
    final basicFareCHGS = double.tryParse(basicFareCHGSController.text);
    final basicFareCHGSPKR = double.tryParse(basicFareCHGSPKRController.text);

    // Only calculate if we have valid numbers
    if (basicFare != 0.0) {
      if (basicFareCHGS != null && basicFareCHGSController.text.isNotEmpty) {
        // Calculate PKR value only if percentage is valid
        final calculatedPKR = (basicFareCHGS / 100) * basicFare;
        if (calculatedPKR != double.tryParse(basicFareCHGSPKRController.text)) {
          basicFareCHGSPKRController.text = calculatedPKR.round().toString();
        }
      } else if (basicFareCHGSPKR != null && basicFareCHGSPKRController.text.isNotEmpty) {
        // Calculate percentage only if PKR value is valid
        final calculatedPercentage = (basicFareCHGSPKR / basicFare) * 100;
        if (calculatedPercentage != double.tryParse(basicFareCHGSController.text)) {
          basicFareCHGSController.text = calculatedPercentage.toStringAsFixed(2);
        }
      }
    }

    update();
  }

  void calculateTotalFareCHGS() {
    if (isTotalFareReadOnly.value) return;

    final basicFare = double.tryParse(basicFareController.text) ?? 0.0;
    final otherTaxes = double.tryParse(otherTaxesController.text) ?? 0.0;
    final totalFareCHGS = double.tryParse(totalFareCHGSController.text);
    final totalFareCHGSPKR = double.tryParse(totalFareCHGSPKRController.text);
    final moreTaxes = _getSumOfMoreTaxes();

    final totalBase = basicFare + otherTaxes + moreTaxes;

    // Only calculate if we have a valid base amount
    if (totalBase != 0.0) {
      if (totalFareCHGS != null && totalFareCHGSController.text.isNotEmpty) {
        // Calculate PKR value only if percentage is valid
        final calculatedPKR = (totalFareCHGS / 100) * totalBase;
        if (calculatedPKR != double.tryParse(totalFareCHGSPKRController.text)) {
          totalFareCHGSPKRController.text = calculatedPKR.round().toString();
        }
      } else if (totalFareCHGSPKR != null && totalFareCHGSPKRController.text.isNotEmpty) {
        // Calculate percentage only if PKR value is valid
        final calculatedPercentage = (totalFareCHGSPKR / totalBase) * 100;
        if (calculatedPercentage != double.tryParse(totalFareCHGSController.text)) {
          totalFareCHGSController.text = calculatedPercentage.toStringAsFixed(2);
        }
      }
    }

    update();
  }

  void calculatePartyComm() {
    final basicFare = double.tryParse(basicFareController.text) ?? 0.0;
    final partyComm = double.tryParse(partyCommController.text);
    final partyCommPKR = double.tryParse(partyCommPKRController.text);

    // Only calculate if we have a valid basic fare
    if (basicFare != 0.0) {
      if (partyComm != null && partyCommController.text.isNotEmpty) {
        // Calculate PKR value only if percentage is valid
        final calculatedPKR = (partyComm / 100) * basicFare;
        if (calculatedPKR != double.tryParse(partyCommPKRController.text)) {
          partyCommPKRController.text = calculatedPKR.round().toString();
        }
      } else if (partyCommPKR != null && partyCommPKRController.text.isNotEmpty) {
        // Calculate percentage only if PKR value is valid
        final calculatedPercentage = (partyCommPKR / basicFare) * 100;
        if (calculatedPercentage != double.tryParse(partyCommController.text)) {
          partyCommController.text = calculatedPercentage.toStringAsFixed(2);
        }
      }
    }

    calculatePartyWHT();
    update();
  }


  void calculatePartyWHT() {
    final partyCommPKR = double.tryParse(partyCommPKRController.text) ?? 0.0;
    final partyWHT = double.tryParse(partyWHTController.text) ?? 0.0;

    if (partyCommPKR != 0 && partyWHT != 0) {
      partyWHTPKRController.text = ((partyWHT / 100) * partyCommPKR).toStringAsFixed(2);
    } else {
      partyWHTPKRController.text = '0.00';
    }
  }

  void calculatePKRTotalSelling() {
    final basicFare = double.tryParse(basicFareController.text) ?? 0.0;
    final otherTaxes = double.tryParse(otherTaxesController.text) ?? 0.0;
    final basicFareCHGSPKR = double.tryParse(basicFareCHGSPKRController.text) ?? 0.0;
    final totalFareCHGSPKR = double.tryParse(totalFareCHGSPKRController.text) ?? 0.0;
    final partyCommPKR = double.tryParse(partyCommPKRController.text) ?? 0.0;
    final partyWHTPKR = double.tryParse(partyWHTPKRController.text) ?? 0.0;
    final moreTaxes = _getSumOfMoreTaxes();

    final total = basicFare + otherTaxes + moreTaxes + basicFareCHGSPKR +
        totalFareCHGSPKR - partyCommPKR + partyWHTPKR;

    pkrTotalSellingController.text = total.round().toString();
  }

  void calculateTotal() {
    final basicFare = double.tryParse(basicFareController.text) ?? 0.0;
    final otherTaxes = double.tryParse(otherTaxesController.text) ?? 0.0;
    final moreTaxes = _getSumOfMoreTaxes();

    final total = basicFare + otherTaxes + moreTaxes;
    totalController.text = total.round().toString();
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

  void addTicketReceivingDetail() {
    ticketReceivingDetails.add({
      'name': ''.obs,
      'amount': ''.obs,
    });
  }

  void removeTicketReceivingDetail(int index) {
    if (ticketReceivingDetails.length > 1) {
      ticketReceivingDetails.removeAt(index);
    }
  }


  // Add this method to make the API call
  Future<void> saveTicketVoucher() async {
    final ApiService apiService = ApiService();

    // Prepare the data from your fields
    final Map<String, dynamic> requestBody = {
      "voucher_date": todayDate.value.toIso8601String().split('T')[0],
      "customer_account": customerAccount.value,
      "supplier_account": supplierDetail.value,
      "pax_name": paxNameController.text.trim(),
      "airline_code": airLineController.text.trim(),
      "sector": sectorController.text.trim(),
      "sector_type": sectorTypeController.text.trim(),
      "issued_from": issueFromController.text.trim(),
      "basic_fare": basicFareController.text.trim(),
      "other_taxes": otherTaxesController.text.trim(),
      "emd": emdController.text.trim(),
      "cc": ccController.text.trim(),
      "sp": spController.text.trim(),
      "rg": rgController.text.trim(),
      "yd": ydController.text.trim(),
      "e3": e3Controller.text.trim(),
      "io": ioController.text.trim(),
      "yi": yiController.text.trim(),
      "xz": xzController.text.trim(),
      "pk": pkController.text.trim(),
      "zr": zrController.text.trim(),
      "yq": yqController.text.trim(),
      "basic_charges_percent": basicFareCHGSController.text.trim(),
      "basic_charges_rs": basicFareCHGSPKRController.text.trim(),
      "total_charges_percent": totalFareCHGSController.text.trim(),
      "total_charges_rs": totalFareCHGSPKRController.text.trim(),
      "party_commission_percent": partyCommController.text.trim(),
      "party_commission_rs": partyCommPKRController.text.trim(),
      "party_wht_percent": partyWHTController.text.trim(),
      "party_wht_rs": partyWHTPKRController.text.trim(),
      "airline_commission_percent": airLineCommController.text.trim(),
      "airline_commission_rs": airLineCommPKRController.text.trim(),
      "airline_wht_percent": airLineWHTController.text.trim(),
      "airline_wht_rs": airLineWHTPKRController.text.trim(),
      "psf_percent": psfController.text.trim(),
      "psf_rs": psfPKRController.text.trim(),
      "receiving": ticketReceivingDetails.map((detail) {
        return {
          "receiving_account": detail['name'].value,
          "receiving_amount": detail['amount'].value,
        };
      }).toList(),
    };

    try {
      // Call the POST request using the ApiService
      final response = await apiService.postData(
        endpoint: 'ticketVoucher',
        body: requestBody,
      );

      // Handle the response
      if (response['status'] == 'success') {
        Get.snackbar(
          'Success',
          'Ticket voucher saved successfully.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to save ticket voucher');
      }
    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

}


// udpatedd started