import 'package:final_project/widgets/add_calorie_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class LogCaloriesPage extends StatelessWidget {
  const LogCaloriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How much I eat'),
      ),
      // drawer: const SideNavigationDrawer(),
      body: Container(
        padding: const EdgeInsets.all(28),
        child: const CalorieInputWidget(),
      ),
    );
  }
}
