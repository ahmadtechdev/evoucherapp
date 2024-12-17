
import 'package:get/get.dart';

class HotelBookingController extends GetxController {
  // Date Fields
  final todayDate = DateTime.now().obs;
  final checkInDate = DateTime.now().obs;
  final cancellationDeadlineDate = Rx<DateTime?>(null);
  final checkOutDate = Rx<DateTime?>(null);

  // Customer Fields
  final RxString customerAccount = RxString('');
  final RxString paxName = RxString('');
  final RxString phoneNo = RxString('');
  final RxString hotelName = RxString('');
  final RxString country = RxString('');
  final RxString city = RxString('');

  // Booking Details
  final RxInt nights = RxInt(1);
  final RxInt roomsCount = RxInt(1);
  final RxString roomType = RxString('');
  final RxString meal = RxString('');

  // Guest Count
  final RxInt adultsCount = RxInt(1);
  final RxInt childrenCount = RxInt(0);

  // Selling Side Calculations
  final RxDouble roomPerNightSelling = RxDouble(0.0);
  final RxDouble totalSelling = RxDouble(0.0);
  final RxDouble roeSellingRate = RxDouble(1.0);
  final RxDouble pkrTotalSelling = RxDouble(0.0);
  final RxString sellingCurrency = RxString('');

  // Buying Side Calculations
  final RxString supplierDetail = RxString('');
  final RxString supplierConfirmationNo = RxString('');
  final RxString hotelConfirmationNo = RxString('');
  final RxString consultantName = RxString('');

  final RxDouble roomPerNightBuying = RxDouble(0.0);
  final RxDouble totalBuying = RxDouble(0.0);
  final RxDouble roeBuyingRate = RxDouble(1.0);
  final RxDouble pkrTotalBuying = RxDouble(0.0);
  final RxString buyingCurrency = RxString('');

  // Profit and Loss
  final RxDouble profit = RxDouble(0.0);
  final RxDouble loss = RxDouble(0.0);

  // Calculation Methods
  void calculateCheckOutDate() {
    if (checkInDate.value != null) {
      checkOutDate.value = checkInDate.value!.add(Duration(days: nights.value));
    }
  }

  void calculateTotalSelling() {
    totalSelling.value = roomPerNightSelling.value *
        nights.value *
        roomsCount.value;
    calculatePkrTotalSelling();
  }

  void calculatePkrTotalSelling() {
    pkrTotalSelling.value = totalSelling.value * roeSellingRate.value;
  }

  void calculateTotalBuying() {
    totalBuying.value = roomPerNightBuying.value *
        nights.value *
        roomsCount.value;
    calculatePkrTotalBuying();
  }

  void calculatePkrTotalBuying() {
    pkrTotalBuying.value = totalBuying.value * roeBuyingRate.value;
  }

  void calculateProfitLoss() {
    final profitLoss = pkrTotalSelling.value - pkrTotalBuying.value;

    if (profitLoss > 0) {
      profit.value = profitLoss;
      loss.value = 0.0;
    } else if (profitLoss < 0) {
      profit.value = 0.0;
      loss.value = profitLoss.abs();
    } else {
      profit.value = 0.0;
      loss.value = 0.0;
    }
  }

  // Guest Modification Methods
  void incrementAdults() => adultsCount.value++;
  void decrementAdults() {
    if (adultsCount.value > 1) adultsCount.value--;
  }

  void incrementChildren() => childrenCount.value++;
  void decrementChildren() {
    if (childrenCount.value > 0) childrenCount.value--;
  }

  void incrementRooms() => roomsCount.value++;
  void decrementRooms() {
    if (roomsCount.value > 1) roomsCount.value--;
  }

  void incrementNights() => nights.value++;
  void decrementNights() {
    if (nights.value > 1) nights.value--;
  }

  // Comprehensive Update Method
  void updateBookingDetails({
    DateTime? newCheckInDate,
    int? newNights,
    double? newRoomPerNightSelling,
    double? newRoeSellingRate,
    double? newRoomPerNightBuying,
    double? newRoeBuyingRate,
  }) {
    // Update check-in date if provided
    if (newCheckInDate != null) {
      checkInDate.value = newCheckInDate;
    }

    // Update nights if provided
    if (newNights != null) {
      nights.value = newNights;
    }

    // Recalculate check-out date
    calculateCheckOutDate();

    // Update selling-side details
    if (newRoomPerNightSelling != null) {
      roomPerNightSelling.value = newRoomPerNightSelling;
      calculateTotalSelling();
    }

    if (newRoeSellingRate != null) {
      roeSellingRate.value = newRoeSellingRate;
      calculatePkrTotalSelling();
    }

    // Update buying-side details
    if (newRoomPerNightBuying != null) {
      roomPerNightBuying.value = newRoomPerNightBuying;
      calculateTotalBuying();
    }

    if (newRoeBuyingRate != null) {
      roeBuyingRate.value = newRoeBuyingRate;
      calculatePkrTotalBuying();
    }

    // Recalculate profit and loss
    calculateProfitLoss();
  }

  // Validation Method
  bool validateBooking() {
    return hotelName.value.isNotEmpty &&
        paxName.value.isNotEmpty &&
        checkInDate.value != null &&
        checkOutDate.value != null &&
        roomsCount.value > 0 &&
        nights.value > 0;
  }

  // Reset Method
  void resetBooking() {
    // Reset all fields to default values
    checkInDate.value = DateTime.now();
    checkOutDate.value = null;
    nights.value = 1;
    roomsCount.value = 1;
    adultsCount.value = 1;
    childrenCount.value = 0;

    roomPerNightSelling.value = 0.0;
    totalSelling.value = 0.0;
    roeSellingRate.value = 1.0;
    pkrTotalSelling.value = 0.0;

    roomPerNightBuying.value = 0.0;
    totalBuying.value = 0.0;
    roeBuyingRate.value = 1.0;
    pkrTotalBuying.value = 0.0;

    profit.value = 0.0;
    loss.value = 0.0;

    // Clear text fields
    customerAccount.value = '';
    paxName.value = '';
    phoneNo.value = '';
    hotelName.value = '';
    country.value = '';
    city.value = '';
    supplierDetail.value = '';
  }

  @override
  void onInit() {
    // Set up listeners for automatic calculations
    ever(checkInDate, (_) => calculateCheckOutDate());
    ever(nights, (_) => calculateCheckOutDate());

    ever(roomPerNightSelling, (_) => calculateTotalSelling());
    ever(nights, (_) => calculateTotalSelling());
    ever(roomsCount, (_) => calculateTotalSelling());

    ever(roeSellingRate, (_) => calculatePkrTotalSelling());

    ever(roomPerNightBuying, (_) => calculateTotalBuying());
    ever(roeBuyingRate, (_) => calculatePkrTotalBuying());

    ever(pkrTotalSelling, (_) => calculateProfitLoss());
    ever(pkrTotalBuying, (_) => calculateProfitLoss());

    super.onInit();
  }
}