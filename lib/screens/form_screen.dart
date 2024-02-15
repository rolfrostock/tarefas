import 'package:flutter/material.dart';
import 'package:tarefas/data/task_dao.dart';
import 'package:tarefas/components/tasks.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }

  bool difficultyValidator(String? value) {
    if (value!.isEmpty || int.parse(value) > 5 || int.parse(value) < 1) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Tarefa'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Tarefa',
                  ),
                  validator: (value) {
                    if (valueValidator(value)) {
                      return 'Insira o nome da Tarefa';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: difficultyController,
                  decoration: const InputDecoration(
                    labelText: 'Dificuldade (1-5)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (difficultyValidator(value)) {
                      return 'Insira uma Dificuldade entre 1 e 5';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'URL da Imagem',
                  ),
                  validator: (value) {
                    if (valueValidator(value)) {
                      return 'Insira uma URL de Imagem!';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newTask = Task(
                          nameController.text,
                          imageController.text,
                          int.parse(difficultyController.text),
                        );
                        TaskDao().save(newTask);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Salvando tarefa...')),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Adicionar Tarefa'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
