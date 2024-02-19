class TaskModel {
  final String id;
  final String name;
  final String photo;
  final int difficulty;
  final DateTime startDate;
  final DateTime endDate;
  final String userId; // Adicionado novo campo para referenciar o usuário

  TaskModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.difficulty,
    required this.startDate,
    required this.endDate,
    required this.userId, // Incluir userId no construtor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'difficulty': difficulty,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'userId': userId, // Adicionar userId ao Map
    };
  }

  static TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      name: map['name'],
      photo: map['photo'],
      difficulty: map['difficulty'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      userId: map['userId'], // Ler userId do Map
    );
  }

  TaskModel copy({
    String? id,
    String? name,
    String? photo,
    int? difficulty,
    DateTime? startDate,
    DateTime? endDate,
    String? userId, // Permitir alteração do userId através do método copy
  }) {
    return TaskModel(
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      difficulty: difficulty ?? this.difficulty,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      userId: userId ?? this.userId, // Incluir userId
    );
  }
}
