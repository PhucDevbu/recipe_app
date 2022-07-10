import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/providers/category_provider.dart';
import 'package:recipe_app/view/explore.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<CategoryProvider>(create: (context)=>CategoryProvider()),


    ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.montagaTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        home:Explore(),
      ),
    );

  }
}

