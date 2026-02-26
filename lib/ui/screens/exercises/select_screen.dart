import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/domain/reps_element.dart';
import 'package:flutter_training_stats_apps/domain/set_element.dart';
import 'package:flutter_training_stats_apps/ui/screens/exercises/exercise_card.dart';
import 'package:flutter_training_stats_apps/ui/screens/exercises/sets_card.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final animationDuration = Duration(milliseconds: 500);
  bool isFABColumnVisible = false;
  bool isSetCreating = false;
  List<SetElement> setsList = List.generate(
    3,
    (index) => SetElement(name: 'name', exercises: []),
  );
  List<ExerciseElement> exerciseList = List.generate(
    3,
    (index) => ExerciseElement(
      name: 'name',
      reps: RepsElement(weight: 22.2, reps: 2, day: DateTime.now()),
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: animationDuration, vsync: this);

    _animation = Tween<double>(
      begin: 0.7,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void makeFABvisible() {
    setState(() {
      isFABColumnVisible = !isFABColumnVisible;
    });
  }

  void _toggleSetCrealing() => setState(() {
    isSetCreating = !isSetCreating;
  });
  void _toggleFocus(bool isLeft) {
    if (isLeft) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Select exercise')),
      body: Row(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                _toggleFocus(true);
              }
              return false;
            },
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: .symmetric(
                    horizontal: BorderSide(width: 0.5),
                    vertical: BorderSide(width: 1),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  color: Colors.blueAccent.withAlpha(15),
                ),
                child: ListView.builder(
                  itemCount: setsList.length,
                  itemBuilder: (context, index) => SetsCardElement(
                    exercises: setsList[index].exercises,
                    name: setsList[index].name,
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification) {
                    _toggleFocus(false);
                  }
                  return false;
                },
                child: Container(
                  width: screenWidth * (1 - _animation.value),
                  decoration: BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(width: 1)),
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    color: Colors.redAccent.withAlpha(15),
                  ),
                  child: ListView.builder(
                    itemCount: setsList.length,
                    itemBuilder: (context, index) =>
                        ExerciseCardElement(exercise: exerciseList[index]),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .end,
        spacing: 4,
        children: [
          AnimatedSlide(
            curve: Curves.ease,
            offset: isFABColumnVisible ? Offset(0, 0) : Offset(0, 0.3),
            duration: animationDuration,
            child: AnimatedOpacity(
              curve: Curves.ease,
              opacity: isFABColumnVisible ? 1.0 : 0,
              duration: animationDuration,
              child: Column(
                spacing: 4,
                crossAxisAlignment: .end,
                children: [
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Add Exercises'),
                  ),
                  Row(
                    mainAxisAlignment: .end,
                    children: [
                      Text('data'),
                      FilledButton.icon(
                        onPressed: () {
                          _toggleSetCrealing();
                        },
                        label: Text('Save set!'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          FloatingActionButton.extended(
            onPressed: () => makeFABvisible(),
            icon: const Icon(Icons.edit),
            label: const Text('Making changes...'),
            isExtended: isFABColumnVisible,
          ),
        ],
      ),
      floatingActionButtonLocation: .endFloat,
    );
  }
}
