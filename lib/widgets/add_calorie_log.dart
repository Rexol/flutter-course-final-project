import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:final_project/providers/calorie_log_provider.dart';
import 'package:final_project/models/calorie_log_model.dart';

class CalorieInputWidget extends StatefulWidget {
  @override
  const CalorieInputWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CalorieInputWidgetState();
}

class _CalorieInputWidgetState extends State<CalorieInputWidget> {
  final provider = CalorieLogProvider();
  final controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<CalorieLog> log = [];

  @override
  void initState() {
    getLog();
    super.initState();
  }

  Future getLog() async {
    await provider.open();
    List<CalorieLog> saved = await provider.getHistory();
    setState(() {
      log = saved;
    });
  }

  Future add() async {
    if (_formKey.currentState!.validate()) {
      CalorieLog newItem = await provider.insert(
        CalorieLog(amount: int.parse(controller.text)),
      );
      setState(() {
        log.add(newItem);
        controller.clear();
      });
    }
  }

  Future delete(int id) async {
    await provider.delete(id);
    setState(() {
      log = log.where((element) => element.id != id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: Column(
              children: [
                TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Calories'),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.parse(value) <= 0) {
                      return 'Put your positive calories amount here';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                FilledButton(
                  onPressed: add,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: ListView.separated(
              itemCount: log.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${log[index].amount} calories'),
                  subtitle: Text(log[index].time.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => delete(log[index].id!),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ),
      ],
    );
  }
}
