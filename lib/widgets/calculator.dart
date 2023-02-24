import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Genders { male, female }

class Caloriemeter extends StatefulWidget {
  @override
  const Caloriemeter({super.key});

  @override
  State createState() => _CaloriemeterState();
}

class _CaloriemeterState extends State<Caloriemeter> {
  final _formKey = GlobalKey<FormState>();
  final weightController = TextEditingController();
  Genders sex = Genders.male;
  double? intensity;
  int result = 0;

  @override
  void initState() {
    _getResultFromDb();
    super.initState();
  }

  void updateResult(int newResult) {
    setState(() {
      result = newResult;
    });
  }

  void updateIntensity(double? newIntensity) {
    setState(() {
      intensity = newIntensity ?? 0.0;
    });
  }

  void updateSex(Genders? newSex) {
    setState(() {
      sex = newSex ?? Genders.male;
    });
  }

  void valAndCalc() {
    if (_formKey.currentState!.validate()) {
      int newres;
      if (sex == Genders.male) {
        newres = ((879 + 10.2 * int.parse(weightController.text)) * intensity!)
            .toInt();
      } else {
        newres = ((795 + 7.18 * int.parse(weightController.text)) * intensity!)
            .toInt();
      }
      // print(newres);
      updateResult(newres);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _weightInput(),
          _genderInput(),
          _intensityDropdown(),
          _calculate(),
          _saveIntoDb(),
        ],
      ),
    );
  }

  Future _saveToDb() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.email);
    final data = {'calories': result};
    await userDoc.set(data);
  }

  Future _getResultFromDb() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.email);
    final data = await userDoc.get();
    updateResult(data['calories'] ?? 0);
  }

  Widget _saveIntoDb() {
    return ElevatedButton(
      onPressed: _saveToDb,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
      ),
      child: const Text(
        'Remember',
        style: TextStyle(color: Colors.white, fontSize: 28),
      ),
    );
  }

  Widget _calculate() {
    return Column(
      children: [
        OutlinedButton(
          onPressed: valAndCalc,
          child: const Text(
            "Calculate",
            style: TextStyle(fontSize: 28),
          ),
        ),
        Text(
          result.toString(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _intensityDropdown() {
    const Map intensities = <String, double?>{
      "Light": 1.3,
      "Usual": 1.5,
      "Moderate": 1.7,
      "Hard": 2.0,
      "Very Hard": 2.2,
    };
    return DropdownButtonFormField<double>(
      items: intensities.entries.map((entry) {
        return DropdownMenuItem<double>(
            value: entry.value, child: Text(entry.key));
      }).toList(),
      value: intensity,
      onChanged: updateIntensity,
      hint: const Text("Select your exersising intensity"),
      validator: (value) {
        if (value == 0 || value == null) {
          return "Select intensity";
        }
        return null;
      },
    );
  }

  Widget _weightInput() {
    return TextFormField(
      controller: weightController,
      maxLines: 1,
      maxLength: 5,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your weight';
        }
        return null;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text("Weight"),
        helperText: "Input your weight in kg",
      ),
    );
  }

  Widget _genderInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          Text(
            "Select your biological sex",
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.left,
          ),
          RadioListTile(
            title: const Text("Male"),
            value: Genders.male,
            groupValue: sex,
            onChanged: updateSex,
          ),
          RadioListTile(
            title: const Text("Female"),
            value: Genders.female,
            groupValue: sex,
            onChanged: updateSex,
          ),
        ],
      ),
    );
  }
}
