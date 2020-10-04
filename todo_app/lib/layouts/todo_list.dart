import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/items/task_item.dart';
import 'package:todo_app/models/task_data.dart';

class ToDoListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskData>(context);

    return Consumer<TaskData>(
      builder: (_, taskData, child) => ListView.builder(
        itemBuilder: (context, index) {
          return TaskItem(
            taskProvider,
            index,
            task: taskProvider.tasks[index],
          );
        },
        itemCount: taskData.tasks.length,
      ),
    );
  }
}
