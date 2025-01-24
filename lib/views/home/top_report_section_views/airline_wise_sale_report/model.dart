
class SalesData {
  final String date;
  final String pax;
  final String ticket;
  final String sector;
  final int basicFare;
  final int taxes;
  final int emd;
  final int cc;
  final double aircomm;
  final int airwht;
  final double buying;

  SalesData({
    required this.date,
    required this.pax,
    required this.ticket,
    required this.sector,
    required this.basicFare,
    required this.taxes,
    required this.emd,
    required this.cc,
    required this.aircomm,
    required this.airwht,
    required this.buying,
  });
}