import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/theme_provider.dart';
import 'package:recipe_app/view/search.dart';
import 'package:recipe_app/view/shared.dart';

import '../models/data.dart';
import '../providers/category_provider.dart';
import 'app_button.dart';
import 'constants.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, child) {
                      return AppButton(label: 'Favorites', onTap: () {
                        categoryProvider.fetchFavorites(context);
                      });
                    })),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(

              onPressed: (){
                showSearch(context: context, delegate: MySearchDelegate());
              },
              icon: Icon(Icons.search),
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
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recipes App',
                          style: GoogleFonts.breeSerif(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            themeProvider.toggleTheme();
                          },
                          padding: EdgeInsets.all(0),
                          icon: (themeProvider.themeMode == ThemeMode.light)
                              ? Icon(Icons.dark_mode)
                              : Icon(Icons.light_mode),
                        )
                      ],
                    ),
                  ),
                  buildTextSubTitleVariation1(
                      'Healthy and nutritious food recipes', context),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    height: 50,
                    child: Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, child) {
                      if (categoryProvider.isLoadingCategory == true) {
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
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    categoryProvider.choseCategory(
                                        categoryProvider.categories[index]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: categoryProvider
                                              .categories[index].isChose
                                          ? kPrimaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      boxShadow: [kBoxShadow],
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                              categoryProvider.categories[index]
                                                  .strCategoryThumb),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          categoryProvider
                                              .categories[index].strCategory,
                                          style: TextStyle(
                                            color: categoryProvider
                                                    .categories[index].isChose
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
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
              child: Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                if (categoryProvider.isLoadingMeal == true) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (categoryProvider.meals.length > 0) {
                    return ListView.builder(
                      itemCount: categoryProvider.meals.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            categoryProvider.choseMeal(
                                categoryProvider.meals[index], context);
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
                                right: 16,
                                left: index == 0 ? 16 : 0,
                                bottom: 16,
                                top: 8),
                            padding: EdgeInsets.all(16),
                            width: 220,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(
                                  child: Hero(
                                    tag: categoryProvider
                                        .meals[index].strMealThumb,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(categoryProvider
                                              .meals[index].strMealThumb),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                buildRecipeTitle(
                                    categoryProvider.meals[index].strMeal),
                                buildTextSubTitleVariation2("Very delicious"),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildCalories(
                                        categoryProvider.meals[index].calo +
                                            " Kcal"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
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
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  buildTextTitleVariation2('Popular'),
                  SizedBox(
                    width: 8,
                  ),
                  buildTextTitleVariation3('Food', context),
                ],
              ),
            ),
            Container(
              height: 190,
              child: PageView(
                physics: BouncingScrollPhysics(),
                children: buildPopulars(),
              ),
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
      onTap: () {},
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

class MealView extends StatelessWidget {
  const MealView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
class MySearchDelegate extends SearchDelegate{
  @override
  List<Widget>? buildActions(BuildContext context) {
    IconButton(
      icon: Icon(Icons.clear),
      onPressed:()=>close(context, null) ,
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        if(query.isEmpty){
          close(context, null);
        }else{
          query='';
        }

      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Search(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = [
      'chicken',
      'beef',
    ];
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context,index){
        return ListTile(
          title: Text(suggestions[index]),
          onTap: (){
            query=suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
  
}