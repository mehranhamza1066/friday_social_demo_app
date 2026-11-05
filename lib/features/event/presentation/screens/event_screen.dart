// -- main screen
// -- week calendar with count + weather icon on each day
// -- box to change distance/city (bottom sheet)
// -- list of events of selected day, tap opens detail

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
            calendar(),
            locationBox(),
            Expanded(child: dayDetails()),
          ],
        ),
      ),
    );
  }

  Widget calendar() {
    return Obx(() {
      // Obx needs to read these, so the calendar rebuilds when they change
      controller.events.length;
      controller.weathers.length;

      return TableCalendar<EventEntity>(
        firstDay: DateTime(2020),
        lastDay: DateTime(2100),
        focusedDay: controller.focusedDay.value,
        rowHeight: 64.h,
        daysOfWeekHeight: 24.h,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarFormat: CalendarFormat.week,
        availableCalendarFormats: const {CalendarFormat.week: 'Week'},
        selectedDayPredicate: (day) => isSameDay(day, controller.selectedDate.value),
        eventLoader: controller.eventsOf,
        onDaySelected: controller.onDaySelected,
        onPageChanged: controller.onPageChanged,
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            // badge is "going/total" if the user is going to some events
            int going = events.where((e) => e.isGoing).length;
            String badge = going > 0 ? '$going/${events.length}' : '${events.length}';

            return Positioned(
              bottom: 2.h,
              child: Row(
                children: [
                  if (events.isNotEmpty) Text('$badge ', style: AppTextstyles.txt13w700.copyWith(color: AppColors.primaryBlue)),
                  Icon(weatherIcon(controller.weatherOf(day)?.code), size: 14.r, color: AppColors.primaryBlue),
                ],
              ),
            );
          },
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          headerPadding: EdgeInsets.symmetric(vertical: 8.h),
          titleTextStyle: AppTextstyles.txt14w700.copyWith(color: AppColors.primaryBlue),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextstyles.txt13w700.copyWith(color: AppColors.lightGrey),
          weekendStyle: AppTextstyles.txt13w700.copyWith(color: AppColors.lightGrey),
        ),
        calendarStyle: CalendarStyle(
          cellMargin: const EdgeInsets.symmetric(horizontal: 2),
          defaultTextStyle: AppTextstyles.txt18w400,
          weekendTextStyle: AppTextstyles.txt18w400,
          todayTextStyle: AppTextstyles.txt18w400,
          selectedTextStyle: AppTextstyles.txt18w700.copyWith(color: AppColors.copeCode),
          // the default shape is a circle, it can not have a border radius
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

  Widget locationBox() {
    return Obx(() {
      String place = controller.usingCity.value ? controller.city.value.name : 'Current location';
      return GestureDetector(
        onTap: openSheet,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.powderSkyBlue),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20.r, color: AppColors.primaryBlue),
              SizedBox(width: 8.w),
              Text('$place · ${controller.radiusKm.value} km', style: AppTextstyles.txt14w700),
              const Spacer(),
              Icon(Icons.keyboard_arrow_down, size: 20.r, color: AppColors.primaryBlue),
            ],
          ),
        ),
      );
    });
  }

  void openSheet() {
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
                title('Distance'),
                for (int km in [5, 10, 25])
                  option('$km km', controller.radiusKm.value == km, () => controller.setRadius(km)),
                if (controller.usingCity.value) title('City'),
                if (controller.usingCity.value)
                  for (CityEntity c in cities) option(c.name, controller.city.value == c, () => controller.setCity(c)),
              ],
            );
          }),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget title(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(text, style: AppTextstyles.txt14w700.copyWith(color: AppColors.primaryBlue)),
    );
  }

  Widget option(String text, bool selected, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        onTap();
        Get.back();
      },
      title: Text(text, style: AppTextstyles.txt13w700),
      trailing: selected ? const Icon(Icons.check, color: AppColors.primaryBlue) : null,
    );
  }

  Widget dayDetails() {
    return Obx(() {
      DateTime day = controller.selectedDate.value;
      List<EventEntity> events = controller.eventsOf(day);

      return ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          Row(
            children: [
              Icon(weatherIcon(controller.weatherOf(day)?.code), size: 20.r, color: AppColors.primaryBlue),
              SizedBox(width: 8.w),
              Text(DateFormat('EEEE, d MMMM').format(day), style: AppTextstyles.txt14w700.copyWith(color: AppColors.primaryBlue)),
            ],
          ),
          if (events.isEmpty) Text('No events in ${controller.radiusKm.value} km', style: AppTextstyles.txt13w700),
          for (EventEntity event in events) eventTile(event),
        ],
      );
    });
  }

  Widget eventTile(EventEntity event) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => Get.to(
        () => const EventDetailScreen(),
        binding: EventDetailBinding(),
        arguments: {'event': event, 'weather': controller.weatherOf(event.start)},
      ),
      title: Text(event.title, style: AppTextstyles.txt14w700),
      subtitle: Text(
        '${DateFormat('HH:mm').format(event.start)} · ${event.venue} · ${event.distanceKm} km · ${event.going}/${event.capacity} going',
        style: AppTextstyles.txt13w700.copyWith(color: AppColors.lightGrey),
      ),
      trailing: TextButton(
        onPressed: event.isGoing ? null : () => controller.rsvp(event),
        child: Text(event.isGoing ? 'Going' : 'RSVP'),
      ),
    );
  }
}
