import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';

class RepsGraph extends StatelessWidget {
  final List<RepsElement> workoutsData;

  const RepsGraph({super.key, required this.workoutsData});

  @override
  Widget build(BuildContext context) {
    if (workoutsData.isEmpty) {
      return SizedBox(
        height: 250,
        child: Card(
          child: Center(
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

    return SizedBox(
      height: 250,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LineChart(
            _createChartData(),
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  LineChartData _createChartData() {
    // Группируем данные по датам и суммируем weight * reps
    Map<DateTime, double> volumeByDate = {};

    for (var rep in workoutsData) {
      // Нормализуем дату до начала дня (без времени)
      DateTime date = DateTime(rep.day.year, rep.day.month, rep.day.day);
      double volume = rep.weight * rep.reps;

      volumeByDate.update(
        date,
        (value) => value + volume,
        ifAbsent: () => volume,
      );
    }

    // Сортируем даты и создаём точки
    List<DateTime> sortedDates = volumeByDate.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    List<FlSpot> spots = sortedDates
        .asMap()
        .entries
        .map(
          (entry) =>
              FlSpot(entry.key.toDouble(), volumeByDate[entry.value] ?? 0),
        )
        .toList();

    // Находим максимальное значение для масштабирования Y-оси
    double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: maxY / 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: Colors.grey.withAlpha(50), strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return FlLine(color: Colors.grey.withAlpha(50), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              if (value == 0) return const Text('');
              return Text(
                '${value.toInt()}',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < sortedDates.length) {
                DateTime date = sortedDates[index];
                return SideTitleWidget(
                  meta: meta,
                  child: Transform.rotate(
                    angle: -0.9,
                    child: Text(
                      '${date.day}.${date.month}',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      // borderData: FlBorderData(
      //   show: false,
      //   border: Border.all(color: Colors.grey.withAlpha(50)),
      // ),
      minX: 0,
      maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1,
      minY: 0,
      maxY: maxY * 1.2, // 20% запаса сверху
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true, // Плавные линии! ✨
          color: Colors.blue,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 1,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: Colors.blue,
              );
            },
          ),
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
              int index = spot.x.toInt();
              if (index >= 0 && index < sortedDates.length) {
                DateTime date = sortedDates[index];
                return LineTooltipItem(
                  '${date.day}.${date.month}.${date.year}\n',
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Объём: ${spot.y.toInt()}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                );
              }
              return LineTooltipItem(
                '${spot.y.toInt()}',
                TextStyle(color: Colors.white),
              );
            }).toList();
          },
          // tooltipBgColor: Colors.blueGrey,
          tooltipBorderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        handleBuiltInTouches: true,
      ),
    );
  }
}
