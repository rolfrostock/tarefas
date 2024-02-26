//lib/data/task_inherited.dart:
import 'package:flutter/material.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TaskInherited extends InheritedWidget {
  final List<TaskModel> taskList;

  const TaskInherited({
    super.key,
    required super.child,
    required this.taskList,
  });

  void newTask(String name, String photo, int difficulty, String userId) {
    taskList.add(TaskModel(
      id: const Uuid().v4(),
      name: name,
      photo: photo,
      difficulty: difficulty,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      userId: userId,
    ));
  }

  static TaskInherited of(BuildContext context) {
    final TaskInherited? result = context.dependOnInheritedWidgetOfExactType<TaskInherited>();
    assert(result != null, 'No TaskInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TaskInherited oldWidget) {
    return oldWidget.taskList.length != taskList.length;
  }
}
