import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;

  const MealsScreen({super.key, required this.category});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final ApiService api = ApiService();
  String search = "";
  List<Meal> originalMeals = [];
  List<Meal> filteredMeals = [];

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  void _loadMeals() async {
    originalMeals = await api.fetchMealsByCategory(widget.category);
    setState(() => filteredMeals = originalMeals);
  }

  void _searchMeals(String query) async {
    if (query.isEmpty) {
      setState(() => filteredMeals = originalMeals);
    } else {
      filteredMeals = await api.searchMeals(query);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchMeals,
              decoration: const InputDecoration(
                hintText: "Search meals...",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.8),
              itemCount: filteredMeals.length,
              itemBuilder: (context, index) {
                final meal = filteredMeals[index];
                return MealCard(
                  meal: meal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDetailScreen(id: meal.id),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
