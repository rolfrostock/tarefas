import 'package:flutter/material.dart';
import 'package:tarefas/components/difficulty.dart';
import 'package:tarefas/data/task_dao.dart';
import 'package:tarefas/components/tasks.dart';
import 'package:tarefas/screens/form_screen.dart';
import 'package:tarefas/screens/edit_task_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  List<String> selectedTaskNames = [];

  void _deleteSelectedTasks() async {
    // Mostra o diálogo de confirmação
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
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );

    // Se o usuário confirmar, deleta as tarefas selecionadas
    if (shouldDelete == true) {
      for (String taskName in selectedTaskNames) {
        await TaskDao().delete(taskName);
      }
      setState(() {
        selectedTaskNames.clear(); // Limpa a seleção após deletar
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        actions: [
          if (selectedTaskNames.isNotEmpty) // Mostra o botão de deletar se houver itens selecionados
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedTasks,
            ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FormScreen()),
              ).then((_) => setState(() {})); // Atualiza a lista após adicionar uma nova tarefa
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: TaskDao().findAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final tasks = snapshot.data!;
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(task.name),
                    subtitle: Difficulty(task.difficulty),
                    leading: Checkbox(
                      value: selectedTaskNames.contains(task.name),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedTaskNames.add(task.name);
                          } else {
                            selectedTaskNames.remove(task.name);
                          }
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
                      ).then((_) => setState(() {})); // Atualiza a lista após editar uma tarefa
                    },
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
}
