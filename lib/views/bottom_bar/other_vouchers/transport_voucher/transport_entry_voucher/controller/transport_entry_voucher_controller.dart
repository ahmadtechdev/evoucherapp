import 'package:get/get.dart';
import '../models/models.dart';

class TransportBookingController extends GetxController {
  final date = DateTime.now().obs;
  final selectedAccount = ''.obs;
  final transportList = <TransportModel>[].obs;
  final flightList = <FlightModel>[].obs;

  // Computed values
  final totalBuyAmount = 0.0.obs;
  final totalSellAmount = 0.0.obs;
  final totalProfit = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Add initial transport entry
    addTransport();
    // Add initial flight entry
    addFlight();
  }

  void addTransport() {
    transportList.add(TransportModel());
    calculateTotals();
  }

  void removeTransport(TransportModel transport) {
    if (transportList.length > 1) {
      transportList.remove(transport);
      calculateTotals();
    } else {
      Get.snackbar(
        'Cannot Remove',
        'At least one transport entry is required',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void updateTransport(int index, String field, dynamic value) {
    if (index >= 0 && index < transportList.length) {
      final transport = transportList[index];
      final updatedTransport = transport.copyWith(
        supplierAccount: field == 'supplierAccount' ? value : null,
        flightNo: field == 'flightNo' ? value : null,
        travelDate: field == 'travelDate' ? value : null,
        travelTime: field == 'travelTime' ? value : null,
        route: field == 'route' ? value : null,
        transportReg: field == 'transportReg' ? value : null,
        capacity: field == 'capacity' ? value : null,
        driverName: field == 'driverName' ? value : null,
        driverNumber: field == 'driverNumber' ? value : null,
        buyRate: field == 'buyRate' ? value : null,
        buyingROE: field == 'buyingROE' ? value : null,
        buyingCurrency: field == 'buyingCurrency' ? value : null,
        sellRate: field == 'sellRate' ? value : null,
        sellingROE: field == 'sellingROE' ? value : null,
        sellingCurrency: field == 'sellingCurrency' ? value : null,
      );
      transportList[index] = updatedTransport;
      calculateTotals();
    }
  }

  void calculateTotals() {
    double buyAmount = 0.0;
    double sellAmount = 0.0;

    for (var transport in transportList) {
      buyAmount += transport.totalBuyAmount;
      sellAmount += transport.totalSellAmount;
    }

    totalBuyAmount.value = buyAmount;
    totalSellAmount.value = sellAmount;
    totalProfit.value = sellAmount - buyAmount;
  }

  // Validation methods
  bool isTransportValid(int index) {
    final transport = transportList[index];
    return transport.supplierAccount.isNotEmpty &&
        transport.route.isNotEmpty &&
        transport.transportReg.isNotEmpty &&
        transport.capacity.isNotEmpty &&
        transport.driverName.isNotEmpty &&
        transport.buyRate > 0 &&
        transport.sellRate > 0;
  }

  bool areAllTransportsValid() {
    return transportList.every((transport) =>
    transport.supplierAccount.isNotEmpty &&
        transport.route.isNotEmpty &&
        transport.transportReg.isNotEmpty &&
        transport.capacity.isNotEmpty &&
        transport.driverName.isNotEmpty &&
        transport.buyRate > 0 &&
        transport.sellRate > 0
    );
  }

  // Format currency values
  String formatCurrency(double amount, String currency) {
    return '${currency.toUpperCase()} ${amount.toStringAsFixed(2)}';
  }

  void addFlight() {
    flightList.add(FlightModel(
      flightNumber: '',
      departureDate: DateTime.now(),
      departureTime: '',
      arrivalTime: '',
      sectorFrom: '',
      sectorTo: '',
      arrivalDate: DateTime.now(),
    ));
  }

  void removeFlight(FlightModel flight) {
    // Don't remove if it's the last flight entry
    if (flightList.length > 1) {
      flightList.remove(flight);
    } else {
      Get.snackbar(
        'Cannot Remove',
        'At least one flight entry is required',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }


  // Update flight details
  void updateFlightDetails(int index, Map<String, dynamic> updates) {
    if (index >= 0 && index < flightList.length) {
      FlightModel flight = flightList[index];
      // Create a new flight model with updated values
      FlightModel updatedFlight = FlightModel(
        flightNumber: updates['flightNumber'] ?? flight.flightNumber,
        departureDate: updates['departureDate'] ?? flight.departureDate,
        departureTime: updates['departureTime'] ?? flight.departureTime,
        arrivalTime: updates['arrivalTime'] ?? flight.arrivalTime,
        sectorFrom: updates['sectorFrom'] ?? flight.sectorFrom,
        sectorTo: updates['sectorTo'] ?? flight.sectorTo,
        arrivalDate: updates['arrivalDate'] ?? flight.arrivalDate,
      );
      flightList[index] = updatedFlight;
    }
  }

  // Calculate totals
  double calculateTotalReceipt() {
    double total = 0;
    for (var transport in transportList) {
      total += transport.sellRate;
    }
    return total;
  }

  double calculateTotalPayment() {
    double total = 0;
    for (var transport in transportList) {
      total += transport.buyRate;
    }
    return total;
  }

  double calculateClosingBalance() {
    return calculateTotalReceipt() - calculateTotalPayment();
  }
}