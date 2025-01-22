class ariline {
  final String id;
  final String name;
  final String? accountNumber;
  final double closingDr;
  final double closingCr;

  ariline({
    required this.id,
    required this.name,
    this.accountNumber,
    required this.closingDr,
    required this.closingCr,
  });
}
