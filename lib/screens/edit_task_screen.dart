//lib/screens/edit_task_screen.dart
import 'package:flutter/material.dart';
import 'package:tarefas/data/task_dao.dart';
import 'package:tarefas/data/user_dao.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:tarefas/models/user_model.dart';
import 'package:intl/intl.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel taskModel;
  final String userId; // Adiciona a declaração do campo userId

  const EditTaskScreen({Key? key, required this.taskModel, required this.userId}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  late DateTime _startDate;
  late DateTime _endDate;
  String? _selectedUserId;
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.taskModel.name;
    _photoController.text = widget.taskModel.photo;
    _difficultyController.text = widget.taskModel.difficulty.toString();
    _startDate = widget.taskModel.startDate;
    _endDate = widget.taskModel.endDate;
    _loadUsers();
    _selectedUserId = widget.userId; // Utiliza o userId passado para o widget
  }

  Future<void> _loadUsers() async {
    final users = await UserDao().findAll(); // Carrega todos os usuários
    setState(() {
      _users = users;
      // Adiciona uma opção para representar a não atribuição a um usuário
      _users.insert(0, UserModel(id: 'none', name: 'Sem Usuário', email: ''));
      // Se _selectedUserId não corresponde a nenhum usuário, ajusta para 'none'
      if (!_users.any((user) => user.id == _selectedUserId)) {
        _selectedUserId = 'none';
      }
    });
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
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

  void _updateTask() async {
    if (_formKey.currentState!.validate()) {
      TaskModel updatedTask = widget.taskModel.copy(
        name: _nameController.text,
        photo: _photoController.text,
        difficulty: int.parse(_difficultyController.text),
        startDate: _startDate,
        endDate: _endDate,
        userId: _selectedUserId, // Atualiza com o novo userId selecionado
      );

      await TaskDao().update(updatedTask);
      Navigator.of(context).pop();
    }
  }

  final _formKey = GlobalKey<FormState>();

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
                decoration: const InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a URL da imagem';
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
              // Campos para seleção de data e hora
              ElevatedButton(
                onPressed: () => _selectDateTime(context, true),
                child: Text('Selecionar Data de Início: ${DateFormat('dd/MM/yyyy HH:mm').format(_startDate)}'),
              ),
              ElevatedButton(
                onPressed: () => _selectDateTime(context, false),
                child: Text('Selecionar Data de Fim: ${DateFormat('dd/MM/yyyy HH:mm').format(_endDate)}'),
              ),
              ElevatedButton(
                onPressed: _updateTask,
                child: const Text('Salvar Alterações'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedUserId,
                onChanged: (newValue) {
                  setState(() {
                    _selectedUserId = newValue;
                  });
                },
                items: _users.map<DropdownMenuItem<String>>((UserModel user) {
                  return DropdownMenuItem<String>(
                    value: user.id,
                    child: Text(user.name),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Atribuir a',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
