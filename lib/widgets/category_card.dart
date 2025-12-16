import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Image.network(category.thumbnail, width: 60),
        title: Text(category.name),
        subtitle: Text(category.description, maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
