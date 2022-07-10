import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/view/shared.dart';

import '../models/data.dart';
import '../providers/category_provider.dart';
import 'constants.dart';
import 'detail.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        leading: Icon(
          Icons.sort,
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextTitleVariation1('Recipes App'),
                  buildTextSubTitleVariation1(
                      'Healthy and nutritious food recipes'),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    height: 50,
                    child: Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, child) {
                          if (categoryProvider.isLoading == true) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (categoryProvider.categories.length > 0) {
                              return ListView.builder(

                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: categoryProvider.categories.length,
                                itemBuilder: (context, index) {
                                  //Category currentCategory = categoryProvider.categories[index] ;
                                  print(categoryProvider.categories[index].idCategory);
                                  return GestureDetector(
                                    onTap: () {
                                      // setState(() {
                                      //   optionSelected[index] = !optionSelected[index];
                                      // });
                                      categoryProvider.choseCategory(categoryProvider.categories[index]);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: categoryProvider.categories[index].isChose ? kPrimaryColor : Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        boxShadow: [kBoxShadow],
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage:
                                            NetworkImage(categoryProvider.categories[index].strCategoryThumb),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            categoryProvider.categories[index].strCategory,
                                            style: TextStyle(
                                              color: categoryProvider.categories[index].isChose ? Colors.white : Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [Text('Data empty')],
                              );
                            }
                          }
                        }),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 24,
            ),
            Container(
              height: 350,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: buildRecipes(),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  buildTextTitleVariation2('Popular', false),
                  SizedBox(
                    width: 8,
                  ),
                  buildTextTitleVariation2('Food', true),
                ],
              ),
            ),
            Container(
              height: 190,
              child: PageView(
                physics: BouncingScrollPhysics(),
                children: buildPopulars(),
              ),
            )
          ],
        ),
      ),
    );
  }


  List<Widget> buildRecipes() {
    List<Widget> list = [];
    for (var i = 0; i < getRecipes().length; i++) {
      list.add(buildRecipe(getRecipes()[i], i));
    }
    return list;
  }

  Widget buildRecipe(Recipe recipe, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Detail(recipe: recipe)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [kBoxShadow],
        ),
        margin: EdgeInsets.only(
            right: 16, left: index == 0 ? 16 : 0, bottom: 16, top: 8),
        padding: EdgeInsets.all(16),
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: recipe.image,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(recipe.image),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            buildRecipeTitle(recipe.title),
            buildTextSubTitleVariation2(recipe.description),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildCalories(recipe.calories.toString() + " Kcal"),
                Icon(
                  Icons.favorite_border,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildPopulars() {
    List<Widget> list = [];
    for (var i = 0; i < getRecipes().length; i++) {
      list.add(buildPopular(getRecipes()[i]));
    }
    return list;
  }

  Widget buildPopular(Recipe recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Detail(recipe: recipe)),
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
                image: DecorationImage(
                  image: AssetImage(recipe.image),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRecipeTitle(recipe.title),
                    buildRecipeSubTitle(recipe.description),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildCalories(recipe.calories.toString() + " Kcal"),
                        Icon(
                          Icons.favorite_border,
                        )
                      ],
                    ),
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
