
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/models/category_helper.dart';
import 'package:todo_app/widget/alert_update_dialog_category.dart';


// ignore: must_be_immutable
class CategoryItem extends StatelessWidget {
  Category category;
  var categoryProvider;
  CategoryItem(this.categoryProvider,{this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 50,
                  color: Color(int.parse(category.colorCode)),
                  margin: EdgeInsets.all(10),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  category.category,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                )
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      FontAwesomeIcons.pen,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      // myProvider.updateCategory(category, newCategory);
                     showDialog(context: context,child: AlertUpdateCategory(category));
                      //AlertUpdateDialog();
                    }),
                IconButton(
                    icon: Icon(
                      FontAwesomeIcons.trash,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      categoryProvider.deleteCategory(category);
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
