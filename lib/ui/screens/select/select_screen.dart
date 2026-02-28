import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/data/database.dart';
import 'package:flutter_training_stats_apps/domain/exercise_element.dart';
import 'package:flutter_training_stats_apps/domain/set_element.dart';
import 'package:flutter_training_stats_apps/ui/screens/select/sets_card.dart';
import 'package:flutter_training_stats_apps/ui/theme/colors.dart';

import 'exercise_card.dart';

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
  late final db = widget.db;
  static const animationDuration = Duration(milliseconds: 500);
  bool isFABColumnVisible = false;
  bool isSetCreating = false;
  bool isExerciseCreating = false;
  bool isEditingMode = false;
  bool isSetEditing = false;
  int editSetIndex = -1;
  String enteringSetName = '';
  String enteringExerciseName = '';

  SetElement? selectedSet;
  List<SetElement> setsList = [];
  List<ExerciseElement> activeExerciseList = [];
  List<ExerciseElement> loadedExerciseList = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: animationDuration, vsync: this);

    _animation = Tween<double>(
      begin: 0.7,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _loadSets();
    _loadExercises();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isInSelectedSet(int index) {
    if (editSetIndex == -1) {
      return false;
    } else {
      return setsList[editSetIndex].exercises.contains(
        loadedExerciseList[index],
      );
    }
  }

  void _loadSets() async {
    if (setsList.isEmpty) {
      final loadedList = await db.getAllSets();
      print('$loadedList in init state');
      setState(() {
        setsList = loadedList;
      });
    }
  }

  void _loadExercises() async {
    if (loadedExerciseList.isEmpty) {
      final loadedList = await db.getAllExercises();
      print(loadedList);
      setState(() {
        loadedExerciseList = loadedList;
        activeExerciseList = loadedList;
      });
    }
  }

  void _toggleSetCreating() => setState(() {
    isSetCreating = !isSetCreating;
  });

  void _toggleExerciseCreating() => setState(() {
    isExerciseCreating = !isExerciseCreating;
  });

  void _onSetSelect(SetElement set) {
    if (selectedSet != set) {
      setState(() {
        selectedSet = set;
        activeExerciseList = set.exercises;
      });
    } else {
      setState(() {
        selectedSet = null;
        activeExerciseList = loadedExerciseList;
      });
    }
  }

  void _onSetEdit(int index) {
    if (editSetIndex != index) {
      setState(() {
        selectedSet = setsList[index];
        editSetIndex = index;
        isSetEditing = true;
      });
    } else {
      setState(() {
        selectedSet = null;
        editSetIndex = -1;
        isSetEditing = false;
      });
    }
  }

  void _deleteSet(SetElement set) async {
    final setId = set.id;
    if (setId == null) return;

    await db.deleteSet(setId);

    setState(() {
      setsList.removeWhere((element) => element.id == setId);
      if (selectedSet?.id == setId) {
        selectedSet = null;
        activeExerciseList = loadedExerciseList;
      }
    });
  }

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
                  color: setsMainColor,
                ),
                child: ListView.builder(
                  itemCount: setsList.length,
                  itemBuilder: (context, index) => SetsCardElement(
                    isActive: selectedSet == setsList[index],
                    isEditingMode: isEditingMode,
                    exercises: setsList[index].exercises,
                    name: setsList[index].name,
                    onClick: () => _onSetSelect(setsList[index]),
                    onDelete: () => _deleteSet(setsList[index]),
                    onEdit: () => _onSetEdit(index),
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
                    color: exerciseMainColor,
                  ),
                  child: ListView.builder(
                    itemCount: activeExerciseList.length,
                    itemBuilder: (context, index) => ExerciseCardElement(
                      isInSelectedSet: _isInSelectedSet(index),
                      isSetEditing: isSetEditing,
                      isGlobalEditMode: isEditingMode,
                      exercise: activeExerciseList[index],
                      onCheckBoxClick: () {},
                      onDelete: () {
                        db.deleteExercise(activeExerciseList[index].id!);
                        setState(() {
                          activeExerciseList.removeAt(index);
                        });
                      },
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
                      editSetIndex = -1;
                      selectedSet = null;
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
                                    final newEx = ExerciseElement(
                                      name: enteringExerciseName,
                                      reps: [],
                                    );
                                    setState(() {
                                      activeExerciseList.add(newEx);
                                      db.insertExercise(newEx);
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
                                  onPressed: () async {
                                    final tempSet = SetElement(
                                      exercises: [],
                                      name: enteringSetName,
                                    );
                                    final newId = await widget.db.insertSet(
                                      tempSet,
                                    );
                                    setState(() {
                                      setsList.add(
                                        SetElement(
                                          id: newId,
                                          exercises: [],
                                          name: enteringSetName,
                                        ),
                                      );
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
              selectedSet = null;
              editSetIndex = -1;
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
