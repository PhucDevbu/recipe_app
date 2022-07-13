import 'package:flutter/material.dart';
import 'package:recipe_app/models/meal_detail.dart';
import 'package:recipe_app/services/remote_services.dart';

class SearchProvider with ChangeNotifier{
  List<MealDetail> searchMeal = [];
  void fetchSearch(String search) async{
    searchMeal = await RemoteServices.fetchSearch(search);
    notifyListeners();
  }
}