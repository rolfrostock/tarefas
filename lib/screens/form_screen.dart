import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importação necessária para o DateFormat
import 'package:tarefas/data/task_dao.dart';
import 'package:tarefas/data/user_dao.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:tarefas/models/user_model.dart';
import 'package:uuid/uuid.dart'; // Importe o pacote uuid aqui

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  String? _selectedUserId;
  List<UserModel> _users = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await UserDao().findAll();
    setState(() {
      _users = users;
      if (_users.isNotEmpty) {
        _selectedUserId = _users.first.id;
      }
    });
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: isStartDate ? _startDate : _endDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStartDate ? _startDate : _endDate),
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
      appBar: AppBar(title: const Text('Nova Tarefa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da tarefa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _photoController,
                decoration: const InputDecoration(labelText: 'Foto URL'),
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
                    return 'Por favor, insira a dificuldade (1-5)';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedUserId,
                items: _users.map((user) => DropdownMenuItem<String>(
                  value: user.id,
                  child: Text(user.name),
                )).toList(),
                onChanged: (value) => setState(() => _selectedUserId = value),
                decoration: InputDecoration(labelText: 'Usuário'),
              ),
              ListTile(
                title: Text("Data de Início: ${DateFormat('dd/MM/yyyy HH:mm').format(_startDate)}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context, true),
              ),
              ListTile(
                title: Text("Data de Fim: ${DateFormat('dd/MM/yyyy HH:mm').format(_endDate)}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context, false),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _selectedUserId != null) {
                    var newTask = TaskModel(
                      id: Uuid().v4(),
                      name: _nameController.text,
                      photo: _photoController.text,
                      difficulty: int.parse(_difficultyController.text),
                      startDate: _startDate,
                      endDate: _endDate,
                      userId: _selectedUserId!, // Utiliza o userId selecionado no dropdown
                    );
                    await TaskDao().save(newTask);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
