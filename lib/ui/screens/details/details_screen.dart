import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/data/database.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/ui/screens/details/details_chart.dart';
import 'package:flutter_training_stats_apps/ui/screens/details/slider_row.dart';
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
    RepsElement(weight: 200, reps: 10, day: DateTime(2025, 10, 12)),
    RepsElement(weight: 220, reps: 10, day: DateTime(2025, 10, 11)),
    RepsElement(weight: 230, reps: 10, day: DateTime(2025, 10, 11)),
    RepsElement(weight: 240, reps: 10, day: DateTime(2025, 10, 11)),
    RepsElement(weight: 250, reps: 10, day: DateTime(2025, 10, 13)),
    RepsElement(weight: 210, reps: 10, day: DateTime(2025, 10, 13)),
    RepsElement(weight: 210, reps: 10, day: DateTime(2025, 10, 29)),
    RepsElement(weight: 210, reps: 10, day: DateTime(2025, 10, 29)),
    RepsElement(weight: 210, reps: 10, day: DateTime(2025, 10, 29)),
  ];
  bool isRegulatorsVisible = false;
  double newRepsValue = 0;
  final _scrollController = ScrollController();

  @override
  void initState() {
    // repsArchive = List<RepsElement>.from(widget.exercise.reps);
    // repsArchive = widget.exercise.reps;
    super.initState();
    _scrollToTop();
  }

  void addRep(double weight, int reps) {
    if (weight != 0.0 && reps != 0) {
      final rep = RepsElement(weight: weight, reps: reps, day: DateTime.now());
      setState(() {
        repsArchive = [rep, ...repsArchive];
      });
      _scrollToTop();
      widget.db.insertReps(widget.exercise.id!, rep);
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
                          return Card(
                            margin: EdgeInsets.only(bottom: 8),
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
                                // '${rep.day.day}.${rep.day.month}',
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
