import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chartBar.dart';

class Chart extends StatelessWidget {
  final _recentTransactions;
  Chart(this._recentTransactions);
  double get getTotalSpent {
    double totalSpent = 0.0;
    for (int i = 0; i < _recentTransactions.length; i++) {
      totalSpent += _recentTransactions[i].amount;
    }

    return totalSpent;
  }

  List<Map<String, Object>> get _groupedTransactions {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));
        double totalExpense = 0.0;
        for (int i = 0; i < _recentTransactions.length; i++) {
          if (_recentTransactions[i].date.day == weekDay.day &&
              _recentTransactions[i].date.month == weekDay.month &&
              _recentTransactions[i].date.year == weekDay.year) {
            totalExpense += _recentTransactions[i].amount;
          }
        }
        return {"day": DateFormat.E().format(weekDay), "amount": totalExpense};
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...(_groupedTransactions).map((tx) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    spendingAmount: tx['amount'] as double,
                    spendingTotal: getTotalSpent,
                    label: tx['day'] as String),
              );
            })
          ],
        ),
      ),
    );
  }
}
