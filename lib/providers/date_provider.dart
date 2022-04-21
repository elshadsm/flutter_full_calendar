import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class DateProvider extends ChangeNotifier {
  var _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  set selectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  bool get isSelectedWeekNow {
    final now = DateTime.now();
    return Jiffy(_selectedDate).week == Jiffy(now).week;
  }

  bool get isSelectedDateToday {
    final now = DateTime.now();
    return now.day == _selectedDate.day &&
        now.month == _selectedDate.month &&
        now.year == _selectedDate.year;
  }

  bool isTodayInSelectedWeek(int day) {
    final now = DateTime.now();
    return isSelectedWeekNow && now.day == day;
  }

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

  void selectNextDay() {
    _selectedDate = _selectedDate.add(const Duration(days: 1));
    notifyListeners();
  }

  void selectPrevDay() {
    _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    notifyListeners();
  }

  void reset() {
    _selectedDate = DateTime.now();
    notifyListeners();
  }
}
