import 'package:flutter/material.dart';
import 'package:tarefas/data/task_dao.dart';
import 'package:tarefas/data/user_dao.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:tarefas/models/user_model.dart';
import 'package:tarefas/screens/edit_user_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<UserModel> users = [];
  final TaskDao _taskDao = TaskDao();

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

  Future<void> _deleteUser(String userId) async {
    final List<TaskModel> userTasks = await _taskDao.findTasksByUserId(userId);
    if (userTasks.isNotEmpty) {
      _showErrorDialog();
    } else {
      final shouldDelete = await _showDeleteDialog(context);
      if (shouldDelete) {
        await UserDao().delete(userId);
        _loadUsers();
      }
    }
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('Você realmente deseja deletar este usuário?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Deletar'),
          ),
        ],
      ),
    )) ?? false;
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: const Text('Este usuário possui tarefas atribuídas a ele. Atribua as tarefas a outro usuário ou delete-as antes de prosseguir.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text("${user.email} - Role: ${user.role}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditUserScreen(user: user)))
                        .then((_) => _loadUsers());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteUser(user.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
