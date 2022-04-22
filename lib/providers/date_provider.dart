import 'package:flutter/material.dart';

class DateProvider extends ChangeNotifier {
  var _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  set selectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
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
