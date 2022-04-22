import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/calendar_type_provider.dart';
import '../models/calendar_type.dart';

class CalendarUtil {
  static isWeekCalendar(BuildContext context) {
    final provider = Provider.of<CalendarTypeProvider>(context, listen: false);
    return provider.type == CalendarType.week;
  }
}
