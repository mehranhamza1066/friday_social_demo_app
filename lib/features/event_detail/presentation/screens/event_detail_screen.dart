// -- detail screen of one event
// -- shows time, venue, distance, going and forecast
// -- each line is an InfoRow

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/app_textstyles.dart';
import '../../../../core/weather_icon.dart';
import '../../../../utils/app_colors.dart';
import '../controllers/event_detail_controller.dart';
import '../widgets/info_row.dart';

class EventDetailScreen extends GetView<EventDetailController> {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final event = controller.event;
    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: AppBar(
        backgroundColor: AppColors.softWhite,
        title: Text(
          event.title,
          style: AppTextstyles.txt14w700.copyWith(color: AppColors.primaryBlue),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          InfoRow(
            icon: Icons.access_time,
            label: 'Local time',
            value: DateFormat('d MMM, HH:mm').format(event.start),
          ),
          InfoRow(
            icon: Icons.place_outlined,
            label: 'Venue',
            value: event.venue,
          ),
          InfoRow(
            icon: Icons.directions_walk,
            label: 'Distance',
            value: '${event.distanceKm.toStringAsFixed(1)} km',
          ),
          InfoRow(
            icon: Icons.people_outline,
            label: 'Going',
            value: '${event.going} / ${event.capacity}',
          ),
          InfoRow(
            icon: weatherIcon(controller.weather?.code),
            label: 'Forecast',
            value: weatherText(controller.weather?.code),
          ),
        ],
      ),
    );
  }
}
