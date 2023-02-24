import 'package:final_project/widgets/calculator.dart';
import 'package:final_project/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      // drawer: const SideNavigationDrawer(),
      body: Container(
        padding: const EdgeInsets.all(28),
        child: const Caloriemeter(),
      ),
    );
  }
}
