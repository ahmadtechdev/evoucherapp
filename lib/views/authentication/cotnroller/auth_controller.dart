import 'package:get/get.dart';
import '../../../service/api_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  var baseUrl = "https://default.api.com/".obs; // Observable base URL

  void setBaseUrl(String client) {
    switch (client) {
      case 'Travel':
        baseUrl.value = "https://evoucher.pk/api-new/";
        break;
      case 'Travel 1':
        baseUrl.value = "https://api.travel1.com/";
        break;
      case 'Travel 2':
        baseUrl.value = "https://api.travel2.com/";
        break;
      case 'Travel 3':
        baseUrl.value = "https://api.travel3.com/";
        break;
      case 'TOC':
        baseUrl.value = "https://api.toc.com/";
        break;
      default:
        baseUrl.value = "https://api.default.com/";
    }
    print(baseUrl.value);
    // Update the ApiService base URL in real-time
    _apiService.updateBaseUrl(baseUrl.value);
  }


}
