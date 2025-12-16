import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../widgets/category_card.dart';
import 'meals_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService _api = ApiService();
  final NotificationService _notificationService = NotificationService();
  String _search = "";

  Future<void> _showRandomMeal() async {
    try {
      final meal = await _api.fetchRandomMeal();

      await _notificationService.showInstantNotification(
        'Random Recipe',
        'Check out: ${meal.name}',
      );

      if (mounted) {
        Navigator.pushNamed(context, "/meal", arguments: meal.id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load random meal')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Random Meal',
            onPressed: _showRandomMeal,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search categories...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),

          Expanded(
            child: FutureBuilder(
              future: _api.fetchCategories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final categories = snapshot.data!
                    .where((c) => c.name.toLowerCase().contains(_search.toLowerCase()))
                    .toList();

                if (categories.isEmpty) {
                  return const Center(
                    child: Text('No categories found'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      category: categories[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MealsScreen(
                              category: categories[index].name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}