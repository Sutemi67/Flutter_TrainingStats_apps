import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/data/database.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/ui/screens/details/details_screen.dart';
import 'package:flutter_training_stats_apps/ui/theme/colors.dart';

class ExerciseCardElement extends StatelessWidget {
  const ExerciseCardElement({
    super.key,
    required this.exercise,
    required this.isGlobalEditMode,
    required this.isInSelectedSet,
    required this.isSetEditing,
    required this.onDelete,
    required this.onCheckBoxClick,
    required this.db,
  });

  final ExerciseElement exercise;
  final bool isGlobalEditMode;
  final bool isInSelectedSet;
  final bool isSetEditing;
  final VoidCallback onDelete;
  final Function(bool) onCheckBoxClick;
  final AppDatabase db;
  static const animationDuration = Duration(milliseconds: 500);
  static const curve = Curves.ease;

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => DetailsScreen(exercise: exercise, db: db),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: .hardEdge,
      child: InkWell(
        onTap: () {
          _navigateToDetails(context);
        },
        splashColor: exerciseSelectedColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedCrossFade(
            sizeCurve: Curves.decelerate,
            firstChild: Column(
              mainAxisSize: .min,
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .center,
              children: [
                Text(exercise.name, overflow: TextOverflow.ellipsis),
                AnimatedOpacity(
                  opacity: isGlobalEditMode ? 1 : 0,
                  duration: animationDuration,
                  child: AnimatedSlide(
                    offset: isGlobalEditMode
                        ? Offset.zero
                        : const Offset(0, -0.3),
                    duration: animationDuration,
                    curve: curve,
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        if (isSetEditing)
                          Checkbox(
                            value: isInSelectedSet,
                            onChanged: isGlobalEditMode
                                ? (value) => onCheckBoxClick(value!)
                                : null,
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: isGlobalEditMode ? onDelete : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            secondChild: SizedBox(
              width: .infinity,
              child: Text(
                exercise.name,
                textAlign: .center,
                overflow: TextOverflow.ellipsis,
                // style: TextStyle(fontSize: 6),
              ),
            ),
            crossFadeState: isGlobalEditMode ? .showFirst : .showSecond,
            duration: const Duration(seconds: 1),
          ),
        ),
      ),
    );
  }
}
