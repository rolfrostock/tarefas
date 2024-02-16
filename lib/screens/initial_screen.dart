import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarefas/components/difficulty.dart';
import 'package:tarefas/data/task_dao.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:tarefas/screens/edit_task_screen.dart';
import 'package:tarefas/screens/form_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        actions: [
          if (selectedTaskIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedTasks,
            ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FormScreen()),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<TaskModel>>(
        future: TaskDao().findAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final tasks = snapshot.data!;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  Color borderColor = _getBorderColor(task);
                  bool isSelected = selectedTaskIds.contains(task.id);
                  return Card(
                    shape: Border.all(color: borderColor, width: 1),
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
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditTaskScreen(taskModel: task)),
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
              return const Center(child: Text('Nenhuma tarefa encontrada.'));
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
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
    final percentLeft = timeLeft.inSeconds / Duration(days: 30).inSeconds;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeLeft = widget.task.endDate.difference(now);
    Color iconColor;
    if (timeLeft.isNegative) {
      iconColor = Colors.blue; // Tarefa finalizada
    } else {
      final percentLeft = timeLeft.inSeconds / Duration(days: 30).inSeconds;
      if (percentLeft < 0.2) {
        iconColor = Colors.red; // Abaixo de 20% de tempo restante
      } else if (percentLeft < 0.6) {
        iconColor = Colors.yellow; // Entre 20% e 60% de tempo restante
      } else {
        iconColor = Colors.green; // Acima de 60% de tempo restante
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
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
              );
            },
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = duration.inDays;
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${days}d ${hours}h ${minutes}m ${seconds}s";
  }
}
