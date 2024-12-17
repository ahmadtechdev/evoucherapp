class Customer {
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

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      rank: json['rank'] as int,
      name: json['name'] as String,
      ticket: json['ticket'] as double,
      hotel: json['hotel'] as double,
      visa: json['visa'] as double,
      transport: json['transport'] as double,
      other: json['other'] as double,
      total: json['total'] as double,
      percentage: json['percentage'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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