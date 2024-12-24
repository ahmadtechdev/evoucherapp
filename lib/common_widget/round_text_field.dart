import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Color? bgColor;
  final Widget? left;
  final Widget? right; // Optional right-side icon or widget
  final Function(String)? onChanged;

  const RoundTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.bgColor,
    this.left,
    this.right,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: bgColor ?? TColor.textfield,
          borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          if (left != null)
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: left!,
            ),
          Expanded(
            child: TextField(
              autocorrect: false,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              onChanged: onChanged,

              decoration: InputDecoration(

                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                    color: TColor.placeholder,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),

            ),
          ),
          if (right != null)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: right!,
            ),
        ],
      ),
    );
  }
}

class SearchTextField extends StatelessWidget{
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String> onChange;

  const SearchTextField({
    super.key,

    required this.hintText,
    this.controller,
    required this.onChange,

  });

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: onChange,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: TColor.placeholder),
          prefixIcon: Icon(Icons.search, color: TColor.secondary),
          filled: true,
          fillColor: TColor.textfield,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColor.secondary),
          ),
        ),
      ),
    );
  }

}

class RoundTitleTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final Color? bgColor;
  final Widget? left;
  final Widget? right;
  final Function(String)? onChanged;
  final String? initialValue;
  final VoidCallback? onEditingComplete;  // Added this line
  final Color? textclr;

  const RoundTitleTextfield({
    super.key,
    required this.title,
    this.hintText = "",
    this.controller,
    this.keyboardType,
    this.bgColor,
    this.left,
    this.right,
    this.onChanged,
    this.initialValue,
    this.obscureText = false,
    this.readOnly = false,
    this.onEditingComplete,
    this.textclr,// Added this line
  });

  @override
  Widget build(BuildContext context) {
    final effectiveController = controller ?? TextEditingController();

    if (initialValue != null && effectiveController.text.isEmpty) {
      effectiveController.text = initialValue!;
    }

    return Container(
      height: 55,
      decoration: BoxDecoration(
          color: bgColor ?? TColor.textfield,
          borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          if (left != null)
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: left!,
            ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 55,
                  margin: const EdgeInsets.only(top: 8),
                  alignment: Alignment.topLeft,
                  child: TextField(
                    style: TextStyle(color: textclr ?? TColor.primaryText),
                    autocorrect: false,
                    controller: effectiveController,
                    obscureText: obscureText,
                    keyboardType: keyboardType,
                    readOnly: readOnly,
                    onChanged: onChanged,
                    onEditingComplete: onEditingComplete,  // Added this line
                    decoration: InputDecoration(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(
                          color: TColor.placeholder,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  margin: const EdgeInsets.only(top: 10, left: 20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    style: TextStyle(color: TColor.placeholder, fontSize: 11),
                  ),
                )
              ],
            ),
          ),
          if (right != null)
            Padding(
              padding: const EdgeInsets.only(right: 0),
              child: right!,
            ),
        ],
      ),
    );
  }
}
