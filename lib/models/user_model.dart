//lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String password;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'colaborador',
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'password': password,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      role: map.containsKey('role') ? map['role'] : 'colaborador',
      password: map['password'],
    );
  }
}