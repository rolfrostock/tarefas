//lib/screens/user_list_screen.dart:
//lib/screens/user_list_screen.dart
import 'package:flutter/material.dart';
import 'package:tarefas/data/user_dao.dart';
import 'package:tarefas/models/user_model.dart';
import 'package:tarefas/screens/edit_user_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    final userDao = UserDao();
    final userList = await userDao.findAll();
    setState(() {
      users = userList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuários'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text("${user.email} - Role: ${user.role}"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditUserScreen(user: user)));
              },
            ),
          );
        },
      ),
    );
  }
}