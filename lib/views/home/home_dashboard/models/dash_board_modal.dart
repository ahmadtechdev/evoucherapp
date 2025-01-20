// models/dashboard_data.dart
class DashboardData {
  final double ticket;
  final double hotel;
  final double visa;
  final double grand;
  final String message;
  final String status;

  DashboardData({
    required this.ticket,
    required this.hotel,
    required this.visa,
    required this.grand,
    required this.message,
    required this.status,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      ticket: double.tryParse(json['ticket'].toString()) ?? 0.0,
      hotel: double.tryParse(json['hotel'].toString()) ?? 0.0,
      visa: double.tryParse(json['visa'].toString()) ?? 0.0,
      grand: double.tryParse(json['grand'].toString()) ?? 0.0,
      message: json['message'] ?? '',
      status: json['status'] ?? '',
    );
  }

  factory DashboardData.empty() {
    return DashboardData(
      ticket: 0.0,
      hotel: 0.0,
      visa: 0.0,
      grand: 0.0,
      message: '',
      status: '',
    );
  }
}