import 'package:flutter/material.dart';
import 'package:tarefas/data/task_inherited.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:tarefas/screens/login_screen.dart';
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
        initialRoute: '/login', // Modifique aqui para definir InitialScreen como inicial
        routes: {
          '/login': (context) => LoginScreen(), // Mantenha a rota para LoginScreen se ainda for usá-la
          '/initialScreen': (context) => const InitialScreen(), // Asegure que esta rota leve à InitialScreen
          '/userFormScreen': (context) => UserFormScreen(),
          '/formScreen': (context) => FormScreen(userId: widget.userId),
          '/editTaskScreen': (context) => EditTaskScreen(taskModel: ModalRoute.of(context)!.settings.arguments as TaskModel, userId: widget.userId),
          // Adicione mais rotas conforme necessário
        },
      ),
    );
  }
}
