
import 'package:hive/hive.dart';

part '../adapters/task_helper.g.dart';
@HiveType(typeId: 2)
class Task {

  @HiveField(0)
  String name;
  @HiveField(1)
  String taskDate;
  @HiveField(2)
  String taskTime;
  @HiveField(3)
  String taskCategory;
  @HiveField(4)
  bool isDone;

  Task({this.name, this.isDone = false,this.taskDate,this.taskCategory,this.taskTime});

  @override
  String toString() {
    return 'Task Name : '+name + ' Task Date : '+taskDate+' Task Time : '+taskTime
        +' Task Category : '+taskCategory;
  }


}
