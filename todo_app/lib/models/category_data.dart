import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart' as foundation;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'category_helper.dart';

class CategoryData extends foundation.ChangeNotifier {
  List<Category> _categories = [];
  var box;

  CategoryData() {
    initializeDatabase();
  }

  initializeDatabase() async {
    Directory dir = await getExternalStorageDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(CategoryAdapter());
    Hive.openBox<Category>('category').then(
      (value) {
        value.values.forEach((element) {
          print(element.category);
          _categories.add(element);
          notifyListeners();
        });
      },
    );
  }

  ///
  UnmodifiableListView<Category> get categories {
    return UnmodifiableListView(_categories);
  }

  int get categoryCount => _categories.length;

  void addCategory(Category category) async {
    box = await Hive.openBox<Category>('category').then((value) {
      value.add(category);
      _categories.add(category);
    });
    notifyListeners();
  }

  // ignore: missing_return
  Future<String> getCategory(String categoryName) async {
    String colorCode;
    var box = await Hive.openBox<Category>('category').then((value) {
      value.values.forEach((element) {
        if (categoryName == element.category) {
          print(element.category);
          return colorCode = element.colorCode;
        }
      });
    });
    return colorCode;
  }

  void deleteCategory(Category category) async {
    int index = _categories.indexOf(category);
    box = await Hive.openBox<Category>('category').then((value) {
      value.deleteAt(index);
      _categories.remove(category);
      notifyListeners();
    });
  }

  void updateCategory(Category category) async {
    int index = _categories.indexOf(category);
    box = await Hive.openBox<Category>('category').then((value) {
      value.putAt(index, category);
      _categories[_categories.indexWhere((category) => category == category)] =
          category;
      notifyListeners();
    });
  }
}
