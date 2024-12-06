import 'package:get/get.dart';
import '../../charts_of_accounts/models/modal.dart';


class TrialOfBalanceController extends GetxController {
  var accountHeaders = <AccountHeader>[].obs;

  double get totalDebit =>
      accountHeaders.fold(0.0, (sum, header) => sum + header.totalDebit);

  double get totalCredit =>
      accountHeaders.fold(0.0, (sum, header) => sum + header.totalCredit);

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    accountHeaders.value = getDummyData();
  }

  // utils/dummy_data.dart
  List<AccountHeader> getDummyData() {
    return [
      AccountHeader(
        title: 'Assets',
        id: '1',
        totalDebit: 8510969.00,
        totalCredit: 5217145.00,
        subHeaders: [
          AccountSubHeader(
            name: 'Receivables',
            id: '9',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Personal',
                accounts: [
                  AccountItem(
                    id: '1.1.1-101',
                    name: 'John Doe',
                    phoneNumber: '1234567890',
                    openingDebit: 1000.00,
                    openingCredit: 200.00,
                  ),
                  AccountItem(
                    id: '1.1.1-102',
                    name: 'Jane Smith',
                    phoneNumber: '0987654321',
                    openingDebit: 2000.00,
                    openingCredit: 300.00,
                  ),
                  AccountItem(
                    id: '1.1.1-103',
                    name: 'Alice Brown',
                    phoneNumber: '1122334455',
                    openingDebit: 1500.00,
                    openingCredit: 500.00,
                  ),
                  AccountItem(
                    id: '1.1.1-104',
                    name: 'Bob White',
                    phoneNumber: '6677889900',
                    openingDebit: 3000.00,
                    openingCredit: 400.00,
                  ),
                  AccountItem(
                    id: '1.1.1-105',
                    name: 'Eve Black',
                    phoneNumber: '7788990011',
                    openingDebit: 1200.00,
                    openingCredit: 100.00,
                  ),
                ],
              ),
              AccountType(
                typeName: 'Corporate',
                accounts: [
                  AccountItem(
                    id: '1.1.1-201',
                    name: 'Acme Corp',
                    phoneNumber: '2233445566',
                    openingDebit: 5000.00,
                    openingCredit: 2000.00,
                  ),
                  AccountItem(
                    id: '1.1.1-202',
                    name: 'Global Tech',
                    phoneNumber: '3344556677',
                    openingDebit: 8000.00,
                    openingCredit: 1000.00,
                  ),
                  AccountItem(
                    id: '1.1.1-203',
                    name: 'Mega Industries',
                    phoneNumber: '4455667788',
                    openingDebit: 9000.00,
                    openingCredit: 3000.00,
                  ),
                  AccountItem(
                    id: '1.1.1-204',
                    name: 'Prime LLC',
                    phoneNumber: '5566778899',
                    openingDebit: 7500.00,
                    openingCredit: 2500.00,
                  ),
                  AccountItem(
                    id: '1.1.1-205',
                    name: 'NextGen Solutions',
                    phoneNumber: '6677889900',
                    openingDebit: 6000.00,
                    openingCredit: 4000.00,
                  ),
                ],
              ),
              AccountType(
                typeName: 'Investments',
                accounts: [
                  AccountItem(
                    id: '1.1.1-301',
                    name: 'Investment A',
                    phoneNumber: '7788991122',
                    openingDebit: 3500.00,
                    openingCredit: 2000.00,
                  ),
                  AccountItem(
                    id: '1.1.1-302',
                    name: 'Investment B',
                    phoneNumber: '8899002233',
                    openingDebit: 4200.00,
                    openingCredit: 1500.00,
                  ),
                  AccountItem(
                    id: '1.1.1-303',
                    name: 'Investment C',
                    phoneNumber: '9988773344',
                    openingDebit: 5000.00,
                    openingCredit: 2500.00,
                  ),
                ],
              ),
            ],
          ),
          AccountSubHeader(
            name: 'Inventory',
            id: '10',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Raw Materials',
                accounts: [
                  AccountItem(
                    id: '1.1.2-101',
                    name: 'Material A',
                    phoneNumber: '1122334455',
                    openingDebit: 4000.00,
                    openingCredit: 500.00,
                  ),
                  AccountItem(
                    id: '1.1.2-102',
                    name: 'Material B',
                    phoneNumber: '2233445566',
                    openingDebit: 6000.00,
                    openingCredit: 1200.00,
                  ),
                ],
              ),
              AccountType(
                typeName: 'Finished Goods',
                accounts: [
                  AccountItem(
                    id: '1.1.2-201',
                    name: 'Product A',
                    phoneNumber: '3344556677',
                    openingDebit: 5000.00,
                    openingCredit: 2000.00,
                  ),
                  AccountItem(
                    id: '1.1.2-202',
                    name: 'Product B',
                    phoneNumber: '4455667788',
                    openingDebit: 3000.00,
                    openingCredit: 1000.00,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      AccountHeader(
        title: 'Liabilities',
        id: '2',
        totalDebit: 4210145.00,
        totalCredit: 8100569.00,
        subHeaders: [
          AccountSubHeader(
            name: 'Payables',
            id: '19',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Suppliers',
                accounts: [
                  AccountItem(
                    id: '2.1.1-301',
                    name: 'Supplier A',
                    phoneNumber: '8899001122',
                    openingDebit: 3000.00,
                    openingCredit: 7000.00,
                  ),
                  AccountItem(
                    id: '2.1.1-302',
                    name: 'Supplier B',
                    phoneNumber: '9988776655',
                    openingDebit: 2000.00,
                    openingCredit: 5000.00,
                  ),
                  AccountItem(
                    id: '2.1.1-303',
                    name: 'Supplier C',
                    phoneNumber: '5544332211',
                    openingDebit: 1000.00,
                    openingCredit: 6000.00,
                  ),
                  AccountItem(
                    id: '2.1.1-304',
                    name: 'Supplier D',
                    phoneNumber: '7766554433',
                    openingDebit: 4000.00,
                    openingCredit: 8000.00,
                  ),
                  AccountItem(
                    id: '2.1.1-305',
                    name: 'Supplier E',
                    phoneNumber: '6677889900',
                    openingDebit: 5000.00,
                    openingCredit: 9000.00,
                  ),
                ],
              ),
            ],
          ),
          AccountSubHeader(
            name: 'Loans',
            id: '20',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Bank Loans',
                accounts: [
                  AccountItem(
                    id: '2.1.2-101',
                    name: 'Bank A',
                    phoneNumber: '1122334455',
                    openingDebit: 25000.00,
                    openingCredit: 10000.00,
                  ),
                  AccountItem(
                    id: '2.1.2-102',
                    name: 'Bank B',
                    phoneNumber: '2233445566',
                    openingDebit: 30000.00,
                    openingCredit: 15000.00,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      AccountHeader(
        title: 'Equity',
        id: '3',
        totalDebit: 1500000.00,
        totalCredit: 1500000.00,
        subHeaders: [
          AccountSubHeader(
            name: 'Owner\'s Equity',
            id: '30',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Capital',
                accounts: [
                  AccountItem(
                    id: '3.1.1-101',
                    name: 'Owner A',
                    phoneNumber: '7788990011',
                    openingDebit: 500000.00,
                    openingCredit: 500000.00,
                  ),
                  AccountItem(
                    id: '3.1.1-102',
                    name: 'Owner B',
                    phoneNumber: '8899001122',
                    openingDebit: 1000000.00,
                    openingCredit: 1000000.00,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      AccountHeader(
        title: 'Revenue',
        id: '4',
        totalDebit: 25000000.00,
        totalCredit: 40000000.00,
        subHeaders: [
          AccountSubHeader(
            name: 'Sales',
            id: '40',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Domestic Sales',
                accounts: [
                  AccountItem(
                    id: '4.1.1-101',
                    name: 'Customer A',
                    phoneNumber: '6677889900',
                    openingDebit: 10000.00,
                    openingCredit: 20000.00,
                  ),
                  AccountItem(
                    id: '4.1.1-102',
                    name: 'Customer B',
                    phoneNumber: '7788990011',
                    openingDebit: 5000.00,
                    openingCredit: 15000.00,
                  ),
                ],
              ),
              AccountType(
                typeName: 'International Sales',
                accounts: [
                  AccountItem(
                    id: '4.1.1-201',
                    name: 'Customer C',
                    phoneNumber: '8899001122',
                    openingDebit: 20000.00,
                    openingCredit: 40000.00,
                  ),
                  AccountItem(
                    id: '4.1.1-202',
                    name: 'Customer D',
                    phoneNumber: '9988772233',
                    openingDebit: 30000.00,
                    openingCredit: 60000.00,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      AccountHeader(
        title: 'Expenses',
        id: '5',
        totalDebit: 12000000.00,
        totalCredit: 5000000.00,
        subHeaders: [
          AccountSubHeader(
            name: 'Operating Expenses',
            id: '50',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Utilities',
                accounts: [
                  AccountItem(
                    id: '5.1.1-101',
                    name: 'Electricity',
                    phoneNumber: '1122334455',
                    openingDebit: 5000.00,
                    openingCredit: 0.00,
                  ),
                  AccountItem(
                    id: '5.1.1-102',
                    name: 'Water',
                    phoneNumber: '2233445566',
                    openingDebit: 3000.00,
                    openingCredit: 0.00,
                  ),
                  AccountItem(
                    id: '5.1.1-103',
                    name: 'Internet',
                    phoneNumber: '3344556677',
                    openingDebit: 1500.00,
                    openingCredit: 0.00,
                  ),
                ],
              ),
              AccountType(
                typeName: 'Rentals',
                accounts: [
                  AccountItem(
                    id: '5.1.2-101',
                    name: 'Office Rent',
                    phoneNumber: '4455667788',
                    openingDebit: 10000.00,
                    openingCredit: 0.00,
                  ),
                  AccountItem(
                    id: '5.1.2-102',
                    name: 'Warehouse Rent',
                    phoneNumber: '5566778899',
                    openingDebit: 8000.00,
                    openingCredit: 0.00,
                  ),
                ],
              ),
            ],
          ),
          AccountSubHeader(
            name: 'Administrative Expenses',
            id: '51',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Salaries',
                accounts: [
                  AccountItem(
                    id: '5.2.1-101',
                    name: 'Employee Salaries',
                    phoneNumber: '6677889900',
                    openingDebit: 30000.00,
                    openingCredit: 0.00,
                  ),
                ],
              ),
              AccountType(
                typeName: 'Office Supplies',
                accounts: [
                  AccountItem(
                    id: '5.2.2-101',
                    name: 'Stationery',
                    phoneNumber: '7788990011',
                    openingDebit: 500.00,
                    openingCredit: 0.00,
                  ),
                  AccountItem(
                    id: '5.2.2-102',
                    name: 'Printer Toner',
                    phoneNumber: '8899001122',
                    openingDebit: 300.00,
                    openingCredit: 0.00,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      AccountHeader(
        title: 'Income',
        id: '6',
        totalDebit: 0.00,
        totalCredit: 15000000.00,
        subHeaders: [
          AccountSubHeader(
            name: 'Service Revenue',
            id: '60',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Consulting',
                accounts: [
                  AccountItem(
                    id: '6.1.1-101',
                    name: 'Consulting A',
                    phoneNumber: '9988776655',
                    openingDebit: 0.00,
                    openingCredit: 100000.00,
                  ),
                  AccountItem(
                    id: '6.1.1-102',
                    name: 'Consulting B',
                    phoneNumber: '1122334455',
                    openingDebit: 0.00,
                    openingCredit: 200000.00,
                  ),
                ],
              ),
              AccountType(
                typeName: 'Technical Services',
                accounts: [
                  AccountItem(
                    id: '6.1.2-101',
                    name: 'Tech Service A',
                    phoneNumber: '3344556677',
                    openingDebit: 0.00,
                    openingCredit: 150000.00,
                  ),
                  AccountItem(
                    id: '6.1.2-102',
                    name: 'Tech Service B',
                    phoneNumber: '4455667788',
                    openingDebit: 0.00,
                    openingCredit: 250000.00,
                  ),
                ],
              ),
            ],
          ),
          AccountSubHeader(
            name: 'Rental Income',
            id: '61',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Property Rentals',
                accounts: [
                  AccountItem(
                    id: '6.2.1-101',
                    name: 'Building A',
                    phoneNumber: '5566778899',
                    openingDebit: 0.00,
                    openingCredit: 50000.00,
                  ),
                  AccountItem(
                    id: '6.2.1-102',
                    name: 'Building B',
                    phoneNumber: '6677889900',
                    openingDebit: 0.00,
                    openingCredit: 75000.00,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      AccountHeader(
        title: 'Tax Liabilities',
        id: '7',
        totalDebit: 200000.00,
        totalCredit: 500000.00,
        subHeaders: [
          AccountSubHeader(
            name: 'Sales Tax',
            id: '70',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'State Tax',
                accounts: [
                  AccountItem(
                    id: '7.1.1-101',
                    name: 'State Tax A',
                    phoneNumber: '7788990011',
                    openingDebit: 1000.00,
                    openingCredit: 20000.00,
                  ),
                ],
              ),
              AccountType(
                typeName: 'Federal Tax',
                accounts: [
                  AccountItem(
                    id: '7.1.2-101',
                    name: 'Federal Tax A',
                    phoneNumber: '8899001122',
                    openingDebit: 5000.00,
                    openingCredit: 30000.00,
                  ),
                ],
              ),
            ],
          ),
          AccountSubHeader(
            name: 'Income Tax',
            id: '71',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Corporate Tax',
                accounts: [
                  AccountItem(
                    id: '7.2.1-101',
                    name: 'Corporate Tax A',
                    phoneNumber: '9988776655',
                    openingDebit: 20000.00,
                    openingCredit: 50000.00,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      AccountHeader(
        title: 'Investments',
        id: '8',
        totalDebit: 8000000.00,
        totalCredit: 7000000.00,
        subHeaders: [
          AccountSubHeader(
            name: 'Short-term Investments',
            id: '80',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Stocks',
                accounts: [
                  AccountItem(
                    id: '8.1.1-101',
                    name: 'Stock A',
                    phoneNumber: '3344556677',
                    openingDebit: 100000.00,
                    openingCredit: 50000.00,
                  ),
                  AccountItem(
                    id: '8.1.1-102',
                    name: 'Stock B',
                    phoneNumber: '4455667788',
                    openingDebit: 200000.00,
                    openingCredit: 100000.00,
                  ),
                ],
              ),
              AccountType(
                typeName: 'Bonds',
                accounts: [
                  AccountItem(
                    id: '8.1.2-101',
                    name: 'Bond A',
                    phoneNumber: '5566778899',
                    openingDebit: 150000.00,
                    openingCredit: 75000.00,
                  ),
                  AccountItem(
                    id: '8.1.2-102',
                    name: 'Bond B',
                    phoneNumber: '6677889900',
                    openingDebit: 120000.00,
                    openingCredit: 60000.00,
                  ),
                ],
              ),
            ],
          ),
          AccountSubHeader(
            name: 'Long-term Investments',
            id: '81',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Real Estate',
                accounts: [
                  AccountItem(
                    id: '8.2.1-101',
                    name: 'Property A',
                    phoneNumber: '7788990011',
                    openingDebit: 500000.00,
                    openingCredit: 300000.00,
                  ),
                  AccountItem(
                    id: '8.2.1-102',
                    name: 'Property B',
                    phoneNumber: '8899001122',
                    openingDebit: 700000.00,
                    openingCredit: 400000.00,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      AccountHeader(
        title: 'Deferred Liabilities',
        id: '9',
        totalDebit: 1000000.00,
        totalCredit: 2000000.00,
        subHeaders: [
          AccountSubHeader(
            name: 'Pension Obligations',
            id: '90',
            addedBy: 'ADMIN',
            accountTypes: [
              AccountType(
                typeName: 'Employee Pension',
                accounts: [
                  AccountItem(
                    id: '9.1.1-101',
                    name: 'Pension A',
                    phoneNumber: '9988776655',
                    openingDebit: 500000.00,
                    openingCredit: 1000000.00,
                  ),
                  AccountItem(
                    id: '9.1.1-102',
                    name: 'Pension B',
                    phoneNumber: '1122334455',
                    openingDebit: 300000.00,
                    openingCredit: 500000.00,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];
  }

}