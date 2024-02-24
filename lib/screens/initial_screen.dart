import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas/components/difficulty.dart';
import 'package:tarefas/data/task_dao.dart';
import 'package:tarefas/data/user_dao.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:tarefas/models/user_model.dart';
import 'package:tarefas/screens/edit_task_screen.dart';
import 'package:tarefas/screens/form_screen.dart';
import 'package:tarefas/screens/login_screen.dart';
import 'package:tarefas/screens/user_form_screen.dart';
import 'package:tarefas/screens/user_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InitialScreen(),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final List<String> selectedTaskIds = [];
  String _userId = "";
  String _userName = "Usuário";
  String _userRole = "colaborador"; // Valor padrão

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? "";
      _userName = prefs.getString('userName') ?? "Usuário";
      _userRole = prefs.getString('userRole') ?? "colaborador";
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  void _reloadTasks() async {
    // Supondo que você tenha uma função _loadTasksAndUsers que busca as tarefas
    try {
      final Map<String, dynamic> updatedData = await _loadTasksAndUsers();
      setState(() {
        // Atualiza os dados da sua aplicação com os novos dados obtidos
        // Isto irá forçar o widget a reconstruir com os novos dados
      });
    } catch (e) {
      // Trata erro na recarga das tarefas, se necessário
      print("Erro ao recarregar tarefas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, $_userName'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _reloadTasks,
          ),
          if (_userRole == "admin") IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FormScreen(userId: _userId))),
          ),
          if (_userRole == "admin") IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserFormScreen())),
          ),
          if (_userRole == "admin") IconButton(
            icon: Icon(Icons.people),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserListScreen())),
          ),
          if (_userId.isNotEmpty && selectedTaskIds.isNotEmpty) IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteSelectedTasks,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: _loadTasksAndUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            final List<TaskModel> tasks = snapshot.data['tasks'];
            final List<UserModel> users = snapshot.data['users'];
            final userMap = {for (var user in users) user.id: user.name};

            // Filtra as tarefas baseadas no papel do usuário
            final filteredTasks = _userRole == "admin" ? tasks : tasks.where((task) => task.userId == _userId).toList();

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
                childAspectRatio: 3 / 2,
              ),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                bool isSelected = selectedTaskIds.contains(task.id);
                String userName = userMap[task.userId] ?? 'Não Atribuído';

                return Card(
                  shape: Border.all(color: isSelected ? Colors.green : Colors.grey, width: 2),
                  child: InkWell(
                    onTap: () => setState(() {
                      isSelected ? selectedTaskIds.remove(task.id) : selectedTaskIds.add(task.id);
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank),
                            title: Text(task.name, style: Theme.of(context).textTheme.subtitle1),
                            subtitle: Text('Atribuído a: $userName'),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditTaskScreen(taskModel: task, userId: _userId)),
                                ).then((_) => setState(() {}));
                              },
                            ),
                          ),
                          Difficulty(task.difficulty),
                          Expanded(
                            child: TaskCountdown(task: task),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _loadTasksAndUsers() async {
    List<TaskModel> tasks = await TaskDao().findAll();
    final users = await UserDao().findAll();

    // Se o usuário não for um admin, filtre as tarefas para mostrar apenas as suas
    if (_userRole != "admin") {
      tasks = tasks.where((task) => task.userId == _userId).toList();
    }

    return {'tasks': tasks, 'users': users};
  }

  void _deleteSelectedTasks() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('Deseja deletar as tarefas selecionadas?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
                for (String taskId in selectedTaskIds) {
                  await TaskDao().delete(taskId);
                }
                selectedTaskIds.clear();
                setState(() {});
              },
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }

  Color _getBorderColor(TaskModel task) {
    final now = DateTime.now();
    final timeLeft = task.endDate.difference(now);
    if (timeLeft.inSeconds < 0) {
      return Colors.blue; // Task finished
    }
    final percentLeft = timeLeft.inSeconds / (30 * 24 * 60 * 60);
    if (percentLeft < 0.2) {
      return Colors.red; // Below 20% time left
    } else if (percentLeft < 0.6) {
      return Colors.yellow; // Between 20% and 60% time left
    } else {
      return Colors.green; // Above 60% time left
    }
  }
}



class TaskCountdown extends StatefulWidget {
  final TaskModel task;
  const TaskCountdown({Key? key, required this.task}) : super(key: key);

  @override
  _TaskCountdownState createState() => _TaskCountdownState();
}

class _TaskCountdownState extends State<TaskCountdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeLeft = widget.task.endDate.difference(now);
    Color iconColor;
    if (timeLeft.isNegative) {
      iconColor = Colors.blue; // Task finished
    } else {
      final percentLeft = timeLeft.inSeconds / (30 * 24 * 60 * 60);
      if (percentLeft < 0.2) {
        iconColor = Colors.red; // Below 20% time left
      } else if (percentLeft < 0.6) {
        iconColor = Colors.yellow; // Between 20% and 60% time left
      } else {
        iconColor = Colors.green; // Above 60% time left
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Datas da Tarefa'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Início: ${DateFormat('dd/MM/yyyy').format(widget.task.startDate)}'),
                    Text('Fim: ${DateFormat('dd/MM/yyyy').format(widget.task.endDate)}'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Fechar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          child: const Icon(Icons.calendar_today, color: Colors.blue),
        ),
        Icon(Icons.timer, color: iconColor),
        Text(
          timeLeft.isNegative ? 'Tarefa finalizada' : _formatDuration(timeLeft),
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = duration.inDays;
    final hours = twoDigits(duration.inHours % 24);
    final minutes = twoDigits(duration.inMinutes % 60);
    final seconds = twoDigits(duration.inSeconds % 60);
    return "${days}d ${hours}h ${minutes}m ${seconds}s";
  }
}
