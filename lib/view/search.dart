import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/search_provider.dart';
import 'package:recipe_app/view/shared.dart';

class Search extends StatefulWidget {
  final String query;
  const Search({Key? key,required this.query}) : super(key: key);
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState  extends State<Search> {

  @override
  initState(){
    Provider.of<SearchProvider>(context, listen: false).fetchSearch(widget.query);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          child: Consumer<SearchProvider>(
            builder: (context,searchProvider,child){
              return  ListView.builder(
              itemCount: searchProvider.searchMeal.length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
              return buildFavorites(searchProvider.searchMeal[index],context);
              });
            },
          )

        ,
        ),
      ),

    );
  }
}
