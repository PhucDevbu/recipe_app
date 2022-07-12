import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recipe_app/models/local_storage.dart';
import 'package:recipe_app/services/remote_services.dart';

import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';
import '../view/detail.dart';
import '../view/favorites.dart';

class CategoryProvider with ChangeNotifier {
  bool isLoadingCategory = true;
  bool isLoadingMeal = true;
  bool isLoadingMealDetail = true;
  List<Category> categories = [];
  List<Meal> meals = [];
  List<MealDetail> mealDetail = [];
  List<MealDetail> temps = [];
  List<MealDetail> mealFavoritesTemp = [];
  List<MealDetail> mealFavorites = [];

  CategoryProvider() {
    fetchData();
  }

  void fetchData() async {
    categories = await RemoteServices.fetchCategories();
    categories[0].isChose = true;
    isLoadingCategory = false;
    meals = await RemoteServices.fetchMeal(categories[0].strCategory);
    isLoadingMeal = false;

    notifyListeners();
  }

  List<MealDetail> removeDuplicates(List<MealDetail> people) {
    //create one list to store the distinct models
    List<MealDetail> distinct;
    List<MealDetail> dummy = people;

    for(int i = 0; i < people.length; i++) {
      for (int j = 1; j < dummy.length; j++) {
        if (dummy[i].idMeal == people[j].idMeal) {
          dummy.removeAt(j);
        }
      }
    }
    distinct = dummy;
    print(distinct);

    return distinct.map((e) => e).toList();
  }

  void fetchFavorites(BuildContext context) async {
    mealFavorites=[];
    List<String> favorites = await LocalStorage.fetchFavorites();
    for (var meal in meals) {
      if (favorites.contains(meal.idMeal)) {
        temps = await RemoteServices.fetchMealDetail(meal.idMeal);

          if (favorites.contains(temps[0].idMeal)) {
            temps[0].isFavorite = true;
            mealFavorites.add(temps[0]);
          }

      }
    }
    //mealFavorites=removeDuplicates(mealFavorites);
    //mealFavorites = mealFavoritesTemp.length>0?mealFavoritesTemp:mealFavorites;

    notifyListeners();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Favorites()),
    );
  }

  void fetchFavoritesDetail(BuildContext context) async {
    mealFavorites=[];
    List<String> favorites = await LocalStorage.fetchFavorites();
    for (var meal in meals) {
      if (favorites.contains(meal.idMeal)) {
        temps = await RemoteServices.fetchMealDetail(meal.idMeal);

        if (favorites.contains(temps[0].idMeal)) {
          temps[0].isFavorite = true;
          mealFavorites.add(temps[0]);
        }

      }
    }
    //mealFavorites=removeDuplicates(mealFavorites);
    //mealFavorites = mealFavoritesTemp.length>0?mealFavoritesTemp:mealFavorites;

    notifyListeners();
    Navigator.pop(context);
  }

  int random(min, max) {
    return min + Random().nextInt(max - min);
  }

  void choseCategory(Category category) async {
    int indexOfCategory = categories.indexOf(category);
    for (int i = 0; i < categories.length; i++) {
      categories[i].isChose = false;
    }
    categories[indexOfCategory].isChose = true;
    meals =
        await RemoteServices.fetchMeal(categories[indexOfCategory].strCategory);
    for (int i = 0; i < meals.length; i++) {
      meals[i].calo = random(150, 300).toString();
    }

    notifyListeners();
  }

  void choseMeal(Meal meal, BuildContext context) async {
    int indexOfMeal = meals.indexOf(meal);
    mealDetail =
        await RemoteServices.fetchMealDetail(meals[indexOfMeal].idMeal);
    List<String> favorites = await LocalStorage.fetchFavorites();
    if (favorites.contains(mealDetail[0].idMeal)) {
      mealDetail[0].isFavorite = true;
    }
    print("get mealDetail");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Detail(mealDetail: mealDetail[0])),
    );
    notifyListeners();
  }

  void addFavorite(MealDetail mealDetail) async {
    mealDetail.isFavorite = true;
    await LocalStorage.addFavorite(mealDetail.idMeal);
    print("add ${mealDetail.idMeal}");

    notifyListeners();
  }

  void removeFavorite(MealDetail mealDetail) async {
    mealDetail.isFavorite = false;
    await LocalStorage.removeFavorite(mealDetail.idMeal);

    notifyListeners();
  }
}
