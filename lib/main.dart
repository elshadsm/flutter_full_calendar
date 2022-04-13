import 'package:flutter/material.dart';
import 'package:flutter_full_calendar/providers/date_provider.dart';
import 'package:provider/provider.dart';

import '../providers/events_provider.dart';
import 'pages/week_calendar/calendar_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: EventsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: DateProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarPage(),
    );
  }
}
