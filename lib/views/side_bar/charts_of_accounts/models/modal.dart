// Define the models accordingly
class AccountHeader {
  String title;
  String id;
  double totalDebit;
  double totalCredit;
  List<AccountSubHeader> subHeaders;

  AccountHeader({
    required this.title,
    required this.id,
    required this.totalDebit,
    required this.totalCredit,
    required this.subHeaders,
  });
}

class AccountSubHeader {
  String name;
  String id;
  String addedBy;
  List<AccountType> accountTypes;

  AccountSubHeader({
    required this.name,
    required this.id,
    required this.addedBy,
    required this.accountTypes,
  });
}

class AccountType {
  String typeName;
  List<AccountItem> accounts;

  AccountType({
    required this.typeName,
    required this.accounts,
  });
}

class AccountItem {
  String id;
  String name;
  String phoneNumber;
  double openingDebit;
  double openingCredit;

  AccountItem({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.openingDebit,
    required this.openingCredit,
  });
}
