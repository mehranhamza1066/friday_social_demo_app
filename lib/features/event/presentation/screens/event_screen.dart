import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/app_textstyles.dart';
import '../../../../utils/app_colors.dart';
import '../../domain/entities/weather_entity.dart';
import '../controllers/event_controller.dart';
import '../widgets/weather_icon.dart';

class EventScreen extends GetView<EventController> {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softWhite,
      body: SafeArea(
        child: Obx(() {
          final weathers = controller.weathers.toList();
          return TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2100),
            focusedDay: controller.focusedDay.value,
            rowHeight: 64.h,
            daysOfWeekHeight: 24.h,
            calendarFormat: CalendarFormat.week,
            availableCalendarFormats: const {CalendarFormat.week: 'Week'},
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) =>
                isSameDay(day, controller.selectedDate.value),
            eventLoader: (day) =>
                weathers.where((w) => isSameDay(w.date, day)).toList(),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return null;
                final weather = events.first as WeatherEntity;
                return Positioned(
                  bottom: 2.h,
                  child: Icon(
                    weatherIcon(weather.code),
                    size: 14.r,
                    color: AppColors.primaryBlue,
                  ),
                );
              },
            ),
            onDaySelected: controller.onDaySelected,
            onPageChanged: controller.onPageChanged,
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
        }),
      ),
    );
  }
}
