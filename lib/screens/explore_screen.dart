import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      appBar: AppBar(title: const Text("Cari Buku"), centerTitle: true),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: const [
          CategoryCard(name: "Biografi"),
          CategoryCard(name: "Fiksi"),
          CategoryCard(name: "Academyc"),
          CategoryCard(name: "Non Fiksi"),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;

  const CategoryCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Text(name, textAlign: TextAlign.center)),
    );
  }
}
