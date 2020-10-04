import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart' as foundation;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:todo_app/models/task_helper.dart';

class TaskData extends foundation.ChangeNotifier {
  List<Task> _tasks = [];
  var box;

  TaskData() {
    initializeDatabase();
  }

  initializeDatabase() async {
    Directory dir = await getExternalStorageDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(TaskAdapter());

    Hive.openBox<Task>('task').then(
      (value) {
        value.values.forEach((element) {
          print(element.name);
          _tasks.add(element);
          notifyListeners();
        });
      },
    );
  }

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  int get taskListCount => _tasks.length;

  void addTask(Task task) async {
    print('Görev Adı : ' + task.name);
    print('Görev Kategorisi : ' + task.taskCategory.toString());
    print('Görev Zamanı : ' + task.taskTime.toString());
    print('Görev Tarihi : ' + task.taskDate.toString());

    box = await Hive.openBox<Task>('task').then((value) {
      value.add(task);
      _tasks.add(task);
      notifyListeners();
    });
  }

  void deleteTask(Task task) async {
    int index = _tasks.indexOf(task);
    box = await Hive.openBox<Task>('task').then((value) {
      value.deleteAt(index);
      _tasks.remove(task);
      notifyListeners();
    });
  }

  void updateTask(Task oldTask, Task newTask) async {
    int index = _tasks.indexOf(oldTask);
    box = await Hive.openBox<Task>('task').then((value) {
      value.putAt(index, newTask);
      _tasks[_tasks.indexWhere((task) => task == task)] = newTask;
      notifyListeners();
    });
  }

  void updateCategory(Task task) async {
    int index = _tasks.indexOf(task);
    box = await Hive.openBox<Task>('task').then((value) {
      value.putAt(index, task);
      notifyListeners();
    });

  }
}
