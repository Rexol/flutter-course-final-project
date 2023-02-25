import 'package:final_project/pages/calculator_page.dart';
import 'package:final_project/pages/home_page.dart';
import 'package:final_project/pages/log_calories_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideNavigationDrawer extends StatelessWidget {
  const SideNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(18, 60, 18, 0),
        child: Wrap(
          runSpacing: 16,
          children: [
            // ListTile(
            //   leading: const Icon(Icons.home_outlined),
            //   title: const Text('Home'),
            //   onTap: () => Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(
            //       builder: (context) => HomePage(),
            //     ),
            //   ),
            // ),
            ListTile(
              leading: const Icon(Icons.calculate_outlined),
              title: const Text('Calculator'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CalculatorPage(),
                  ),
                );
                // .then((value) => updateState());
              },
            ),
            ListTile(
              leading: const Icon(Icons.toc_outlined),
              title: const Text('Log calories'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LogCaloriesPage(),
                  ),
                );
                // .then((value) => updateState());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      );
}
