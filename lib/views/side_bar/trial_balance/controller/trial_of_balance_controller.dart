import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../service/api_service.dart';
import '../../charts_of_accounts/models/modal.dart';

class TrialOfBalanceController extends GetxController {
  var accountHeaders = <AccountHeader>[].obs;
    var selectedDate = DateTime.now().obs;


  var isLoading = false.obs;
  final ApiService _apiService = Get.put(ApiService());

  double get totalDebit =>
      accountHeaders.fold(0.0, (sum, header) => sum + header.totalDebit);

  double get totalCredit =>
      accountHeaders.fold(0.0, (sum, header) => sum + header.totalCredit);

  @override
  void onInit() {
    super.onInit();
    fetchTrialBalance();
  }

  double _parseAmount(dynamic amount) {
    if (amount == null) return 0.0;
    if (amount is num) return amount.toDouble();
    if (amount is String) {
      return double.parse(amount.replaceAll(',', ''));
    }
    return 0.0;
  }

  bool _hasNonZeroBalance(dynamic acc) {
    final debit = _parseAmount(acc['closing_dr']);
    final credit = _parseAmount(acc['closing_cr']);
    return debit != 0 || credit != 0;
  }

  Future<void> fetchTrialBalance() async {
    try {
      isLoading(true);

      final response = await _apiService.postRequest(
        endpoint: 'trialBalance',
        body: {
          "date": DateFormat('yyyy-MM-dd').format(selectedDate.value),
        },
      );

      if (response['status'] == 'success') {
        final List<AccountHeader> headers = [];

        for (var headData in response['data']) {
          List<AccountSubHeader> subHeaders = [];
          double headerTotalDebit = 0.0;
          double headerTotalCredit = 0.0;

          for (var subheadData in headData['subheads']) {
            List<AccountSubHeader> nestedSubHeaders = [];

            if (subheadData['subheads'] != null) {
              for (var nestedSubhead in subheadData['subheads']) {
                List<AccountType> accountTypes = [];

                // Filter accounts with non-zero balances
                var accounts = (nestedSubhead['accounts'] as List)
                    .where((acc) => _hasNonZeroBalance(acc))
                    .map<AccountItem>((acc) {
                  final debit = _parseAmount(acc['closing_dr']);
                  final credit = _parseAmount(acc['closing_cr']);

                  // Add to header totals
                  headerTotalDebit += debit;
                  headerTotalCredit += credit;

                  return AccountItem(
                    id: acc['account_id'],
                    name: acc['account_name'],
                    phoneNumber: acc['phone'] ?? '',
                    openingDebit: debit,
                    openingCredit: credit,
                  );
                }).toList();

                // Only add account types that have non-zero balance accounts
                if (accounts.isNotEmpty) {
                  accountTypes.add(AccountType(
                    typeName: nestedSubhead['name'],
                    accounts: accounts,
                  ));

                  nestedSubHeaders.add(AccountSubHeader(
                    name: nestedSubhead['name'],
                    id: nestedSubhead['id'],
                    addedBy: 'ADMIN',
                    accountTypes: accountTypes,
                  ));
                }
              }
            }

            // Only add subheaders if they have nested subheaders or their own non-zero accounts
            if (nestedSubHeaders.isNotEmpty) {
              subHeaders.add(AccountSubHeader(
                name: subheadData['name'],
                id: subheadData['id'],
                addedBy: 'ADMIN',
                accountTypes: [],
              ));
              subHeaders.addAll(nestedSubHeaders);
            }
          }

          // Only add headers that have subheaders with non-zero balances
          if (subHeaders.isNotEmpty) {
            headers.add(AccountHeader(
              title: headData['head_name'],
              id: headData['head_id'],
              totalDebit: headerTotalDebit,
              totalCredit: headerTotalCredit,
              subHeaders: subHeaders,
            ));
          }
        }

        accountHeaders.value = headers;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch trial balance',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}

// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../../../../service/api_service.dart';
// import '../../charts_of_accounts/models/modal.dart';

// class TrialOfBalanceController extends GetxController {
//   var accountHeaders = <AccountHeader>[].obs;
//   var selectedDate = DateTime(
//     DateTime.now().year,
//     DateTime.now().month,
//     1,
//   ).obs; // Start from the first day of the current month

//   var isLoading = false.obs;
//   final ApiService _apiService = Get.put(ApiService());

//   double get totalDebit =>
//       accountHeaders.fold(0.0, (sum, header) => sum + header.totalDebit);

//   double get totalCredit =>
//       accountHeaders.fold(0.0, (sum, header) => sum + header.totalCredit);

//   @override
//   void onInit() {
//     super.onInit();
//     fetchTrialBalance();
//   }

//   Future<void> fetchTrialBalance() async {
//     try {
//       isLoading(true);

//       final response = await _apiService.postRequest(
//         endpoint: 'trialBalance',
//         body: {
//           "date": DateFormat('yyyy-MM-dd').format(selectedDate.value),
//         },
//       );

//       if (response['status'] == 'success') {
//         final List<AccountHeader> headers = [];

//         for (var headData in response['data']) {
//           List<AccountSubHeader> subHeaders = [];

//           for (var subheadData in headData['subheads']) {
//             List<AccountSubHeader> nestedSubHeaders = [];

//             if (subheadData['subheads'] != null) {
//               for (var nestedSubhead in subheadData['subheads']) {
//                 List<AccountType> accountTypes = [];

//                 var accounts = nestedSubhead['accounts']
//                     .map<AccountItem>((acc) => AccountItem(
//                           id: acc['account_id'],
//                           name: acc['account_name'],
//                           phoneNumber: acc['phone'] ?? '',
//                           openingDebit:
//                               double.parse(acc['closing_dr'].toString()),
//                           openingCredit:
//                               double.parse(acc['closing_cr'].toString()),
//                         ))
//                     .toList();

//                 accountTypes.add(AccountType(
//                   typeName: nestedSubhead['name'],
//                   accounts: accounts,
//                 ));

//                 nestedSubHeaders.add(AccountSubHeader(
//                   name: nestedSubhead['name'],
//                   id: nestedSubhead['id'],
//                   addedBy: 'ADMIN',
//                   accountTypes: accountTypes,
//                 ));
//               }
//             }

//             subHeaders.add(AccountSubHeader(
//               name: subheadData['name'],
//               id: subheadData['id'],
//               addedBy: 'ADMIN',
//               accountTypes: [],
//             ));

//             subHeaders.addAll(nestedSubHeaders);
//           }

//           headers.add(AccountHeader(
//             title: headData['head_name'],
//             id: headData['head_id'],
//             totalDebit:
//                 double.parse(headData['head_total']['debit'].toString()),
//             totalCredit:
//                 double.parse(headData['head_total']['credit'].toString()),
//             subHeaders: subHeaders,
//           ));
//         }

//         accountHeaders.value = headers;
//       }
//     } catch (e) {
//       // print('Error fetching trial balance: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
// }