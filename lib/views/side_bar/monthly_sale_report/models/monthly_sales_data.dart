// models/monthly_sales_data.dart
class MonthlySalesModel {
  final int ticketSales;
  final int hotelBookings;
  final int visaServices;

  MonthlySalesModel({
    required this.ticketSales,
    required this.hotelBookings,
    required this.visaServices,
  });

  int get total => ticketSales + hotelBookings + visaServices;

  factory MonthlySalesModel.fromJson(Map<String, dynamic> json) {
    return MonthlySalesModel(
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