import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _key = 'favorite_meals';

  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<bool> isFavorite(String mealId) async {
    final favorites = await getFavorites();
    return favorites.contains(mealId);
  }

  Future<void> addFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    if (!favorites.contains(mealId)) {
      favorites.add(mealId);
      await prefs.setStringList(_key, favorites);
    }
  }

  Future<void> removeFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    favorites.remove(mealId);
    await prefs.setStringList(_key, favorites);
  }

  Future<void> toggleFavorite(String mealId) async {
    if (await isFavorite(mealId)) {
      await removeFavorite(mealId);
    } else {
      await addFavorite(mealId);
    }
  }
}