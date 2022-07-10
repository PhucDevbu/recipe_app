import 'package:flutter/material.dart';
import 'package:recipe_app/services/remote_services.dart';

import '../models/category.dart';

class CategoryProvider with ChangeNotifier{
  bool isLoading = true;
  List<Category> categories = [];

  CategoryProvider(){
    fetchData();
  }

  void fetchData() async{
    categories = await RemoteServices.fetchCategories();
    categories[0].isChose=true;
    isLoading = false;
    notifyListeners();
  }

  void choseCategory(Category category) async{
    int indexOfCategory = categories.indexOf(category);
    for(int i=0;i<categories.length;i++){
      categories[i].isChose =false;
    }
    categories[indexOfCategory].isChose = true;

    notifyListeners();
  }
}