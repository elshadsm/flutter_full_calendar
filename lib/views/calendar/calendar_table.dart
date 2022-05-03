import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/date_provider.dart';
import '../../resources/colors.dart';
import '../../resources/sizes.dart';
import 'table_helper.dart';
import 'event_graph.dart';

class CalendarTable extends StatefulWidget {
  CalendarTable({
    calendarType,
  }) : super(
          key: TableHelper.instance.getTableKey(
            calendarType,
          ),
        );

  @override
  State<CalendarTable> createState() => _CalendarTableState();
}

class _CalendarTableState extends State<CalendarTable> {
  final _firstCellKey = GlobalKey();
  late final DateProvider _dateProvider;
  var _isInit = true;

  List<EventGraph> _graphics = [];

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
      _dateProvider.addListener(_updateGraphics);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dateProvider.removeListener(_updateGraphics);
    super.dispose();
  }

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
            columnWidths: TableHelper.instance.createColumnWidths(
              context,
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: TableHelper.instance.createRows(
              context,
              _firstCellKey,
            ),
          ),
          ..._graphics,
        ],
      ),
    );
  }

  void _updateGraphics() {
    _graphics.clear();
    if (_firstCellKey.currentContext == null) {
      return;
    }
    final renderObject = _firstCellKey.currentContext?.findRenderObject();
    final renderBox = renderObject as RenderBox;
    setState(
      () => _graphics = TableHelper.instance.createGraphics(
        context,
        renderBox.size.width,
      ),
    );
  }
}
