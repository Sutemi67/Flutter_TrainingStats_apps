import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/data/database.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/ui/screens/details/details_chart.dart';
import 'package:flutter_training_stats_apps/ui/screens/details/slider_row.dart';
import 'package:flutter_training_stats_apps/ui/theme/colors.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.exercise, required this.db});
  final ExerciseElement exercise;
  final AppDatabase db;
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<RepsElement> repsArchive = [
    // RepsElement(weight: 23, reps: 7, day: DateTime(2025, 10, 13)),
    // RepsElement(weight: 23, reps: 7, day: DateTime(2025, 10, 13)),
    // RepsElement(weight: 23, reps: 7, day: DateTime(2025, 10, 14)),
    // RepsElement(weight: 23, reps: 7, day: DateTime(2025, 10, 14)),
    // RepsElement(weight: 67, reps: 7, day: DateTime(2025, 10, 15)),
  ];
  bool isRegulatorsVisible = false;
  double newRepsValue = 0;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    repsArchive = widget.exercise.reps;
    _scrollToTop();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Future<void> addRep(double weight, int reps) async {
    if (weight != 0.0 && reps != 0) {
      final rep = RepsElement(weight: weight, reps: reps, day: DateTime.now());
      try {
        await widget.db.insertReps(widget.exercise.id!, rep);
        setState(() {
          repsArchive.add(rep);
        });
        _scrollToTop();
      } catch (e) {
        // Обработка ошибок БД
        debugPrint('❌ Error saving reps: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Не удалось сохранить: $e')));
        }
      }
    }
  }

  // Прокрутка списка к "визуальному верху" (с учётом reverse: true)
  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.exercise.name} details')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: .start,
          children: [
            //График
            RepsGraph(workoutsData: repsArchive),
            // Карточка с кнопкой добавления
            Card(child: RepsInfo(addRep: addRep)),
            // Список записей
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: repsArchive.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fitness_center,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No reps of this exercise yet.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Нажмите + чтобы добавить',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: repsArchive.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        reverse: true,
                        itemBuilder: (context, index) {
                          var rep = repsArchive[index];
                          final isToday = _isToday(rep.day);
                          return Card(
                            margin: EdgeInsets.only(bottom: 8),
                            color: isToday ? null : exerciseMainColor,
                            child: ListTile(
                              leading: CircleAvatar(child: Text('${rep.reps}')),
                              title: Text(
                                '${rep.reps} reps × ${rep.weight} kg',
                              ),
                              subtitle: Text(
                                'Объём: ${(rep.weight * rep.reps).toInt()}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              trailing: Text(
                                DateFormat('d MMMM', 'ru').format(rep.day),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
