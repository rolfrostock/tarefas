//lib/screens/form_screen.dart:
import 'package:flutter/material.dart';
import 'package:tarefas/data/task_dao.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class FormScreen extends StatefulWidget {
  final String userId;

  const FormScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Tarefa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome da Tarefa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da tarefa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _photoController,
                decoration: const InputDecoration(labelText: 'URL da Foto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a URL da foto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _difficultyController,
                decoration: const InputDecoration(labelText: 'Dificuldade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Por favor, insira um número para a dificuldade';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    TaskModel newTask = TaskModel(
                      id: const Uuid().v4(),
                      name: _nameController.text,
                      photo: _photoController.text,
                      difficulty: int.parse(_difficultyController.text),
                      startDate: _startDate,
                      endDate: _endDate,
                      userId: widget.userId,
                    );
                    await TaskDao().save(newTask);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Salvar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
