// models/monthly_sales_data.dart
class MonthlySalesData {
  final int ticketSales;
  final int hotelBookings;
  final int visaServices;

  MonthlySalesData({
    required this.ticketSales,
    required this.hotelBookings,
    required this.visaServices,
  });

  int get total => ticketSales + hotelBookings + visaServices;

  factory MonthlySalesData.fromJson(Map<String, dynamic> json) {
    return MonthlySalesData(
      ticketSales: json['ticketSales'] as int,
      hotelBookings: json['hotelBookings'] as int,
      visaServices: json['visaServices'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketSales': ticketSales,
      'hotelBookings': hotelBookings,
      'visaServices': visaServices,
    };
  }
}