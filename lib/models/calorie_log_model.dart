import 'dart:core';

class CalorieLog {
  int? id;
  late int amount;
  DateTime? time;

  CalorieLog({
    required this.amount,
  });

  CalorieLog.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    amount = map['amount'];
    time = DateTime.parse(map['time']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'amount': amount,
    };
    if (id != null) {
      map['id'] = id;
    }
    if (time != null) {
      map['time'] = time!.toIso8601String();
    }
    return map;
  }

  @override
  String toString() {
    return 'CalorieLog{id: $id, amount: $amount cal, time: $time}';
  }
}
