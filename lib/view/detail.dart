import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipe_app/view/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/meal_detail.dart';
import 'constants.dart';



class Detail extends StatelessWidget {
  int random(min, max) {
    return min + Random().nextInt(max - min);
  }
  final MealDetail mealDetail;
  const Detail({Key? key, required this.mealDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextTitleVariation1(mealDetail.strMeal),
                  buildTextSubTitleVariation1(mealDetail.strCategory),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 310,
              padding: EdgeInsets.only(left: 16),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTextTitleVariation2('Nutritions', false),
                      SizedBox(
                        height: 16,
                      ),
                      buildNutrition(random(150, 300), 'Calories', 'Kcal'),
                      SizedBox(
                        height: 16,
                      ),
                      buildNutrition(random(15, 30), 'Times', 'min'),
                      SizedBox(
                        height: 16,
                      ),
                      buildNutrition(random(2, 4), 'Persons', 'man')
                    ],
                  ),
                  Positioned(
                    right: -100,
                    child: Hero(
                      tag: mealDetail.strMealThumb,
                      child: Container(
                        height: 310,
                        width: 310,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                            image: DecorationImage(
                          image: NetworkImage(mealDetail.strMealThumb),
                          fit: BoxFit.fitHeight,
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextTitleVariation2('Ingredients', false),

                  buildIngredients(mealDetail.strIngredient1,mealDetail.strMeasure1),
                  buildIngredients(mealDetail.strIngredient2,mealDetail.strMeasure2),
                  buildIngredients(mealDetail.strIngredient3,mealDetail.strMeasure3),
                  buildIngredients(mealDetail.strIngredient4,mealDetail.strMeasure4),
                  buildIngredients(mealDetail.strIngredient5,mealDetail.strMeasure5),
                  buildIngredients(mealDetail.strIngredient6,mealDetail.strMeasure6),
                  buildIngredients(mealDetail.strIngredient7,mealDetail.strMeasure7),
                  buildIngredients(mealDetail.strIngredient8,mealDetail.strMeasure8),
                  buildIngredients(mealDetail.strIngredient9,mealDetail.strMeasure9),
                  buildIngredients(mealDetail.strIngredient10,mealDetail.strMeasure10),
                  buildIngredients(mealDetail.strIngredient11,mealDetail.strMeasure11),
                  buildIngredients(mealDetail.strIngredient12,mealDetail.strMeasure12),
                  buildIngredients(mealDetail.strIngredient13,mealDetail.strMeasure13),
                  buildIngredients(mealDetail.strIngredient14,mealDetail.strMeasure14),
                  buildIngredients(mealDetail.strIngredient15,mealDetail.strMeasure15),
                  buildIngredients(mealDetail.strIngredient16,mealDetail.strMeasure16),
                  buildIngredients(mealDetail.strIngredient17,mealDetail.strMeasure17),
                  buildIngredients(mealDetail.strIngredient18,mealDetail.strMeasure18),
                  buildIngredients(mealDetail.strIngredient19,mealDetail.strMeasure19),
                  buildIngredients(mealDetail.strIngredient20,mealDetail.strMeasure20),

                  SizedBox(
                    height: 16,
                  ),
                  buildTextTitleVariation2('Recipe preparation', false),
                  buildTextSubTitleVariation1(mealDetail.strInstructions),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.extended(
              onPressed: _launchUrlWeb,
              backgroundColor: kPrimaryColor,
              icon: Icon(
                Icons.language,
                color: Colors.white,
                size: 32,
              ),
              label: Text(
                'Website',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FloatingActionButton.extended(
              onPressed: _launchUrlVideo,
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 32,
              ),
              label: Text(
                'Watch video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      )

    );
  }
  void _launchUrlVideo() async {
    final Uri _url = Uri.parse(mealDetail.strYoutube);

    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
  void _launchUrlWeb() async {
    final Uri _url = Uri.parse(mealDetail.strSource);

    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  Widget buildNutrition(int value, String title, String subTitle) {
    return Container(
      height: 60,
      width: 150,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [kBoxShadow],
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [kBoxShadow],
            ),
            child: Center(
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
