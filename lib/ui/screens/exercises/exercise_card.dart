import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/ui/screens/details/details_screen.dart';

class ExerciseCardElement extends StatelessWidget {
  const ExerciseCardElement({
    super.key,
    required this.exercise,
    required this.isEditingMode,
  });

  final ExerciseElement exercise;
  final bool isEditingMode;
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
    return InkWell(
      onTap: () {
        _navigateToDetails(context);
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .center,
            children: [
              AnimatedScale(
                scale: isEditingMode ? 1 : 1.5,
                duration: animationDuration,
                child: AnimatedSlide(
                  curve: curve,
                  offset: isEditingMode ? Offset(0, 0) : Offset(0, 0.7),
                  duration: animationDuration,
                  child: Text(exercise.name, overflow: TextOverflow.ellipsis),
                ),
              ),
              AnimatedOpacity(
                opacity: isEditingMode ? 1 : 0,
                duration: animationDuration,
                child: AnimatedSlide(
                  offset: isEditingMode ? Offset(0, 0) : Offset(0, -0.3),
                  duration: animationDuration,
                  curve: curve,
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                      IconButton(icon: Icon(Icons.delete), onPressed: () {}),
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
