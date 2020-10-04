import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/layouts/category_list.dart';
import 'package:todo_app/layouts/todo_list.dart';
import 'package:todo_app/models/category_data.dart';
import 'package:todo_app/models/task_data.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/circular_button.dart';
import 'package:todo_app/utils/hex_color.dart';
import 'package:todo_app/widget/alert_category.dart';
import 'package:todo_app/widget/alert_note.dart';
import 'package:todo_app/widget/alert_task.dart';
import 'layouts/notes_list.dart';
import 'models/note_data.dart';
import 'utils/app_localization.dart';



void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskData(),
        ),
        ChangeNotifierProvider(
          create: (context) => NoteData(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          Locale('en', 'US'),
          Locale('tr', 'TR'),
          Locale('fr', 'FR'),
          Locale('ar', 'DZ')
        ],
        localizationsDelegates: [
          // THIS CLASS WILL BE ADDED LATER
          // A class which loads the translations from JSON files
          AppLocalizations.delegate,
          // Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,
          // Built-in localization for text direction LTR/RTL
          GlobalWidgetsLocalizations.delegate,
        ],
        // Returns a locale which will be used by the app
        localeResolutionCallback: (locale, supportedLocales) {
          // Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },
        home: MyAppCover(),
      ),
    ),
  );
}

class MyAppCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyToDoApp();
  }
}

class MyToDoApp extends StatefulWidget {
  @override
  _MyToDoAppState createState() => _MyToDoAppState();
}

class _MyToDoAppState extends State<MyToDoApp>
    with SingleTickerProviderStateMixin {
  int selectedPage = 0;
  DateTime dateTimePicked;

  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void initState() {
    animate();
    dateTimePicked = null;
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();

  }
///@Copyright Abdullah Sevmez - DTAPP 2020
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor(appBarColor),
          title: Text(AppLocalizations.of(context).translate('appbarTitle')),
          centerTitle: true,
        ),
        bottomNavigationBar: Theme(
          data:
              Theme.of(context).copyWith(canvasColor: HexColor(bottomBarColor)),
          child: BottomNavigationBar(
            currentIndex: selectedPage,
            onTap: changePage,
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.white,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.stickyNote),
                title: Text(
                  AppLocalizations.of(context).translate('bottomBarNotes'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.last_page),
                title: Text(
                  AppLocalizations.of(context).translate('bottomBarToDo'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text(
                  AppLocalizations.of(context).translate('bottomBarCategories'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Positioned(
                right: 30,
                bottom: 30,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    IgnorePointer(
                      child: Container(
                        color: Colors.white.withOpacity(0),
                        // comment or change to transparent color
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(270),
                          degOneTranslationAnimation.value * 100),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: CircularButton(
                          color: Colors.blue,
                          width: 50,
                          height: 50,
                          icon: Icon(
                            FontAwesomeIcons.notesMedical,
                            color: Colors.white,
                          ),
                          onClick: () {
                            createTaskOrToDoOrNote(context, 1);

                          },
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(225),
                          degTwoTranslationAnimation.value * 100),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degTwoTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: CircularButton(
                          color: Colors.black,
                          width: 50,
                          height: 50,
                          icon: Icon(
                            FontAwesomeIcons.tasks,
                            color: Colors.white,
                          ),
                          onClick: () {
                            createTaskOrToDoOrNote(context, 2);

                          },
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(180),
                          degThreeTranslationAnimation.value * 100),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degThreeTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: CircularButton(
                          color: Colors.orangeAccent,
                          width: 50,
                          height: 50,
                          icon: Icon(
                            FontAwesomeIcons.listAlt,
                            color: Colors.white,
                          ),
                          onClick: () {
                            createTaskOrToDoOrNote(context, 3);

                          },
                        ),
                      ),
                    ),
                    Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation.value)),
                      alignment: Alignment.center,
                      child: CircularButton(
                        color: HexColor(floatingActionMenuColor),
                        width: 60,
                        height: 60,
                        icon: Icon(
                          FontAwesomeIcons.bars,
                          color: Colors.white,
                        ),
                        onClick: () {
                          if (animationController.isCompleted) {
                            animationController.reverse();
                          } else {
                            animationController.forward();
                          }
                        },
                      ),
                    )
                  ],
                ))
          ],
        ),
        body: (selectedPage == 2)
            ? CategoryListWidget()
            : (selectedPage == 1) ? ToDoListWidget() : NoteListWidget());
  }

  void changePage(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  void setDate(DateTime dateTime) {
    setState(() {
      dateTimePicked = dateTime;
    });
  }

  createTaskOrToDoOrNote(BuildContext context, int index) {
    String title = '';

    if (index == 1) {
      title = AppLocalizations.of(context).translate('alertNoteTitle');
    } else if (index == 2) {
      title = AppLocalizations.of(context).translate('alertTaskTitle');
    } else {
      title = AppLocalizations.of(context).translate('alertCategoryTitle');
    }

    return showDialog(
        context: context,
        builder: (context) {
          if (index == 1) {
            //Add Note
            return AlertNote(title);

          } else if (index == 2) {
            //Add Task
            return AlertTask(index, title);
          } else {
            //Add Category
            return AlertCategory(title);
          }
        });
  }

  void animate() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
  }
}
