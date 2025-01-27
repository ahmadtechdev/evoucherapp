class AirLine {
  final String id;
  final String name;
  final String? accountNumber;
  final double closingDr;
  final double closingCr;

  AirLine({
    required this.id,
    required this.name,
    this.accountNumber,
    required this.closingDr,
    required this.closingCr,
  });
}
