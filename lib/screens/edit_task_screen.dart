//lib/screens/edit_task_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarefas/data/task_dao.dart';
import 'package:tarefas/data/user_dao.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:tarefas/models/user_model.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel taskModel;
  final String userId;

  const EditTaskScreen({super.key, required this.taskModel, required this.userId});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _photoController;
  late TextEditingController _difficultyController;
  late DateTime _startDate;
  late DateTime _endDate;
  String? _selectedUserId;
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.taskModel.name);
    _photoController = TextEditingController(text: widget.taskModel.photo);
    _difficultyController = TextEditingController(text: widget.taskModel.difficulty.toString());
    _startDate = widget.taskModel.startDate;
    _endDate = widget.taskModel.endDate;
    _selectedUserId = widget.taskModel.userId;
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    _users = await UserDao().findAll();
    if (mounted) setState(() {});
  }

  Future<void> _selectDateTime(BuildContext context, {required bool isStartDate}) async {
    final DateTime initialDate = isStartDate ? _startDate : _endDate;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStartDate) {
            _startDate = pickedDateTime;
          } else {
            _endDate = pickedDateTime;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarefa'),
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
              DropdownButtonFormField<String>(
                value: _selectedUserId,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUserId = newValue!;
                  });
                },
                items: _users.map<DropdownMenuItem<String>>((UserModel user) {
                  return DropdownMenuItem<String>(
                    value: user.id,
                    child: Text(user.name),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Usuário'),
              ),
              ListTile(
                title: Text('Data de Início: ${DateFormat('dd/MM/yyyy HH:mm').format(_startDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context, isStartDate: true),
              ),
              ListTile(
                title: Text('Data de Término: ${DateFormat('dd/MM/yyyy HH:mm').format(_endDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context, isStartDate: false),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    TaskModel updatedTask = widget.taskModel.copy(
                      name: _nameController.text,
                      photo: _photoController.text,
                      difficulty: int.parse(_difficultyController.text),
                      startDate: _startDate,
                      endDate: _endDate,
                      userId: _selectedUserId!,
                    );
                    await TaskDao().update(updatedTask);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
