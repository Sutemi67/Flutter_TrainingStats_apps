final class RepsElement {
  final double weight;
  final int reps;
  final DateTime day;

  const RepsElement({
    required this.weight,
    required this.reps,
    required this.day,
  });
  Map<String, dynamic> toMap(int exerciseId) => {
    'weight': weight,
    'reps': reps,
    'day': day.toIso8601String(),
    'exercise_id': exerciseId,
  };
}
