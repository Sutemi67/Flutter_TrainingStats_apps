import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:flutter_training_stats_apps/ui/theme/colors.dart';
import 'package:intl/intl.dart';

class RepsGraph extends StatelessWidget {
  final List<RepsElement> workoutsData;

  const RepsGraph({super.key, required this.workoutsData});

  @override
  Widget build(BuildContext context) {
    if (workoutsData.isEmpty) {
      return const SizedBox(
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
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  LineChartData _createChartData() {
    // 1. Группируем данные по датам (нормализуем до начала дня)
    Map<DateTime, double> volumeByDate = {};
    for (var rep in workoutsData) {
      final date = DateTime(rep.day.year, rep.day.month, rep.day.day);
      final volume = rep.weight * rep.reps;
      volumeByDate.update(
        date,
        (value) => value + volume,
        ifAbsent: () => volume,
      );
    }

    // 2. Сортируем даты
    final sortedDates = volumeByDate.keys.toList()..sort();

    // 3. Создаём точки, используя timestamp (в днях) для оси X
    // Это обеспечит пропорциональное расстояние между датами
    final spots = sortedDates.map((date) {
      // Конвертируем дату в double: дни с 1970 года
      final x = date.millisecondsSinceEpoch / (24 * 60 * 60 * 1000);
      final y = volumeByDate[date]!;
      return FlSpot(x, y);
    }).toList();

    if (spots.isEmpty) {
      return LineChartData();
    }

    // 4. Вычисляем максимум для оси Y
    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    // 5. Находим minX и maxX на основе временных меток
    final minX = spots.first.x;
    final maxX = spots.last.x;

    return LineChartData(
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
            // interval в "днях" - показываем подпись примерно каждые N дней
            // Можно настроить под ваши данные: 1, 3, 7 и т.д.
            interval: 3,
            getTitlesWidget: (value, meta) {
              // Конвертируем X (дни) обратно в DateTime
              final timestampMs = (value * 24 * 60 * 60 * 1000).toInt();
              final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);

              // Показываем подпись только если эта дата есть в наших данных
              // (или очень близка к одной из них)
              final hasDataPoint = sortedDates.any(
                (d) => d.difference(date).abs().inDays <= 1,
              );

              if (!hasDataPoint) {
                return const SizedBox.shrink();
              }

              // Форматируем дату
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
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
          dotData: FlDotData(show: false),
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
              // Конвертируем X обратно в дату для тултипа
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
                    text: 'Объём: ${spot.y.toInt()}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              );
            }).toList();
          },
          tooltipBorderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        handleBuiltInTouches: true,
        // Улучшаем точность определения точки при тапе
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.blue, strokeWidth: 2),
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
    );
  }
}
