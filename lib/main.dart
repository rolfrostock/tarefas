//lib/main.dart:

import 'package:flutter/material.dart';
import 'package:tarefas/data/task_inherited.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:tarefas/screens/login_screen.dart'; // Certifique-se de importar a LoginScreen
import 'package:tarefas/screens/initial_screen.dart';
import 'package:tarefas/screens/form_screen.dart';
import 'package:tarefas/screens/user_form_screen.dart';
import 'package:tarefas/screens/edit_task_screen.dart';
import 'package:uuid/uuid.dart';

void main() {
  const String staticUserId = 'user-123';
  var taskList = [
    TaskModel(
      id: const Uuid().v4(),
      name: 'Gerenciador de tarefas',
      photo: 'assets/images/flutter.png',
      difficulty: 2,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      userId: staticUserId,
    ),
    // Adicione mais TaskModel conforme necessário
  ];

  runApp(MyApp(taskList: taskList, userId: staticUserId));
}

class MyApp extends StatefulWidget {
  final List<TaskModel> taskList;
  final String userId;
  const MyApp({super.key, required this.taskList, required this.userId});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return TaskInherited(
      taskList: widget.taskList,
      child: MaterialApp(
        title: 'Tarefas App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login', // Modifique aqui para definir a rota de login como inicial
        routes: {
          '/login': (context) => LoginScreen(), // Defina a rota para a LoginScreen
          '/initialScreen': (context) => const InitialScreen(), // Ajuste para a rota da InitialScreen
          '/userFormScreen': (context) => UserFormScreen(),
          // Adicione mais rotas conforme necessário
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/formScreen':
              return MaterialPageRoute(
                builder: (context) => FormScreen(userId: widget.userId),
              );
            case '/editTaskScreen':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => EditTaskScreen(taskModel: args['taskModel'], userId: args['userId']),
              );
            default:
              return null; // Adicione uma rota de fallback ou retorne null
          }
        },
      ),
    );
  }
}