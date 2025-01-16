class Customer {
  final String accountId;
  final int rank;
  final String name;
  final double ticket;
  final double hotel;
  final double visa;
  final double transport;
  final double other;
  final double total;
  final double percentage;

  Customer({
    required this.accountId,
    required this.rank,
    required this.name,
    required this.ticket,
    required this.hotel,
    required this.visa,
    required this.transport,
    required this.other,
    required this.total,
    required this.percentage,
  });

  factory Customer.fromJson(Map<String, dynamic> json, int rank) {
    return Customer(
      accountId: json['account_id'] as String,
      rank: rank,
      name: json['account_name'] as String,
      ticket: double.parse(json['ticket_sale'].toString()),
      hotel: double.parse(json['hotel_sale'].toString()),
      visa: double.parse(json['visa_sale'].toString()),
      transport: double.parse(json['transport_sale'].toString()),
      other: double.parse(json['other_sale'].toString()),
      total: double.parse(json['total_sale'].toString()),
      percentage: double.parse(json['percentage']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'rank': rank,
      'name': name,
      'ticket': ticket,
      'hotel': hotel,
      'visa': visa,
      'transport': transport,
      'other': other,
      'total': total,
      'percentage': percentage,
    };
  }
}