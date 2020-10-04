import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/category_data.dart';

import 'package:todo_app/models/category_helper.dart';
import 'package:todo_app/models/task_data.dart';

import 'package:todo_app/models/task_helper.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_localization.dart';
import 'package:todo_app/utils/hex_color.dart';
import 'package:todo_app/utils/local_notifications.dart';

// ignore: must_be_immutable
class TaskItem extends StatelessWidget {
  Task task;
  int id;

  var taskProvider;
  var categoryProvider;

  TaskItem(
    this.taskProvider,
    this.id, {
    this.task,
  });

  TimeOfDay timeOfDay;
  DateTime dateTime;
  Category selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryData>(context);
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)
                    .translate('updateTaskCategory')),
                content: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height / 8,
                    child: DropdownButton<Category>(
                      hint: Text(AppLocalizations.of(context)
                          .translate('selectCategory')),
                      value: selectedCategory,
                      onChanged: (Category category) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      items:
                          categoryProvider.categories.map((Category category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Row(
                            children: <Widget>[
                              Text(category.category),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(
                                      int.parse(category.colorCode),
                                    )),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )),
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Task _newTask = task;

                        if (categoryProvider.categories.isNotEmpty) {
                          _newTask.taskCategory = selectedCategory.category;
                          taskProvider.updateCategory(task);
                        }
                        Navigator.pop(context);
                      }),
                ],
              );
            },
          ),
        );
      },
      child: Card(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width - 160,
                height: MediaQuery.of(context).size.height / 8,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: FutureBuilder(
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapShot) {
                            if (snapShot.hasData) {
                              return Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(int.parse(snapShot.data)),
                                ),
                              );
                            } else {
                              return Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey),
                              );
                            }
                          },
                          future:
                              categoryProvider.getCategory(task.taskCategory),
                        )),
                    Expanded(
                      flex: 9,
                      child: AutoSizeText(
                        task.name,
                        style: TextStyle(fontSize: 20),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.clock,
                        color: Colors.indigo,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder: (_, setState) {
                                return AlertDialog(
                                  actions: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                    IconButton(
                                        icon: Icon(
                                          FontAwesomeIcons.check,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          Task _newTask = task;

                                          if (dateTime != null &&
                                              timeOfDay != null) {
                                            LocalNotification()
                                                .deleteNotificationPlan(id);

                                            _newTask.taskDate =
                                                dateTime.day.toString() +
                                                    '. ' +
                                                    dateTime.month.toString() +
                                                    '.' +
                                                    dateTime.year.toString();

                                            _newTask.taskTime =
                                                timeOfDay.hour.toString() +
                                                    ' : ' +
                                                    timeOfDay.minute.toString();
                                            taskProvider.updateTask(
                                                task, _newTask);

                                            LocalNotification()
                                                .setScheduledNotification(
                                                    timeOfDay.hour,
                                                    timeOfDay.minute,
                                                    dateTime,
                                                    id,
                                                    AppLocalizations.of(context)
                                                        .translate('title'),
                                                    _newTask.name +
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(
                                                                'reminder'));
                                            Navigator.pop(context);
                                          } else {
                                            print('Güncelleme başarısız');
                                          }
                                        }),
                                  ],
                                  content: Container(
                                    width: MediaQuery.of(_).size.width - 20,
                                    height: MediaQuery.of(_).size.height / 6,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.calendarAlt,
                                                color: HexColor(taskIconColors),
                                              ),
                                              onPressed: () {
                                                showDatePicker(
                                                  context: _,
                                                  initialDate: dateTime == null
                                                      ? DateTime.now()
                                                      : dateTime,
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(
                                                      DateTime.now().year + 1),
                                                  helpText: 'Schedule',
                                                ).then((date) {
                                                  setState(() {
                                                    dateTime = date;
                                                  });
                                                });
                                              },
                                            ),
                                            Text(
                                              dateTime == null
                                                  ? AppLocalizations.of(_)
                                                      .translate(
                                                          'alertEmptyDate')
                                                  : dateTime.day.toString() +
                                                      '.' +
                                                      dateTime.month
                                                          .toString() +
                                                      '.' +
                                                      dateTime.year.toString(),
                                              style: TextStyle(
                                                  fontSize: getFontSizeDate(
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height)),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                                icon: Icon(
                                                  FontAwesomeIcons.clock,
                                                  color:
                                                      HexColor(taskIconColors),
                                                ),
                                                onPressed: () {
                                                  showTimePicker(
                                                          context: _,
                                                          initialTime:
                                                              TimeOfDay.now())
                                                      .then((value) {
                                                    setState(() {
                                                      timeOfDay = value;
                                                    });
                                                  });
                                                }),
                                            Text(
                                              timeOfDay == null
                                                  ? AppLocalizations.of(_)
                                                      .translate(
                                                          'alertEmptyTime')
                                                  : timeOfDay.hour.toString() +
                                                      ':' +
                                                      timeOfDay.minute
                                                          .toString(),
                                              style: TextStyle(
                                                  fontSize: getFontSizeTime(
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  title: Text('Update Reminder'),
                                );
                              });
                            });
                      }),
                  Text(task.taskTime.toString()),
                ],
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.flagCheckered,
                  color: Colors.black,
                ),
                onPressed: () {
                  taskProvider.deleteTask(task);
                  LocalNotification().deleteNotificationPlan(id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  getFontSizeTitle(double width, double height) {
    if (width > 380 && width < 415) {
      return 18.0;
    } else if (width > 415 && width < 500) {
      return 20.0;
    }
  }

  getFontSizeDate(double width, double height) {
    if (width > 380 && width < 415) {
      return 16.0;
    } else if (width > 415 && width < 500) {
      return 18.0;
    }
  }

  getFontSizeTime(double width, double height) {
    if (width > 380 && width < 415) {
      return 16.0;
    } else if (width > 415 && width < 500) {
      return 18.0;
    }
  }
}
