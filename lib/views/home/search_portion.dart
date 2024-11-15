// search_portion.dart

import 'package:flutter/material.dart';
import '../../common/color_extension.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by Ticket No.',
              hintStyle: TextStyle(color: TColor.placeholder),
              filled: true,
              fillColor: TColor.textfield,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: TColor.primaryText),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by Pax Name',
              hintStyle: TextStyle(color: TColor.placeholder),
              filled: true,
              fillColor: TColor.textfield,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: TColor.primaryText),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by PNR',
              hintStyle: TextStyle(color: TColor.placeholder),
              filled: true,
              fillColor: TColor.textfield,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: TColor.primaryText),
            ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              // Handle search button press
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              minimumSize: const Size.fromHeight(48.0),
            ),
            child: Text(
              'Search',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: TColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}