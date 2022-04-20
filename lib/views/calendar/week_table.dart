import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/events_provider.dart';
import '../../providers/date_provider.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';
import '../../util/date_util.dart';
import 'week_table_graph.dart';
import 'week_table_cell.dart';

class WeekTable extends StatefulWidget {
  const WeekTable({
    Key? key,
  }) : super(key: key);

  @override
  State<WeekTable> createState() => _WeekTableState();
}

class _WeekTableState extends State<WeekTable> {
  final _firstCellKey = GlobalKey();
  late final DateProvider _dateProvider;
  var _isInit = true;

  List<WeekTableGraph> _graphics = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) => _updateGraphics(),
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _dateProvider = Provider.of<DateProvider>(context, listen: false);
      _dateProvider.addListener(_handleDateProviderUpdate);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dateProvider.removeListener(_handleDateProviderUpdate);
    super.dispose();
  }

  void _handleDateProviderUpdate() => _updateGraphics();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Table(
            border: TableBorder.all(
              width: AppSizes.dividerSize,
              color: AppColors.dividerBackground,
            ),
            columnWidths: _createTableColumnWidths(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: _createTableRows(),
          ),
          ..._graphics,
        ],
      ),
    );
  }

  Map<int, TableColumnWidth> _createTableColumnWidths() => const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
        5: FlexColumnWidth(),
        6: FlexColumnWidth(),
      };

  List<TableRow> _createTableRows() => List<TableRow>.generate(
        DateUtil.hoursPerDay,
        (i) => _createTableRow(i),
      );

  TableRow _createTableRow(int i) => TableRow(
        children: [
          WeekTableCell(
            key: i == 0 ? _firstCellKey : null,
          ),
          const WeekTableCell(),
          const WeekTableCell(),
          const WeekTableCell(),
          const WeekTableCell(),
          const WeekTableCell(),
          const WeekTableCell(),
        ],
      );

  void _updateGraphics() {
    _graphics.clear();
    if (_firstCellKey.currentContext == null) {
      return;
    }
    final renderObject = _firstCellKey.currentContext?.findRenderObject();
    final renderBox = renderObject as RenderBox;
    setState(
      () => _graphics = _createGraphics(renderBox.size.width),
    );
  }

  List<WeekTableGraph> _createGraphics(double cellWidth) {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final allWeekDayEvents = eventsProvider.getAllWeekDayEvents(
      dateProvider.selectedDate,
    );
    final List<WeekTableGraph> graphics = [];
    for (var weekDayEvents in allWeekDayEvents) {
      for (var event in weekDayEvents.events) {
        graphics.add(
          WeekTableGraph(
            event: event,
            weekDay: weekDayEvents.weekDay,
            cellWidth: cellWidth,
          ),
        );
      }
    }
    return graphics;
  }
}
