import 'package:flutter/material.dart';
import 'package:tarefas/components/difficulty.dart';
import 'package:tarefas/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskWidget extends StatelessWidget {
  final TaskModel task;

  const TaskWidget({super.key, required this.task});

  bool assetOrNetwork() {
    return task.photo.contains('http');
  }

  @override
  Widget build(BuildContext context) {
    // Formatar as datas
    final String startDateFormatted = DateFormat('dd/MM/yyyy').format(task.startDate);
    final String endDateFormatted = DateFormat('dd/MM/yyyy').format(task.endDate);

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
                            ? Image.network(task.photo, fit: BoxFit.cover)
                            : Image.asset(task.photo, fit: BoxFit.cover),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            task.name,
                            style: const TextStyle(
                              fontSize: 24,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Difficulty(task.difficulty),
                      ],
                    ),
                    Text(
                      'Nível: ${task.difficulty}',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Início: $startDateFormatted',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Text(
                      'Fim: $endDateFormatted',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
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

}
