import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/category_helper.dart';
import 'package:todo_app/models/category_data.dart';
import 'package:todo_app/utils/admob_service.dart';
import 'dart:math' as math;
import '../models/task_helper.dart';
import 'package:todo_app/models/task_data.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_localization.dart';
import 'package:todo_app/utils/hex_color.dart';
import 'package:todo_app/utils/local_notifications.dart';

///@Copyright Abdullah Sevmez-DTAPP 24.09.2020
// ignore: must_be_immutable
class AlertTask extends StatelessWidget {
  int index;
  String title;
  DateTime dateTime;
  TimeOfDay timeOfDay;

  var titleFontSize = 0;

  AlertTask(this.index, this.title, {this.timeOfDay, this.dateTime});

  Category selectedCategory;
  final taskController = TextEditingController();
  AdmobService admobService = AdmobService();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    if (index == 2) {
      return StatefulBuilder(builder: (_, setState) {
        final myProvider = Provider.of<CategoryData>(context);
        final taskProvider = Provider.of<TaskData>(context);
        return AlertDialog(
          scrollable: true,
          title: Text(
            title,
            style: TextStyle(fontSize: getFontSizeTitle(width, height)),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.check,
                color: Colors.green,
              ),
              onPressed: () {
                Task _createdTask = Task(
                  name: taskController.text,
                  taskCategory: selectedCategory.category == null
                      ? ''
                      : selectedCategory.category,
                  taskTime: timeOfDay == null
                      ? ''
                      : timeOfDay.hour.toString() +
                          ' : ' +
                          timeOfDay.minute.toString(),
                  taskDate: dateTime.day.toString() +
                      '. ' +
                      dateTime.month.toString() +
                      '.' +
                      dateTime.year.toString(),
                  isDone: false,
                );

                int random = math.Random().nextInt(10);

                if (random==5||random==8||random==6) {
                  admobService.showFullAd();
                }

                if (_createdTask != null && _createdTask.name != '' ||
                    null &&
                        _createdTask.taskTime != '' &&
                        null &&
                        _createdTask.taskDate != '' &&
                        null &&
                        _createdTask.taskCategory != null) {
                  taskProvider.addTask(_createdTask);
                  LocalNotification().setScheduledNotification(
                      timeOfDay.hour,
                      timeOfDay.minute,
                      dateTime,
                      taskProvider.tasks.indexOf(_createdTask),
                      AppLocalizations.of(context).translate('title'),
                      _createdTask.name +
                          AppLocalizations.of(context).translate('reminder'));
                } else {}

                Navigator.of(_).pop();
              },
              color: Colors.green,
            )
          ],
          content: Container(
            height: height / 3.1,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: taskController,
                  maxLength: 30,
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(_).translate('alertTaskHintText'),
                  ),
                  textDirection: TextDirection.ltr,
                  autocorrect: true,
                  cursorColor: HexColor(cursorColorToAdd),
                ),
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
                            initialDate:
                                dateTime == null ? DateTime.now() : dateTime,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1),
                            helpText: 'Schedule',
                          ).then((date) {
                            setState(() {
                              dateTime = date;
                            });
                          });
                        }),
                    Text(
                      dateTime == null
                          ? AppLocalizations.of(_).translate('alertEmptyDate')
                          : dateTime.day.toString() +
                              '.' +
                              dateTime.month.toString() +
                              '.' +
                              dateTime.year.toString(),
                      style:
                          TextStyle(fontSize: getFontSizeDate(width, height)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.clock,
                          color: HexColor(taskIconColors),
                        ),
                        onPressed: () {
                          showTimePicker(
                                  context: _, initialTime: TimeOfDay.now())
                              .then((value) {
                            setState(() {
                              timeOfDay = value;
                            });
                          });
                        }),
                    Text(
                      timeOfDay == null
                          ? AppLocalizations.of(_).translate('alertEmptyTime')
                          : timeOfDay.hour.toString() +
                              ':' +
                              timeOfDay.minute.toString(),
                      style:
                          TextStyle(fontSize: getFontSizeTime(width, height)),
                    ),
                  ],
                ),
                Text(AppLocalizations.of(_)
                    .translate('alertTaskInlineTitleCategory')),
                myProvider.categories.length > 0
                    ? getDropDownList(myProvider.categories, setState, _)
                    : Text(AppLocalizations.of(context).translate('shouldAddCategory')),
              ],
            ),
          ),
        );
      });
    }
  }

  getDropDownList(List<Category> categoryList, setState, BuildContext context) {
    if (categoryList.length > 0) {
      return Expanded(
        flex: 1,
        child: DropdownButton<Category>(
          hint: Text(AppLocalizations.of(context).translate('selectCategory')),
          value: selectedCategory,
          onChanged: (Category category) {
            setState(() {
              selectedCategory = category;
            });
          },
          items: categoryList.map((Category category) {
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
        ),
      );
    }
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
