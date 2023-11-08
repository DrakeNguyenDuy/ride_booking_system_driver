import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/constants/constants/assets_images.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/data/model/bottom_nav_bar_item_model.dart';
import 'package:ride_booking_system_driver/data/model/category_model.dart';
import 'package:ride_booking_system_driver/data/model/item_small_model.dart';

//list bottom navbar item
List<BottomNavBarItemModel> listItemNavbar = [
  BottomNavBarItemModel(icon: Icons.directions_car, nameItem: "Home"),
  BottomNavBarItemModel(
    icon: Icons.history,
    nameItem: "History",
  ),
  BottomNavBarItemModel(
    icon: Icons.wallet,
    nameItem: "Wallet",
  ),
  // BottomNavBarItemModel(
  //   icon: Icons.developer_board,
  //   nameItem: "Đề xuất",
  // )
  // ,
  BottomNavBarItemModel(
    icon: Icons.person,
    nameItem: "Personal",
  )
];
//list short cut
List<ItemSmallModel> listShortcut = [
  ItemSmallModel(image: AssetImages.stackIc, name: "Thiết bị"),
  ItemSmallModel(image: AssetImages.stackIc, name: "Tạo đề xuất"),
  ItemSmallModel(image: AssetImages.stackIc, name: "Công việc chưa làm"),
  ItemSmallModel(image: AssetImages.stackIc, name: "Ghi chú")
];
//list category left
List<CategoryModel> listCategoryLeft = [
  CategoryModel(
      pathImage: AssetImages.newIc,
      amount: 1,
      nameCategory: "Công việc mới",
      color1: ColorPalette.blueLightColor,
      color2: ColorPalette.primaryColor,
      hasWatermask: false),
  CategoryModel(
      pathImage: AssetImages.approvedIc,
      amount: 1,
      nameCategory: "Đề xuất đã duyệt",
      color1: ColorPalette.primaryColor,
      color2: ColorPalette.white,
      hasWatermask: false)
];
//list of the category right
List<CategoryModel> listCategoryRight = [
  CategoryModel(
      pathImage: AssetImages.newOfferIc,
      amount: 21,
      nameCategory: "Đề xuất mới",
      color1: ColorPalette.primaryColor,
      color2: ColorPalette.white,
      hasWatermask: true),
  CategoryModel(
      pathImage: AssetImages.outOfTimeIc,
      amount: 12,
      nameCategory: "Công việc quá hạn",
      color1: ColorPalette.blueLightColor,
      color2: ColorPalette.primaryColor,
      hasWatermask: false),
];
