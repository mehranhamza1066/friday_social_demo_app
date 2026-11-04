import 'package:get/get.dart';

import '../../../event/domain/entities/event_entity.dart';
import '../../../event/domain/entities/weather_entity.dart';

class EventDetailController extends GetxController {
  // both come from the event screen, nothing is fetched here
  final EventEntity event = Get.arguments['event'];
  final WeatherEntity? weather = Get.arguments['weather'];
}
