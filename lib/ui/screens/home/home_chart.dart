import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:flutter_training_stats_apps/ui/theme/colors.dart';
import 'package:intl/intl.dart';

class WeightChart extends StatelessWidget {
  final List<RepsElement> allReps;

  const WeightChart({super.key, required this.allReps});

  @override
  Widget build(BuildContext context) {
    final sixMonthsAgo = DateTime.now().subtract(const Duration(days: 180));
    final recentReps = allReps.where((r) => r.day.isAfter(sixMonthsAgo)).toList();

    if (recentReps.isEmpty) {
      return SizedBox(
        height: 250,
        child: Card(
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.insights, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'Нет данных для отображения',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Map<DateTime, double> maxWeightByDate = {};
    for (var rep in recentReps) {
      final date = DateTime(rep.day.year, rep.day.month, rep.day.day);
      maxWeightByDate.update(
        date,
        (value) => value > rep.weight ? value : rep.weight,
        ifAbsent: () => rep.weight,
      );
    }

    final sortedDates = maxWeightByDate.keys.toList()..sort();
    final spots = sortedDates.map((date) {
      final x = date.millisecondsSinceEpoch / (24 * 60 * 60 * 1000);
      final y = maxWeightByDate[date]!;
      return FlSpot(x, y);
    }).toList();

    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final minX = spots.first.x;
    final maxX = spots.last.x;

    return SizedBox(
      height: 250,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: maxY / 5,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: Colors.grey.withAlpha(50), strokeWidth: 1),
                getDrawingVerticalLine: (value) =>
                    FlLine(color: Colors.grey.withAlpha(50), strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      return Text(
                        '${value.toInt()}',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    interval: 30,
                    getTitlesWidget: (value, meta) {
                      final timestampMs = (value * 24 * 60 * 60 * 1000).toInt();
                      final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
                      final dateStr = DateFormat('d MMM', 'ru').format(date);
                      return SideTitleWidget(
                        meta: meta,
                        space: 10,
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Text(
                            dateStr,
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              minX: minX,
              maxX: maxX,
              minY: 0,
              maxY: maxY * 1.2,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: setsSelectedColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [Colors.blue.withAlpha(100), Colors.blue.withAlpha(0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final timestampMs = (spot.x * 24 * 60 * 60 * 1000).toInt();
                      final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
                      return LineTooltipItem(
                        '${date.day}.${date.month}.${date.year}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Вес: ${spot.y.toStringAsFixed(1)} кг',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      );
                    }).toList();
                  },
                  tooltipBorderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                handleBuiltInTouches: true,
                getTouchedSpotIndicator: (barData, spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      const FlLine(color: Colors.blue, strokeWidth: 2),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.blue,
                          );
                        },
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }
}
