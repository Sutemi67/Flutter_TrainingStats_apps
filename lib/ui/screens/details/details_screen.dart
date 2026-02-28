import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/ui/screens/details/slider_row.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.exercise});
  final ExerciseElement exercise;
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<RepsElement> repsArchive = [];
  bool isRegulatorsVisible = false;
  double newRepsValue = 0;

  void addRep(double weight, int reps) {
    if (weight != 0.0 && reps != 0) {
      setState(() {
        repsArchive.add(
          RepsElement(weight: weight, reps: reps, day: DateTime.now()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.exercise.name} details')),
      body: Column(
        mainAxisAlignment: .start,
        children: [
          const Icon(Icons.upload_file_outlined, size: 200),
          Card(
            child: InkWell(
              onTap: () => setState(() {
                isRegulatorsVisible = !isRegulatorsVisible;
              }),
              child: AnimatedCrossFade(
                firstChild: RepsInfo(addRep: addRep),
                secondChild: const Row(
                  mainAxisAlignment: .center,
                  children: [Icon(Icons.add, size: 55), Text('Add rep')],
                ),
                crossFadeState: isRegulatorsVisible ? .showFirst : .showSecond,
                duration: Duration(milliseconds: 400),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: repsArchive.isEmpty
                  ? Text('No reps of this exercise yet.')
                  : ListView.builder(
                      itemCount: repsArchive.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          title: Text(
                            '${repsArchive[index].reps} reps with ${repsArchive[index].weight} weight',
                            textAlign: .center,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
