
class TransportModel {
  String supplierAccount;
  String flightNo;
  DateTime travelDate;
  String travelTime;
  String route;
  String transportReg;
  String capacity;
  String driverName;
  String driverNumber;
  double buyRate;
  double buyingROE;
  String buyingCurrency;
  double sellRate;
  double sellingROE;
  String sellingCurrency;

  // Computed properties
  double get totalBuyAmount => buyRate * buyingROE;
  double get totalSellAmount => sellRate * sellingROE;
  double get profit => totalSellAmount - totalBuyAmount;

  TransportModel({
    this.supplierAccount = '',
    this.flightNo = '',
    DateTime? travelDate,
    this.travelTime = '',
    this.route = '',
    this.transportReg = '',
    this.capacity = '',
    this.driverName = '',
    this.driverNumber = '',
    this.buyRate = 0,
    this.buyingROE = 1,
    this.buyingCurrency = 'USD',
    this.sellRate = 0,
    this.sellingROE = 1,
    this.sellingCurrency = 'USD',
  }) : travelDate = travelDate ?? DateTime.now();

  // Copy with method for easy updates
  TransportModel copyWith({
    String? supplierAccount,
    String? flightNo,
    DateTime? travelDate,
    String? travelTime,
    String? route,
    String? transportReg,
    String? capacity,
    String? driverName,
    String? driverNumber,
    double? buyRate,
    double? buyingROE,
    String? buyingCurrency,
    double? sellRate,
    double? sellingROE,
    String? sellingCurrency,
  }) {
    return TransportModel(
      supplierAccount: supplierAccount ?? this.supplierAccount,
      flightNo: flightNo ?? this.flightNo,
      travelDate: travelDate ?? this.travelDate,
      travelTime: travelTime ?? this.travelTime,
      route: route ?? this.route,
      transportReg: transportReg ?? this.transportReg,
      capacity: capacity ?? this.capacity,
      driverName: driverName ?? this.driverName,
      driverNumber: driverNumber ?? this.driverNumber,
      buyRate: buyRate ?? this.buyRate,
      buyingROE: buyingROE ?? this.buyingROE,
      buyingCurrency: buyingCurrency ?? this.buyingCurrency,
      sellRate: sellRate ?? this.sellRate,
      sellingROE: sellingROE ?? this.sellingROE,
      sellingCurrency: sellingCurrency ?? this.sellingCurrency,
    );
  }

  // Convert to Map for API calls or storage
  Map<String, dynamic> toMap() {
    return {
      'supplierAccount': supplierAccount,
      'flightNo': flightNo,
      'travelDate': travelDate.toIso8601String(),
      'travelTime': travelTime,
      'route': route,
      'transportReg': transportReg,
      'capacity': capacity,
      'driverName': driverName,
      'driverNumber': driverNumber,
      'buyRate': buyRate,
      'buyingROE': buyingROE,
      'buyingCurrency': buyingCurrency,
      'sellRate': sellRate,
      'sellingROE': sellingROE,
      'sellingCurrency': sellingCurrency,
    };
  }

  // Create from Map for API responses or storage
  factory TransportModel.fromMap(Map<String, dynamic> map) {
    return TransportModel(
      supplierAccount: map['supplierAccount'] ?? '',
      flightNo: map['flightNo'] ?? '',
      travelDate: DateTime.parse(map['travelDate']),
      travelTime: map['travelTime'] ?? '',
      route: map['route'] ?? '',
      transportReg: map['transportReg'] ?? '',
      capacity: map['capacity'] ?? '',
      driverName: map['driverName'] ?? '',
      driverNumber: map['driverNumber'] ?? '',
      buyRate: (map['buyRate'] ?? 0).toDouble(),
      buyingROE: (map['buyingROE'] ?? 1).toDouble(),
      buyingCurrency: map['buyingCurrency'] ?? 'USD',
      sellRate: (map['sellRate'] ?? 0).toDouble(),
      sellingROE: (map['sellingROE'] ?? 1).toDouble(),
      sellingCurrency: map['sellingCurrency'] ?? 'USD',
    );
  }
}

class FlightModel {
  final String flightNumber;
  final DateTime departureDate;
  final String departureTime;
  final String arrivalTime;
  final String sectorFrom;
  final String sectorTo;
  final DateTime arrivalDate;

  FlightModel({
    required this.flightNumber,
    required this.departureDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.sectorFrom,
    required this.sectorTo,
    required this.arrivalDate,
  });
}