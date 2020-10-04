
class Task {

  final String name;
  String taskDate;
  String taskTime;
  String taskCategory;
  bool isDone;

  Task({this.name, this.isDone = false,this.taskDate,this.taskCategory,this.taskTime});

  void toggleDone() {
    isDone = !isDone;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Task Name : '+name + ' Task Date : '+taskDate+' Task Time : '+taskTime
    +' Task Category : '+taskCategory;
  }


}
