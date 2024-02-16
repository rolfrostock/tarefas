import 'package:flutter/material.dart';
import 'package:tarefas/data/task_inherited.dart';
import 'package:tarefas/models/task_model.dart'; // Certifique-se de importar TaskModel
import 'package:tarefas/screens/initial_screen.dart';
import 'package:uuid/uuid.dart'; // Importe o pacote uuid para gerar IDs


void main() {
  // Crie uma lista inicial de TaskModel
  var taskList = [
    TaskModel(
      id: const Uuid().v4(),
      name: 'Aprender Flutter',
      photo: 'assets/images/flutter.png',
      difficulty: 2,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
    ),
    // Adicione mais TaskModel conforme necessário
  ];

  runApp(MyApp(taskList: taskList));
}

class MyApp extends StatefulWidget {
  final List<TaskModel> taskList;

  const MyApp({super.key, required this.taskList});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return TaskInherited(
      taskList: widget.taskList, // Passe a lista de TaskModel para TaskInherited
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const InitialScreen(),
      ),
    );
  }
}
