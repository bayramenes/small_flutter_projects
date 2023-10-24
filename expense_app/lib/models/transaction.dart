import 'package:flutter/foundation.dart';

class transaction {
  final int id;
  final String title;
  final double amount;
  final DateTime date;
  transaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date});
}
