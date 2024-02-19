//lib/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  // Método para converter o UserModel em um Map. Útil para inserção no banco de dados.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // Método para criar um UserModel a partir de um Map. Útil para leitura do banco de dados.
  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}
