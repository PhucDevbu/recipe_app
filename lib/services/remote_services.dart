
import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:recipe_app/models/meal.dart';
import 'package:recipe_app/models/meal_detail.dart';

import '../models/category.dart';

class RemoteServices{
  static var client = http.Client();

  static Future<List<Category>> fetchCategories() async{
    Uri requestPath = Uri.parse("https://www.themealdb.com/api/json/v1/1/categories.php");

    var response = await http.get(requestPath);
    var data = List<Map<String, dynamic>>.from(json.decode(response.body)["categories"]).map((json) => Category.fromJson(json)).toList();

    return data;
  }

  static Future<List<Meal>> fetchMeal(String category) async{
    Uri requestPath = Uri.parse("https://www.themealdb.com/api/json/v1/1/filter.php?c=$category");

    var response = await http.get(requestPath);
    var data = List<Map<String, dynamic>>.from(json.decode(response.body)["meals"]).map((json) => Meal.fromJson(json)).toList();

    return data;
  }
  static Future<List<MealDetail>> fetchMealDetail(String id) async{
    Uri requestPath = Uri.parse("https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id");

    var response = await http.get(requestPath);
    var data = List<Map<String, dynamic>>.from(json.decode(response.body)["meals"]).map((json) => MealDetail.fromJson(json)).toList();

    return data;
  }

  static Future<List<MealDetail>> fetchSearch(String search) async{
    Uri requestPath = Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?s=$search");

    var response = await http.get(requestPath);
    var data = List<Map<String, dynamic>>.from(json.decode(response.body)["meals"]).map((json) => MealDetail.fromJson(json)).toList();

    return data;
  }

}