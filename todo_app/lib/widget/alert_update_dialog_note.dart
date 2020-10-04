import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/note_helper.dart';
import 'package:todo_app/models/note_data.dart';
import 'package:todo_app/utils/app_localization.dart';

// ignore: must_be_immutable
class AlertUpdateDialog extends StatelessWidget {

  final updateController = TextEditingController();
  Note _oldNote;
  AlertUpdateDialog(this._oldNote);

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<NoteData>(context);
    return AlertDialog(
      content: TextField(
        controller: updateController,
        decoration: InputDecoration(hintText: AppLocalizations.of(context).translate('alertAskingUpdate')),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(FontAwesomeIcons.ban),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.red,
        ),
        IconButton(
          icon: Icon(FontAwesomeIcons.check),
          onPressed: () {

            myProvider.updateNote(_oldNote,Note(note: updateController.text));
            Navigator.pop(context);
          },
          color: Colors.green,
        ),
      ],
    );
  }
}
