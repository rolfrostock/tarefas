import 'package:flutter/material.dart';
import 'package:tarefas/components/difficulty.dart';
import 'package:tarefas/data/task_dao.dart';

class Task extends StatefulWidget {
  final String name;
  final String photo;
  final int difficulty;

  Task(this.name, this.photo, this.difficulty, {super.key});

  int level = 0;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  bool assetOrNetwork() {
    if (widget.photo.contains('http')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.blue,
            ),
            height: 140,
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black26,
                      ),
                      width: 80,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: assetOrNetwork()
                            ? Image.asset(widget.photo, fit: BoxFit.cover)
                            : Image.network(widget.photo, fit: BoxFit.cover),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                              fontSize: 24,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Difficulty(widget.difficulty),
                      ],
                    ),
                    SizedBox(
                      height: 52,
                      width: 82,
                      child: ElevatedButton(
                        onLongPress: () {
                          _showDeleteConfirmationPopup(context);
                        },
                        onPressed: () {
                          setState(() {
                            widget.level++;
                          });
                          //print(level);
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(Icons.arrow_drop_up),
                            Text(
                              'Lvl Up',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        color: Colors.white,
                        value: (widget.difficulty > 0)
                            ? (widget.level / widget.difficulty) / 10
                            : 1,
                      ),
                    ),
                    Text(
                      'Nível: ${widget.level}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tem certeza de que deseja deletar essa Tarefa?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o popup
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                TaskDao().delete(widget.name);
                Navigator.of(context).pop(); // Fecha o popup após deletar
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }
}