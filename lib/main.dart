import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/calendar_type_provider.dart';
import 'providers/events_provider.dart';
import 'providers/date_provider.dart';
import 'app/app.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: EventsProvider(),
          ),
          ChangeNotifierProvider.value(
            value: DateProvider(),
          ),
          ChangeNotifierProvider.value(
            value: CalendarTypeProvider(),
          ),
        ],
        child: const App(),
      ),
    );
