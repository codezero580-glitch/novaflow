import 'package:flutter/material.dart';
import 'package:project_novaflow/state/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _ProgressData {
  final String status;
  final double value;
  _ProgressData(this.status, this.value);
}

class _LineData {
  final String day;
  final double value;
  _LineData(this.day, this.value);
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<_ProgressData> progressData(List tasks) {
    final completed = tasks.where((t) => t.isDone).length;
    final active = tasks.where((t) => !t.isDone).length;

    return [
      _ProgressData('Completed', completed.toDouble()),
      _ProgressData('Active', active.toDouble()),
    ];
  }

  List<_LineData> lineData(List tasks) {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final Map<String, int> count = {for (var d in weekDays) d: 0};

    for (final t in tasks) {
      final weekday = t.createdAt.weekday; // 1-7
      final key = weekDays[weekday - 1];

      count[key] = count[key]! + 1;
    }

    return count.entries
        .map((e) => _LineData(e.key, e.value.toDouble()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasks;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Analytics',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Tasks",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${tasks.length}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 260,
                child: SfCircularChart(
                  title: ChartTitle(
                    text: 'Task Completion',
                    alignment: ChartAlignment.near,
                  ),
                  legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                  ),
                  series: <CircularSeries>[
                    DoughnutSeries<_ProgressData, String>(
                      dataSource: progressData(tasks),
                      xValueMapper: (d, _) => d.status,
                      yValueMapper: (d, _) => d.value,
                      innerRadius: '70%',
                      radius: '90%',
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                      pointColorMapper: (d, _) {
                        if (d.status == "Active") {
                          return Theme.of(context).colorScheme.onSurface;
                        } else {
                          return Theme.of(context).colorScheme.onSurfaceVariant;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 260,
                child: SfCartesianChart(
                  title: ChartTitle(
                    text: 'Tasks Created per Day',
                    alignment: ChartAlignment.near,
                  ),
                  plotAreaBorderWidth: 0,
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0.2),
                  ),
                  series: <CartesianSeries>[
                    SplineSeries<_LineData, String>(
                      dataSource: lineData(tasks),
                      xValueMapper: (d, _) => d.day,
                      yValueMapper: (d, _) => d.value,
                      color: Theme.of(context).colorScheme.onSurface,
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
