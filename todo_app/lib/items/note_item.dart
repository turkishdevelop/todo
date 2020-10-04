import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/utils/app_localization.dart';

import '../models/note_helper.dart';
import 'package:todo_app/widget/alert_delete_dialog_note.dart';
import 'package:todo_app/widget/alert_update_dialog_note.dart';

// ignore: must_be_immutable
class NoteItem extends StatelessWidget {
  Note note;

  NoteItem({this.note});

  var width;
  var height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Container(
      width: getScreenWidth(width),
      height: getScreenHeight(height),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SizedBox(
                    width: width - 30,
                    height: height / 3,
                    child: AutoSizeText(note.note),
                  ),
                  title: Text(AppLocalizations.of(context).translate('yourNote')),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 30,
                    height: MediaQuery.of(context).size.height / 8,
                    child: AutoSizeText(
                      note.note,
                      style: TextStyle(fontSize: 20),
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.pen),
                    onPressed: () {
                      //Notun düzenlenmesi için kullanılacak buton
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertUpdateDialog(note);
                          });
                    },
                    color: Colors.green,
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.trash),
                    onPressed: () {
                      //Notun silinmesi için kullanılacak buton

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDeleteDialog(
                              note: note,
                            );
                          });
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getScreenWidth(pWidth) {
    if (pWidth < 400) {
      return width - 120;
    } else if (pWidth < 430) {
      return width - 80;
    } else if (pWidth < 460) {
      return width - 60;
    } else if (pWidth < 500) {
      return width - 40;
    } else if (pWidth < 560) {
      return width - 35;
    } else {
      return width - 20;
    }
  }

  getScreenHeight(pHeight) {
    if (pHeight < 500) {
      return height / 3;
    }
  }
}
