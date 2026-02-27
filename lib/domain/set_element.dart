import 'package:flutter_training_stats_apps/domain/exercise_element.dart';

final class SetElement {
  final String name;
  final List<ExerciseElement> exercises;

  SetElement({required this.exercises, required this.name});

  Map<String, dynamic> toMap() {
    return {'name': name};
  }
}

class SetElementDto {
  final int id;
  final String name;

  SetElementDto({required this.id, required this.name});

  factory SetElementDto.fromMap(Map<int, dynamic> map) {
    return SetElementDto(id: map['id'], name: map['name']);
  }

}
