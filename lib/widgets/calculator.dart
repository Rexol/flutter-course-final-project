import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _WeightInput extends StatelessWidget {
  @override
  const _WeightInput({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
}

enum Genders { male, female }

class _GenderInput extends StatelessWidget {
  @override
  const _GenderInput({required this.gender, required this.updateGender});
  final Genders? gender;
  final void Function(Genders?) updateGender;

  @override
  Widget build(BuildContext context) {
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
            groupValue: gender,
            onChanged: updateGender,
          ),
          RadioListTile(
            title: const Text("Female"),
            value: Genders.female,
            groupValue: gender,
            onChanged: updateGender,
          ),
        ],
      ),
    );
  }
}

class _IntensityDropdown extends StatelessWidget {
  final double? intensity;
  final void Function(double?) updateIntensity;
  final Map intensities = const <String, double?>{
    // "Select": 0.0,
    "Light": 1.3,
    "Usual": 1.5,
    "Moderate": 1.7,
    "Hard": 2.0,
    "Very Hard": 2.2,
  };

  @override
  const _IntensityDropdown(
      {required this.intensity, required this.updateIntensity});

  @override
  Widget build(BuildContext context) {
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
}

class _Calculate extends StatelessWidget {
  final void Function() onPressed;
  final int result;

  @override
  const _Calculate({
    required this.onPressed,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: onPressed,
          child: const Text(
            "Calculate",
          ),
        ),
        Text(
          result.toString(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

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
          _WeightInput(controller: weightController),
          _GenderInput(gender: sex, updateGender: updateSex),
          _IntensityDropdown(
            intensity: intensity,
            updateIntensity: updateIntensity,
          ),
          _Calculate(
            onPressed: valAndCalc,
            result: result,
          ),
        ],
      ),
    );
  }
}
