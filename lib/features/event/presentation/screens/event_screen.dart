import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
        child: Column(
          children: [
            _calendar(),
            Expanded(child: _dayDetails()),
          ],
        ),
      ),
    );
  }

  Widget _calendar() {
    return Obx(() {
      final weathers = Map.of(controller.weathers);
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
                  Text(
                    '${events.length}',
                    style: AppTextstyles.txt13w700.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  SizedBox(width: 2.w),
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
          outsideDaysVisible: false,
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
          for (final event in events)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Text(event.title, style: AppTextstyles.txt13w700),
            ),
        ],
      );
    });
  }
}
