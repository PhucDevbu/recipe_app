import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/meal_detail.dart';
import 'package:recipe_app/providers/category_provider.dart';
import 'package:recipe_app/view/shared.dart';

import 'constants.dart';
import 'detail.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [],
      ),
      body: SafeArea(
        child: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            if(categoryProvider.mealFavorites.length>0){
              return Container(
                child: ListView.builder(
                    itemCount: categoryProvider.mealFavorites.length,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return buildFavorites(categoryProvider.mealFavorites[index]);
                    }),
              );
            }else{
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("Empty favorites",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
              );
            }

          },
        ),
      ),
    );
  }


  Widget buildFavorites(MealDetail mealFavorites) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Detail(mealDetail: mealFavorites)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [kBoxShadow],
        ),
        child: Row(
          children: [
            Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20)),
                image: DecorationImage(
                  image: NetworkImage(mealFavorites.strMealThumb),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRecipeTitle(mealFavorites.strMeal),
                    buildRecipeSubTitle(mealFavorites.strCategory),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
