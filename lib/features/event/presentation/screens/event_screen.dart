import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/app_textstyles.dart';
import '../../../../core/weather_icon.dart';
import '../../../../utils/app_colors.dart';
import '../../../event_detail/presentation/bindings/event_detail_binding.dart';
import '../../../event_detail/presentation/screens/event_detail_screen.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../controllers/event_controller.dart';

class EventScreen extends GetView<EventController> {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softWhite,
      body: SafeArea(
        child: Column(
          children: [
            _calendar(),
            _filters(),
            Expanded(child: _dayDetails()),
          ],
        ),
      ),
    );
  }

  Widget _calendar() {
    return Obx(() {
      final weathers = Map.of(controller.weathers);
      controller.events.length; // rebuild when the events change
      return TableCalendar(
        firstDay: DateTime(2020),
        lastDay: DateTime(2100),
        focusedDay: controller.focusedDay.value,
        rowHeight: 64.h,
        daysOfWeekHeight: 24.h,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarFormat: CalendarFormat.week,
        availableCalendarFormats: const {CalendarFormat.week: 'Week'},
        selectedDayPredicate: (day) =>
            isSameDay(day, controller.selectedDate.value),
        eventLoader: controller.eventsOf,
        onDaySelected: controller.onDaySelected,
        onPageChanged: controller.onPageChanged,
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            final code = weathers[dayKey(day)]?.code;
            return Positioned(
              bottom: 2.h,
              child: Row(
                children: [
                  if (events.isNotEmpty) ...[
                    Text(
                      '${events.length}',
                      style: AppTextstyles.txt13w700.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(width: 2.w),
                  ],
                  Icon(
                    weatherIcon(code),
                    size: 14.r,
                    color: AppColors.primaryBlue,
                  ),
                ],
              ),
            );
          },
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          headerPadding: EdgeInsets.symmetric(vertical: 8.h),
          titleTextStyle: AppTextstyles.txt14w700.copyWith(
            color: AppColors.primaryBlue,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextstyles.txt13w700.copyWith(
            color: AppColors.lightGrey,
          ),
          weekendStyle: AppTextstyles.txt13w700.copyWith(
            color: AppColors.lightGrey,
          ),
        ),
        calendarStyle: CalendarStyle(
          cellMargin: const EdgeInsets.symmetric(horizontal: 2),
          defaultTextStyle: AppTextstyles.txt18w400,
          weekendTextStyle: AppTextstyles.txt18w400,
          todayTextStyle: AppTextstyles.txt18w400,
          selectedTextStyle: AppTextstyles.txt18w700.copyWith(
            color: AppColors.copeCode,
          ),
          // default shape is circle, it cannot have a border radius
          defaultDecoration: const BoxDecoration(),
          weekendDecoration: const BoxDecoration(),
          todayDecoration: const BoxDecoration(),
          selectedDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.blue50),
          ),
        ),
      );
    });
  }

  // the location box, tap it to change the distance (and the city)
  Widget _filters() {
    return Obx(() {
      final place = controller.usingCity.value
          ? controller.city.value.name
          : 'Current location';
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: GestureDetector(
          onTap: _openSheet,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.powderSkyBlue),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 20.r,
                  color: AppColors.primaryBlue,
                ),
                SizedBox(width: 8.w),
                Text(
                  '$place · ${controller.radiusKm.value} km',
                  style: AppTextstyles.txt14w700,
                ),
                const Spacer(),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20.r,
                  color: AppColors.primaryBlue,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _openSheet() {
    Get.bottomSheet(
      Material(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distance',
                  style: AppTextstyles.txt14w700.copyWith(
                    color: AppColors.primaryBlue,
                  ),
                ),
                for (final km in [5, 10, 25])
                  _option('$km km', controller.radiusKm.value == km, () {
                    controller.setRadius(km);
                    Get.back();
                  }),
                // the user can only choose a city when the location is off
                if (controller.usingCity.value) ...[
                  SizedBox(height: 8.h),
                  Text(
                    'City',
                    style: AppTextstyles.txt14w700.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  for (final c in cities)
                    _option(c.name, controller.city.value == c, () {
                      controller.setCity(c);
                      Get.back();
                    }),
                ],
              ],
            );
          }),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _option(String text, bool selected, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(text, style: AppTextstyles.txt13w700),
      trailing: selected
          ? const Icon(Icons.check, color: AppColors.primaryBlue)
          : null,
    );
  }

  Widget _dayDetails() {
    return Obx(() {
      final day = controller.selectedDate.value;
      final events = controller.eventsOf(day);
      final weather = controller.weatherOf(day);
      return ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          Row(
            children: [
              Icon(
                weatherIcon(weather?.code),
                size: 20.r,
                color: AppColors.primaryBlue,
              ),
              SizedBox(width: 8.w),
              Text(
                DateFormat('EEEE, d MMMM').format(day),
                style: AppTextstyles.txt14w700.copyWith(
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (events.isEmpty)
            Text(
              'No events in ${controller.radiusKm.value} km',
              style: AppTextstyles.txt13w700,
            ),
          for (final event in events) _eventTile(event),
        ],
      );
    });
  }

  Widget _eventTile(EventEntity event) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => Get.to(
        () => const EventDetailScreen(),
        binding: EventDetailBinding(),
        arguments: {
          'event': event,
          'weather': controller.weatherOf(event.start),
        },
      ),
      title: Text(event.title, style: AppTextstyles.txt14w700),
      subtitle: Text(
        '${DateFormat('HH:mm').format(event.start)} · ${event.venue} · '
        '${event.distanceKm.toStringAsFixed(1)} km',
        style: AppTextstyles.txt13w700.copyWith(color: AppColors.lightGrey),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
