import 'package:evoucher_new/views/home/top_report_section_views/airline_wise_sale_report/model.dart';
import 'package:get/get.dart';

class SalesReportController extends GetxController {
  final List<SalesData> salesData = [
    SalesData(
      date: 'Fri, 08 Nov 2024',
      pax: 'MANSOOR ASAD MR',
      ticket: '212290832007',
      sector: 'LHE-BKK-CAN-BKK-LHE',
      basicFare: 710890,
      taxes: 310800,
      emd: 0,
      cc: 0,
      aircomm: 0.0,
      airwht: 0,
      buying: 1027390.00,
    ),
    SalesData(
      date: 'Fri, 08 Nov 2024',
      pax: 'MANSOOR ASAD MR',
      ticket: '212290832007',
      sector: 'LHE-BKK-CAN-BKK-LHE',
      basicFare: 710890,
      taxes: 310800,
      emd: 0,
      cc: 0,
      aircomm: 0.0,
      airwht: 0,
      buying: 1027390.00,
    ),
    // Add more sales data here
  ];
}
