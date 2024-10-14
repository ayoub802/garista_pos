import 'package:flutter/material.dart';

extension Time on DateTime {
  TimeOfDay get toTime => TimeOfDay(hour: hour, minute: minute);

  DateTime addTime(TimeOfDay time) => DateTime(year, month, day, time.hour, time.minute);
}
