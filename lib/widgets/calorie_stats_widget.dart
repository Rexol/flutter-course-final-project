import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/providers/calorie_log_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CalorieStats extends StatefulWidget {
  const CalorieStats({super.key});

  @override
  State<CalorieStats> createState() => _CalorieStatsState();
}

class _CalorieStatsState extends State<CalorieStats> {
  final provider = CalorieLogProvider();
  int consumedToday = 0;
  int daily = 0;

  @override
  void initState() {
    _getLog();
    _getDaily();
    super.initState();
  }

  Future _getLog() async {
    await provider.open();
    final log = await provider.getDayHistory();
    int consumed = 0;
    for (var element in log) {
      consumed += element.amount;
    }
    setState(() {
      consumedToday = consumed;
    });
  }

  Future _getDaily() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.email);
    final data = await userDoc.get();
    setState(() {
      daily = data['calories'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(28),
        width: 500,
        child: Column(
          children: [
            _eatenToday(),
            _dailyNorm(),
            _remaining(),
          ],
        ),
      ),
    );
  }

  Widget _remaining() {
    return Column(
      children: [
        Text(
          'Remaining:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          '${daily > consumedToday ? daily - consumedToday : 0} cal',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _eatenToday() {
    return Column(
      children: [
        Text('Calories consumed today: $consumedToday'),
      ],
    );
  }

  Widget _dailyNorm() {
    return Column(
      children: [
        Text('Daily amount: $daily'),
      ],
    );
  }
}
