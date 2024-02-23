import 'package:flutter/material.dart';
import 'package:tarefas/data/user_dao.dart';
import 'package:tarefas/models/user_model.dart';

class EditUserScreen extends StatefulWidget {
  final UserModel user;

  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // Controlador para o campo de senha
  String? _selectedRole;
  final UserDao _userDao = UserDao();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _selectedRole = widget.user.role; // Assegure-se de que este valor inicial está na lista de itens do dropdown
    // O campo da senha é intencionalmente deixado vazio por questões de segurança
  }

  void _saveUser() async {
    if (_selectedRole != null) { // Verifique se o role selecionado não é nulo
      UserModel updatedUser = UserModel(
        id: widget.user.id,
        name: _nameController.text,
        email: _emailController.text,
        role: _selectedRole!,
        password: _passwordController.text.isEmpty ? widget.user.password : _passwordController.text, // Atualiza a senha se um novo valor foi fornecido
      );

      await _userDao.update(updatedUser);
      Navigator.pop(context); // Volta para a tela anterior após a atualização
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuário'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              onChanged: (newValue) {
                setState(() {
                  _selectedRole = newValue;
                });
              },
              items: ['admin', 'colaborador']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Role'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Nova Senha'),
              obscureText: true, // Oculta a entrada de texto
            ),
            ElevatedButton(
              onPressed: _saveUser,
              child: Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
