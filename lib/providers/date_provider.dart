import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class DateProvider extends ChangeNotifier {
  var _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  bool get isSelectedWeekNow {
    final now = DateTime.now();
    return Jiffy(_selectedDate).week == Jiffy(now).week;
  }

  bool isTodayInSelectedWeek(int day) =>
      isSelectedWeekNow && _selectedDate.day == day;

  void selectNextWeek() {
    _selectedDate =
        _selectedDate.add(const Duration(days: DateTime.daysPerWeek));
    notifyListeners();
  }

  void selectPrevWeek() {
    _selectedDate =
        _selectedDate.subtract(const Duration(days: DateTime.daysPerWeek));
    notifyListeners();
  }

  void reset() {
    _selectedDate = DateTime.now();
    notifyListeners();
  }
}
