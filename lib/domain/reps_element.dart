final class RepsElement {
  final int? id;
  final double weight;
  final int reps;
  final DateTime day;

  const RepsElement({
    required this.weight,
    required this.reps,
    required this.day,
    this.id,
  });
  Map<String, dynamic> toMap(int exerciseId) {
    return {
      'weight': weight,
      'reps': reps,
      'day': day.toIso8601String(),
      'exercise_id': exerciseId,
    };
  }
}
