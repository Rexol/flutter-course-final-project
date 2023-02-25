import 'package:final_project/widgets/calorie_stats_widget.dart';
import 'package:final_project/widgets/navigation_drawer.dart';
import 'package:final_project/widgets/weather_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const SideNavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const Text(
              'Signed In as',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              user.email!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.all(10),
              child: WeatherWidget(),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: CalorieStats(),
            ),
          ],
        ),
      ),
    );
  }
}
