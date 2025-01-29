import 'package:get/get.dart';

class RefundTicketController extends GetxController {
  // Observable maps for reactive state management
  var customerData = {
    'Customer Account': 'Ticket Income',
    'PAX Name': 'hsi',
    'PNR': '',
    'Ticket Number': '',
    'Airline': 'PIA',
    'Sector': 'gjlj',
    'Segments': '0',
    'Sector Type': 'domestic',
    'Basic Fare': '10',
    'Other Taxes': '0',
    'EMD': '0',
    'CC': '0',
    'SP': '0',
    'RG': '0',
    'YD': '0',
    'E3': '0',
    'IO': '0',
    'YI': '0',
    'XZ': '0',
    'PK': '0',
    'ZR': '0',
    'YQ': '0',
    'Basic Fare CHGS %': '10.00',
    'Basic Fare CHGS PKR': '1.00',
    'Total Fare CHGS % (For Selling)': '0.00',
    'Total Fare CHGS PKR (For Selling)': '0',
    'Party Comm %': '0.00',
    'Party Comm PKR': '0.00',
    'Party WHT %': '0.00',
    'Party WHT PKR': '0.00',
    'PKR Total Selling': '11.00',
    'Total': '10',
  }.obs;

  var supplierData = {
    'Supplier Account': 'Test Airline',
    'From': 'XO',
    'Consultant Name': '',
    'Airline Comm %': '0.00',
    'Airline Comm PKR': '0.00',
    'Airline WHT %': '0.00',
    'Airline WHT PKR': '0',
    'PSF %': '10.00',
    'PSF PKR': '1.00',
    'PKR Total Buying': '11.00',
    'Profit': '0.00',
    'Loss': '0.00',
  }.obs;
}
