// task_model.dart

class TaskModel {
  final String id; // GUID
  final String name;
  final String photo;
  final int difficulty;
  final DateTime startDate;
  final DateTime endDate;
  int level;

  TaskModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.difficulty,
    required this.startDate,
    required this.endDate,
    this.level = 0,
  });

  // Calcula o total de dias até a finalização
  int get daysUntilEnd => endDate.difference(DateTime.now()).inDays;
}
