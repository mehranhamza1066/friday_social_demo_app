import 'package:get/get.dart';

class EventController extends GetxController {
  final selectedDate = DateTime.now().obs;
  final focusedDay = DateTime.now().obs;

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDate.value = selected;
    focusedDay.value = focused;
  }

  void onPageChanged(DateTime focused) {
    focusedDay.value = focused;
  }
}
