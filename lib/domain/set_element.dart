import 'package:flutter_training_stats_apps/domain/exercise_element.dart';

final class SetElement {
  final int? id;
  final String name;
  final List<ExerciseElement> exercises;

  SetElement({
    this.id,
    required this.exercises,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    // id не сохраняем, так как он AUTOINCREMENT в БД
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
