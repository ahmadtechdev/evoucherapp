import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?>? onChanged;
  final bool enabled;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.items,
    this.selectedItem,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      enabled: enabled,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Search...",
            prefixIcon: Icon(Icons.search, color: TColor.placeholder),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: TColor.textfield,
          ),
        ),
        showSelectedItems: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 2,
        ),
      ),
      items: items,
      selectedItem: selectedItem,
      onChanged: onChanged,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          filled: true,
          fillColor: TColor.textfield,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}