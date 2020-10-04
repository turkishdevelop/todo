import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/items/category_item.dart';
import 'package:todo_app/models/category_data.dart';

class CategoryListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<CategoryData>(context);
    return Consumer<CategoryData>(
      builder: (_, categoryData, child) => ListView.builder(
        itemBuilder: (context, index) {
          return CategoryItem(myProvider,
            category: categoryData.categories[index],
          );
        },
        itemCount: categoryData.categoryCount,
      ),
    );
  }
}
