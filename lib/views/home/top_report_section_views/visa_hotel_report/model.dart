class visahotel {
  final String id;
  final String name;
  final double closingDr;
  final double closingCr;
  final String? contact;

  visahotel({
    required this.id,
    required this.name,
    required this.closingDr,
    required this.closingCr,
    this.contact,
  });
}