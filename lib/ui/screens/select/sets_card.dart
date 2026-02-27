import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';

class SetsCardElement extends StatefulWidget {
  const SetsCardElement({
    super.key,
    required this.exercises,
    required this.name,
    required this.isEditingMode,
    required this.onClick,
  });

  final String name;
  final List<ExerciseElement> exercises;
  final bool isEditingMode;
  final Function onClick;
  static const animationDuration = Duration(milliseconds: 500);
  static const curve = Curves.ease;

  @override
  State<SetsCardElement> createState() => _SetsCardElementState();
}

class _SetsCardElementState extends State<SetsCardElement> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: isActive ? const Color.fromARGB(255, 125, 131, 1) : null,
      clipBehavior: .hardEdge,
      child: InkWell(
        onTap: () {
          widget.onClick();
          setState(() {
            isActive = !isActive;
          });
        },
        splashColor: const Color.fromARGB(255, 125, 131, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .center,
            children: [
              AnimatedScale(
                scale: widget.isEditingMode ? 1 : 1.5,
                duration: SetsCardElement.animationDuration,
                child: AnimatedSlide(
                  curve: SetsCardElement.curve,
                  offset: widget.isEditingMode ? Offset(0, 0) : Offset(0, 0.7),
                  duration: SetsCardElement.animationDuration,
                  child: Text(widget.name, overflow: TextOverflow.ellipsis),
                ),
              ),
              AnimatedOpacity(
                opacity: widget.isEditingMode ? 1 : 0,
                duration: SetsCardElement.animationDuration,
                child: AnimatedSlide(
                  offset: widget.isEditingMode ? Offset(0, 0) : Offset(0, -0.3),
                  duration: SetsCardElement.animationDuration,
                  curve: SetsCardElement.curve,
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
