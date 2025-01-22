class Bank {
  final String id;
  final String name;
  final String? accountNumber;
  final double closingDr;
  final double closingCr;

  Bank({
    required this.id,
    required this.name,
    this.accountNumber,
    required this.closingDr,
    required this.closingCr,
  });
}
