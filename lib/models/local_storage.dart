import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage{
  static const storage = FlutterSecureStorage();
  static saveTheme(String theme) async{
    await storage.write(key: "theme", value: theme);
  }

  static Future<String?> getTheme() async{
    String? currentTheme = await storage.read(key: "theme");
    return currentTheme;
  }

  static addFavorite(String id)async{
    List<String> favorites =[];
    favorites.add(id);
    final value = jsonEncode(favorites);
    await storage.write(key: "favorites", value: value);
  }

  static removeFavorite(String id)async{
    final value = await storage.read(key: "favorites")??"";
    List<String> favorites = jsonDecode(value);
    favorites.remove(id);
    await storage.write(key: "favorites", value: value);
  }

  static Future<List<String>> fetchFavorites() async {
    final value = await storage.read(key: "favorites")??"";
    List<String> favorites = jsonDecode(value);
    return favorites;
  }
}