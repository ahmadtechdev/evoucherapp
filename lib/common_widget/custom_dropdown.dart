import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final Map<String, String>
  items; // Changed from List<String> to Map<String, String>
  final String? selectedItemId; // Changed to store the selected item's ID
  final ValueChanged<String?>? onChanged;
  final bool enabled;
  final bool showSearch;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.items,
    this.selectedItemId,
    this.onChanged,
    this.enabled = true,
    this.showSearch = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      enabled: enabled,
      popupProps: PopupProps.menu(
        showSearchBox: showSearch,
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
      items: items.values.toList(), // Use the names for display
      selectedItem: selectedItemId != null ? items[selectedItemId] : null,
      onChanged: (selectedName) {
        // Find the corresponding ID when a name is selected
        final selectedId = items.keys.firstWhere(
              (id) => items[id] == selectedName,
          orElse: () => '',
        );
        onChanged?.call(selectedId);
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          filled: true,
          fillColor: TColor.textfield,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: hint,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
