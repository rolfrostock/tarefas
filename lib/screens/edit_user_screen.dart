//lib/screens/edit_user_screen.dart

import 'package:flutter/material.dart';
import 'package:tarefas/data/user_dao.dart';
import 'package:tarefas/models/user_model.dart';

class EditUserScreen extends StatefulWidget {
  final UserModel user;

  const EditUserScreen({super.key, required this.user}); // Adicionado parâmetro key

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;
  final UserDao _userDao = UserDao();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _selectedRole = widget.user.role;
  }

  void _saveUser() async {
    if (_selectedRole != null) {
      UserModel updatedUser = UserModel(
        id: widget.user.id,
        name: _nameController.text,
        email: _emailController.text,
        role: _selectedRole!,
        password: _passwordController.text.isEmpty ? widget.user.password : _passwordController.text,
      );

      await _userDao.update(updatedUser);
      if (mounted) { // Verifica se o widget ainda está no contexto da árvore
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
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
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Nova Senha'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _saveUser,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
