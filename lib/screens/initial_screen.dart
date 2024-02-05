import 'package:flutter/material.dart';
import 'package:tarefas/components/tasks.dart';
import 'package:tarefas/data/task_dao.dart';
import 'package:tarefas/data/task_inherited.dart';
import 'package:tarefas/screens/form_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          )
        ],
        title: const Text('Tarefas'),
        leading: const Icon(Icons.add_task),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 70),
        child: FutureBuilder(
            future: TaskDao().findAll(),
            builder: (context, snapshot) {
              List<Task>? items = snapshot.data as List<Task>?;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text('Carregando'),
                      ],
                    ),
                  );
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text('Carregando'),
                      ],
                    ),
                  );
                  break;
                case ConnectionState.active:
                  return Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text('Carregando'),
                      ],
                    ),
                  );
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData && items != null) {
                    if (items.isNotEmpty) {
                      //colar o cód recortado aqui...
                      return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            final Task tarefa = items[index];
                            return tarefa;
                          });
                    }
                    return Center(
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, size: 128),
                          Text(
                            'Não há nenhuma Tarefa',
                            style: TextStyle(fontSize: 32),
                          )
                        ],
                      ),
                    );
                  }
                  return Text('Erro ao carregar Tarefas');
                  break;
              }
              return Text('Erro desconhecido');
              //return Container();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contextNew) => FormScreen(
                taskContext: context,
              ),
            ),
          ).then((value) => setState(() {
                print('Recarregando a tela inicial');
              }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
