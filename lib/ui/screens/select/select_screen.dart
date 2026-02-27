import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/data/database.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/domain/set_element.dart';
import 'package:flutter_training_stats_apps/ui/screens/exercises/exercise_card.dart';
import 'package:flutter_training_stats_apps/ui/screens/exercises/sets_card.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key, required this.db});
  final AppDatabase db;
  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  static const animationDuration = Duration(milliseconds: 500);
  bool isFABColumnVisible = false;
  bool isSetCreating = false;
  bool isExerciseCreating = false;
  bool isEditingMode = false;
  String enteringSetName = '';
  String enteringExerciseName = '';

  List<SetElement> setsList = [];
  List<ExerciseElement> exerciseList = [];

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

  void _toggleSetCreating() => setState(() {
    isSetCreating = !isSetCreating;
  });

  void _toggleExerciseCreating() => setState(() {
    isExerciseCreating = !isExerciseCreating;
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
                    isEditingMode: isEditingMode,
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
                    itemCount: exerciseList.length,
                    itemBuilder: (context, index) => ExerciseCardElement(
                      exercise: exerciseList[index],
                      isEditingMode: isEditingMode,
                    ),
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
                  FloatingActionButton.extended(
                    heroTag: 4,
                    onPressed: () => setState(() {
                      isEditingMode = !isEditingMode;
                    }),
                    label: isEditingMode
                        ? Text('Done with editing')
                        : Text('Enter editing mode'),
                  ),
                  Row(
                    mainAxisAlignment: .end,
                    children: [
                      AnimatedSlide(
                        curve: Curves.ease,
                        offset: isExerciseCreating
                            ? Offset(0, 0)
                            : Offset(0.5, 0),
                        duration: animationDuration,
                        child: AnimatedOpacity(
                          curve: Curves.easeOut,
                          opacity: isExerciseCreating ? 1 : 0,
                          duration: animationDuration,
                          child: SizedBox(
                            width: 200,
                            child: TextField(
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    enteringExerciseName = value;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Enter exercise name here',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      exerciseList.add(
                                        ExerciseElement(
                                          name: enteringExerciseName,
                                        ),
                                      );
                                      enteringExerciseName = '';
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton.extended(
                        heroTag: 1,
                        onPressed: () {
                          _toggleExerciseCreating();
                        },
                        label: isExerciseCreating
                            ? Text('Okay')
                            : Text('Add exercise!'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: .end,
                    children: [
                      AnimatedSlide(
                        curve: Curves.ease,
                        offset: isSetCreating ? Offset(0, 0) : Offset(0.5, 0),
                        duration: animationDuration,
                        child: AnimatedOpacity(
                          curve: Curves.easeOut,
                          opacity: isSetCreating ? 1 : 0,
                          duration: animationDuration,
                          child: SizedBox(
                            width: 200,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  if (value.isNotEmpty) enteringSetName = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Enter set name here',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      final setElement = SetElement(
                                        exercises: [],
                                        name: enteringSetName,
                                      );
                                      setsList.add(setElement);
                                      widget.db.insertSet(setElement);
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton.extended(
                        heroTag: 2,
                        onPressed: () {
                          _toggleSetCreating();
                        },
                        label: isSetCreating ? Text('Okay') : Text('Add set!'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          FloatingActionButton.extended(
            heroTag: 3,
            onPressed: () => setState(() {
              isFABColumnVisible = !isFABColumnVisible;
              isEditingMode = false;
              isSetCreating = false;
            }),
            icon: const Icon(Icons.edit),
            label: const Text('Done!'),
            isExtended: isFABColumnVisible,
          ),
        ],
      ),
      floatingActionButtonLocation: .endFloat,
    );
  }
}
