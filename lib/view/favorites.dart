import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/category_provider.dart';
import 'package:recipe_app/view/shared.dart';

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
                      return buildFavorites(categoryProvider.mealFavorites[index],context);
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



}
