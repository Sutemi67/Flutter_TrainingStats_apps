import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainCard extends StatelessWidget {
  final DateTime trainDate;
  final double weight;

  const TrainCard({super.key, required this.trainDate, required this.weight});

  String _formatDateRelative(DateTime date) {
    // 1. Получаем название дня недели (например, "Вторник")
    final weekdayName = DateFormat.EEEE('ru').format(date);

    // 2. Считаем разницу в днях
    final now = DateTime.now();
    final dateOnly = DateTime(date.year, date.month, date.day);
    final nowOnly = DateTime(now.year, now.month, now.day);
    final daysDifference = nowOnly.difference(dateOnly).inDays;

    // 3. Используем Intl.plural для правильных окончаний
    String timeAgo;
    if (daysDifference == 0) {
      timeAgo = 'сегодня';
    } else if (daysDifference == 1) {
      timeAgo = 'вчера';
    } else if (daysDifference > 0) {
      // {count, plural, one {день} few {дня} other {дней}}
      timeAgo = Intl.plural(
        daysDifference,
        locale: 'ru_RU',
        one: '$daysDifference день назад',
        few: '$daysDifference дня назад',
        many: '$daysDifference дней назад',
        other: '$daysDifference дней назад',
      );
    } else {
      timeAgo = 'в будущем';
    }

    return '$weekdayName, $timeAgo';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [Text(_formatDateRelative(trainDate)), Text('$weight')],
        ),
      ),
    );
  }
}
