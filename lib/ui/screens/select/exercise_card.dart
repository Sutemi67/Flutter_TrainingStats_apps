import 'package:flutter/material.dart';
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
  });

  final ExerciseElement exercise;
  final bool isGlobalEditMode;
  final bool isInSelectedSet;
  final bool isSetEditing;
  final VoidCallback onDelete;
  final VoidCallback onCheckBoxClick;
  static const animationDuration = Duration(milliseconds: 500);
  static const curve = Curves.ease;

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => DetailsScreen(exercise: exercise),
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
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .center,
            children: [
              AnimatedScale(
                scale: isGlobalEditMode ? 1 : 1.5,
                duration: animationDuration,
                child: AnimatedSlide(
                  curve: curve,
                  offset: isGlobalEditMode
                      ? const Offset(0, 0)
                      : const Offset(0, 0.7),
                  duration: animationDuration,
                  child: Text(exercise.name, overflow: TextOverflow.ellipsis),
                ),
              ),

              AnimatedOpacity(
                opacity: isGlobalEditMode ? 1 : 0,
                duration: animationDuration,
                child: AnimatedSlide(
                  offset: isGlobalEditMode
                      ? const Offset(0, 0)
                      : const Offset(0, -0.3),
                  duration: animationDuration,
                  curve: curve,
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      if (isSetEditing)
                        Checkbox(
                          value: false,
                          onChanged: isGlobalEditMode ? (value) {} : null,
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
        ),
      ),
    );
  }
}
