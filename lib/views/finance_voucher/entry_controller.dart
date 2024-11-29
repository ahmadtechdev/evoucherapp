import 'package:get/get.dart';

class EntryModel {
  String account;
  String description;
  double debit;
  double credit;

  EntryModel({
    required this.account,
    required this.description,
    this.debit = 0.0,
    this.credit = 0.0,
  });
}

class VoucherController extends GetxController {
  var entries = <EntryModel>[].obs;
  var totalDebit = 0.0.obs;
  var totalCredit = 0.0.obs;

  void addEntry(EntryModel entry) {
    entries.add(entry);
    _updateTotals();
  }

  void removeEntry(int index) {
    if (index >= 0 && index < entries.length) {
      entries.removeAt(index);
      _updateTotals();
    }
  }

  void updateEntryData(int index, String account, String description, double debit, double credit) {
    if (index >= 0 && index < entries.length) {
      entries[index] = EntryModel(
        account: account,
        description: description,
        debit: debit,
        credit: credit,
      );
      _updateTotals();
    }
  }


  void updateEntry(int index, EntryModel entry) {
    if (index >= 0 && index < entries.length) {
      entries[index] = entry;
      _updateTotals();
    }
  }

  void _updateTotals() {
    totalDebit.value = entries.fold(0, (sum, entry) => sum + entry.debit);
    totalCredit.value = entries.fold(0, (sum, entry) => sum + entry.credit);
  }

  void clearEntries() {
    entries.clear();
  }
}