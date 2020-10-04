
import 'package:hive/hive.dart';

part '../adapters/category_helper.g.dart';

@HiveType(typeId: 0)
class Category {

  @HiveField(0)
  String category;
 
  @HiveField(1)
  String colorCode;

  Category({this.category,this.colorCode});
}