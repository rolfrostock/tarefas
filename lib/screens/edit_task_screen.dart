import 'package:flutter/material.dart';
import 'package:tarefas/components/tasks.dart';
import 'package:tarefas/data/task_dao.dart';

class EditTaskScreen extends StatelessWidget {
  final Task task;

  EditTaskScreen({Key? key, required this.task}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = task.name;
    _photoController.text = task.photo;
    _difficultyController.text = task.difficulty.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _photoController,
              decoration: const InputDecoration(labelText: 'Foto'),
            ),
            TextField(
              controller: _difficultyController,
              decoration: const InputDecoration(labelText: 'Dificuldade'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                final updatedTask = Task(_nameController.text, _photoController.text, int.parse(_difficultyController.text));
                TaskDao().save(updatedTask);
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
