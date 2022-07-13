import 'package:flutter/material.dart';
import 'package:recipe_app/providers/category_provider.dart';
import 'package:recipe_app/providers/search_provider.dart';
import 'package:recipe_app/providers/theme_provider.dart';
import 'package:recipe_app/view/explore.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/view/theme.dart';

import 'models/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String currentTheme = await LocalStorage.getTheme() ?? "light";
  runApp( MyApp(theme: currentTheme));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.theme}) : super(key: key);

  final String theme;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryProvider>(
            create: (context) => CategoryProvider()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(theme)),
        ChangeNotifierProvider<SearchProvider>(
            create: (context) => SearchProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            themeMode: themeProvider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            home: Explore(),
          );
        },
      ),
    );
  }
}
