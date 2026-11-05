// -- takes event and weather from Get.arguments
// -- no api call here

import 'package:get/get.dart';

import '../../../event/domain/entities/event_entity.dart';
import '../../../event/domain/entities/weather_entity.dart';

class EventDetailController extends GetxController {
  final EventEntity event = Get.arguments['event'];
  final WeatherEntity? weather = Get.arguments['weather'];
}
