import 'package:flutter/animation.dart';

class CategoryModel {
  final String pathImage;
  final int amount;
  final String nameCategory;
  final Color color1;
  final Color color2;
  final bool hasWatermask;
  CategoryModel(
      {required this.pathImage,
      required this.amount,
      required this.nameCategory,
      required this.color1,
      required this.color2,
      required this.hasWatermask});
}
