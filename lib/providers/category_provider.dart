import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recipe_app/services/remote_services.dart';

import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';
import '../view/detail.dart';

class CategoryProvider with ChangeNotifier{
  bool isLoadingCategory = true;
  bool isLoadingMeal = true;
  bool isLoadingMealDetail = true;
  List<Category> categories = [];
  List<Meal> meals = [];
  List<MealDetail> mealDetail= [];


  CategoryProvider(){
    fetchData();
  }

  void fetchData() async{
    categories = await RemoteServices.fetchCategories();
    categories[0].isChose=true;
    isLoadingCategory = false;
    meals = await RemoteServices.fetchMeal(categories[0].strCategory);
    isLoadingMeal = false;
    notifyListeners();
  }

  // void fetchMealDefault() async{
  //   meal = await RemoteServices.fetchMeal(categories[0].strCategory);
  //   isLoadingMeal = false;
  //   notifyListeners();
  // }

  int random(min, max) {
    return min + Random().nextInt(max - min);
  }
  void choseCategory(Category category) async{
    int indexOfCategory = categories.indexOf(category);
    for(int i=0;i<categories.length;i++){
      categories[i].isChose =false;
    }
    categories[indexOfCategory].isChose = true;
    meals = await RemoteServices.fetchMeal(categories[indexOfCategory].strCategory);
    for(int i=0;i<meals.length;i++){
      meals[i].calo =random(150, 300).toString();
    }

    notifyListeners();
  }

  void choseMeal(Meal meal,BuildContext context) async{
    int indexOfMeal = meals.indexOf(meal);
    mealDetail = await RemoteServices.fetchMealDetail(meals[indexOfMeal].idMeal);
    print("get mealDetail");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Detail(mealDetail: mealDetail[0])),
    );
    notifyListeners();
  }
}