import 'package:get/get.dart';

class EntryModel {
  String account;
  String description;
  double debit;
  double credit;
  String cheque;

  EntryModel({
    required this.account,
    required this.description,
    this.debit = 0.0,
    this.credit = 0.0,
    this.cheque = '',
  });
}

class VoucherController extends GetxController {
  var entries = <EntryModel>[].obs;
  var totalDebit = 0.0.obs;
  var totalCredit = 0.0.obs;
  var voucherType = ''.obs;

  void addEntry(EntryModel entry) {
    entries.add(entry);

    // Special handling for cash voucher
    if (voucherType.value == 'cash') {
      _handleCashVoucherMultipleEntries();
    }

    _updateTotals();
  }

  void removeEntry(int index) {
    if (index >= 0 && index < entries.length) {
      // Store the description before removing
      String description = entries[index].description;

      // Remove the original entry
      entries.removeAt(index);

      // For cash voucher, remove corresponding auto-generated entries
      if (voucherType.value == 'cash') {
        entries.removeWhere((entry) =>
        (entry.account == '101' && entry.description == description)
        );
      }

      _updateTotals();
    }
  }

  void updateEntryData(int index, String account, String description,
      double debit, double credit, String cheque) {
    if (index >= 0 && index < entries.length) {
      // Remove any existing auto-generated entries for this description
      entries.removeWhere((entry) =>
      entry.account == '101' && entry.description == entries[index].description
      );

      entries[index] = EntryModel(
        account: account,
        description: description,
        cheque: cheque,
        debit: debit,
        credit: credit,
      );

      // Special handling for cash voucher
      if (voucherType.value == 'cash' && (debit > 0 || credit > 0)) {
        _handleCashVoucherMultipleEntries();
      }

      _updateTotals();
    }
  }

  void _handleCashVoucherMultipleEntries() {
    const String cashAccountId = '101';

    // Create cash entries for all non-cash user-entered entries
    List<EntryModel> userEntries = entries.where((entry) => entry.account != cashAccountId).toList();

    // Clear existing cash entries
    entries.removeWhere((entry) => entry.account == cashAccountId);

    // Regenerate cash entries for all user entries
    for (var originalEntry in userEntries) {
      EntryModel cashEntry = EntryModel(
        account: cashAccountId, // Cash account
        description: originalEntry.description,
        cheque: originalEntry.cheque,
        debit: originalEntry.credit > 0 ? originalEntry.credit : 0.0,
        credit: originalEntry.debit > 0 ? originalEntry.debit : 0.0,
      );

      entries.add(cashEntry);
    }
  }

  void _updateTotals() {
    // Calculate totals including all entries
    totalDebit.value = entries.fold(0, (sum, entry) => sum + entry.debit);
    totalCredit.value = entries.fold(0, (sum, entry) => sum + entry.credit);
  }

  // Method to get entries for API (excluding auto-generated cash entries)
  List<EntryModel> getEntriesForApi() {
    if (voucherType.value == 'cash') {
      List<EntryModel> result = [];

      // Group user and cash entries by description
      Map<String, List<EntryModel>> entriesByDescription = {};

      // Separate user and cash entries
      List<EntryModel> userEntries = entries.where((entry) => entry.account != '101').toList();
      List<EntryModel> cashEntries = entries.where((entry) => entry.account == '101').toList();

      // Create a map of user entries by description
      for (var userEntry in userEntries) {
        entriesByDescription[userEntry.description] = [userEntry];
      }

      // Add corresponding cash entries
      for (var cashEntry in cashEntries) {
        if (entriesByDescription.containsKey(cashEntry.description)) {
          entriesByDescription[cashEntry.description]!.add(cashEntry);
        }
      }

      // Flatten the map to maintain the order with user entry first, then cash entry
      entriesByDescription.forEach((description, entries) {
        result.addAll(entries);
      });

      return result;
    }
    return entries;
  }

  void clearEntries() {
    entries.clear();
    totalDebit.value = 0.0;
    totalCredit.value = 0.0;
  }
}

