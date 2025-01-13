import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class RoundDropdownField extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final Color? bgColor;
  final Widget? left;
  final Widget? right;

  const RoundDropdownField({
    super.key,
    required this.hintText,
    this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.bgColor,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? TColor.textField,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          if (left != null)
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: left!,
            ),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              validator: validator,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: TColor.placeholder,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              icon: right ?? Icon(
                Icons.arrow_drop_down,
                color: TColor.placeholder,
              ),
              dropdownColor: TColor.textField,
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }
}