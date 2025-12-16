import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  final String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/categories.php"));
    final data = json.decode(response.body)["categories"];

    return List<Category>.from(data.map((e) => Category.fromJson(e)));
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response =
        await http.get(Uri.parse("$baseUrl/filter.php?c=$category"));
    final data = json.decode(response.body)["meals"];
    if (data == null) return [];
    return List<Meal>.from(data.map((e) => Meal.fromJson(e)));
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(Uri.parse("$baseUrl/search.php?s=$query"));
    final data = json.decode(response.body)["meals"];
    if (data == null) return [];
    return List<Meal>.from(data.map((e) => Meal.fromJson(e)));
  }

  Future<MealDetail> fetchMealDetail(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/lookup.php?i=$id"));
    final jsonMeal = json.decode(response.body)["meals"][0];
    return MealDetail.fromJson(jsonMeal);
  }

  Future<MealDetail> fetchRandomMeal() async {
    final response = await http.get(Uri.parse("$baseUrl/random.php"));
    final jsonMeal = json.decode(response.body)["meals"][0];
    return MealDetail.fromJson(jsonMeal);
  }
}
