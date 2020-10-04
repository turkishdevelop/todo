import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/category_helper.dart';
import 'package:todo_app/models/category_data.dart';
import 'package:todo_app/utils/app_localization.dart';

// ignore: must_be_immutable
class AlertUpdateCategory extends StatelessWidget {
  Category category;

  AlertUpdateCategory(this.category);

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (_, setState) {
      final myProvider = Provider.of<CategoryData>(_);
      return AlertDialog(
        scrollable: true,
        title: Text(category.category),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.check,
              color: Colors.green,
            ),
            onPressed: () {
              if (categoryController.text != '') {
                if (categoryController.text != '') {
                  category.category = categoryController.text;
                  category.colorCode = currentColor.value.toString();
                  myProvider.updateCategory(
                    category,
                  );
                }
              }
              Navigator.of(_).pop();
            },
            color: Colors.green,
          )
        ],
        content: Container(
          height: MediaQuery.of(_).size.height / 3,
          child: Column(
            children: <Widget>[
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(_)
                        .translate('alertCategoryHintText')),
              ),
              Text(
                AppLocalizations.of(_).translate('alertCategoryChooseColor'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    decoration: TextDecoration.underline),
              ),
              Container(
                width: MediaQuery.of(_).size.width / 2,
                height: MediaQuery.of(_).size.height / 4.4,
                child: BlockPicker(
                  pickerColor: currentColor,
                  onColorChanged: (color) {
                    setState(() {
                      currentColor = color;
                    });
                    //print(currentColor.toString());
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
