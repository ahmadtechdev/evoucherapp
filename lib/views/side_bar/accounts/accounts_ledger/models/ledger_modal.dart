class LedgerMasterData {
  final int accountId;
  final String accountName;
  final String fromDate;
  final String toDate;
  final String? systemCurrency;
  final String opening;
  final String closing;
  final int numVouchers;

  LedgerMasterData({
    required this.accountId,
    required this.accountName,
    required this.fromDate,
    required this.toDate,
    this.systemCurrency,
    required this.opening,
    required this.closing,
    required this.numVouchers,
  });

  factory LedgerMasterData.fromJson(Map<String, dynamic> json) {
    return LedgerMasterData(
      accountId: json['account_id'] ?? 0,
      accountName: json['account_name'] ?? '',
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      systemCurrency: json['system_currency'],
      opening: json['opening'] ?? '',
      closing: json['closing'] ?? '',
      numVouchers: json['num_vouchers'] ?? 0,
    );
  }
}

class LedgerVoucher {
  final String voucher;
  final String link;
  final String pnr;
  final String description;
  final String confnumb;
  final double debit;
  final double credit;
  final String date;
  final String addedBy;
  final String balance;

  LedgerVoucher({
    required this.voucher,
    required this.link,
    required this.pnr,
    required this.description,
    required this.confnumb,
    required this.debit,
    required this.credit,
    required this.date,
    required this.addedBy,
    required this.balance,
  });

  factory LedgerVoucher.fromJson(Map<String, dynamic> json) {
    return LedgerVoucher(
      voucher: json['voucher'] ?? '',
      link: json['link'] ?? '',
      pnr: json['pnr'] ?? '',
      description: json['description'] ?? '',
      confnumb: json['confnumb'] ?? '',
      debit: double.tryParse(json['debit'] ?? '0.00') ?? 0.00,
      credit: double.tryParse(json['credit'] ?? '0.00') ?? 0.00,
      date: json['date'] ?? '',
      addedBy: json['added_by'] ?? '',
      balance: json['balance'] ?? '',
    );
  }
}