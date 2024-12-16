// // search_portion.dart
//
// import 'package:flutter/material.dart';
// import '../../common/color_extension.dart';
// import '../../common_widget/custom_dropdown.dart';
// import '../../common_widget/round_textfield.dart';
//
// class SearchWidget extends StatefulWidget {
//
//   const SearchWidget({super.key});
//
//   @override
//   State<SearchWidget> createState() => _SearchWidgetState();
// }
//
// class _SearchWidgetState extends State<SearchWidget> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//     _controller.forward();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Container(
//         padding: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: TColor.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: TColor.primary.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSearchRow(
//               leftWidget: const RoundTextfield(
//                 hintText: 'Search Ticket by Ticket No.',
//               ),
//               rightButtonLabel: 'Search',
//               rightButtonIcon: Icons.flight,
//             ),
//             const SizedBox(height: 12),
//             _buildSearchRow(
//               leftWidget: const RoundTextfield(
//                 hintText: 'Search Ticket by Pax Name',
//               ),
//               rightButtonLabel: 'Search',
//               rightButtonIcon: Icons.flight_takeoff,
//             ),
//             const SizedBox(height: 12),
//             _buildSearchRow(
//               leftWidget: const RoundTextfield(
//                 hintText: 'Search Ticket by PNR',
//               ),
//               rightButtonLabel: 'Search',
//               rightButtonIcon: Icons.local_airport,
//             ),
//             const SizedBox(height: 20),
//             _buildSearchRow(
//               leftWidget: CustomDropdown(
//                 hint: 'Select An Account',
//                 items: const ['Account 1', 'Account 2', 'Account 3'], // Dummy data
//                 onChanged: (value) {},
//               ),
//               rightButtonLabel: 'Search',
//               rightButtonIcon: Icons.monetization_on,
//             ),
//             const SizedBox(height: 12),
//             _buildSearchRow(
//               leftWidget: CustomDropdown(
//                 hint: 'Select Foreign Account',
//                 items: const ['Foreign Account 1', 'Foreign Account 2'], // Dummy data
//                 onChanged: (value) {},
//               ),
//               rightButtonLabel: 'View',
//               rightButtonIcon: Icons.visibility,
//             ),
//             const SizedBox(height: 12),
//             _buildSearchRow(
//               leftWidget: CustomDropdown(
//                 hint: 'Search by Voucher No',
//                 items: const ['Voucher 1', 'Voucher 2', 'Voucher 3'], // Dummy data
//                 onChanged: (value) {},
//               ),
//               rightButtonLabel: 'View',
//               rightButtonIcon: Icons.receipt,
//             ),
//             const SizedBox(height: 20),
//             _buildSearchRow(
//               leftWidget: CustomDropdown(
//                 hint: 'Consultant Sales',
//                 items: const ['Consultant A', 'Consultant B'], // Dummy data
//                 onChanged: (value) {},
//               ),
//               rightButtonLabel: 'Cons Wise',
//               rightButtonIcon: Icons.visibility,
//             ),
//             const SizedBox(height: 12),
//             _buildSearchRow(
//               leftWidget: CustomDropdown(
//                 hint: 'Select Users',
//                 items: const ['User 1', 'User 2'], // Dummy data
//                 onChanged: (value) {},
//               ),
//               rightButtonLabel: 'User Wise',
//               rightButtonIcon: Icons.person,
//             ),
//             const SizedBox(height: 12),
//             _buildSearchRow(
//               leftWidget: CustomDropdown(
//                 hint: 'Select Multi Invoice',
//                 items: const ['Invoice 1', 'Invoice 2'], // Dummy data
//                 onChanged: (value) {},
//               ),
//               rightButtonLabel: 'Invoice',
//               rightButtonIcon: Icons.monetization_on,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSearchRow({
//     required Widget leftWidget,
//     required String rightButtonLabel,
//     required IconData rightButtonIcon,
//   }) {
//     return Row(
//       children: [
//         Expanded(child: leftWidget),
//         const SizedBox(width: 8),
//         ElevatedButton.icon(
//           onPressed: () {
//             // Handle search/view actions
//           },
//           icon: Icon(rightButtonIcon, size: 18),
//           // label: Text(rightButtonLabel),
//           label:const Icon(Icons.search),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: TColor.secondary,
//             foregroundColor: TColor.white,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }