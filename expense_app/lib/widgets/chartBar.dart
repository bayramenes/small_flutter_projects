import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final double spendingAmount;
  final double spendingTotal;
  final String label;
  double get getPercentage {
    double result = spendingAmount / spendingTotal;
    if (spendingTotal == 0) {
      result = 0.0001;
    } else if (result > 1) {
      result = 1;
    }
    return result;
  }

  ChartBar(
      {required this.spendingAmount,
      required this.spendingTotal,
      required this.label});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            Container(
                height: constraints.maxHeight * 0.15,
                child: FittedBox(
                    child: Text('\$${spendingAmount.toStringAsFixed(2)}'))),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  FractionallySizedBox(
                      heightFactor: getPercentage,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                      ))
                ],
              ),
              height: constraints.maxHeight * 0.6,
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            SizedBox(height: constraints.maxHeight * 0.15, child: Text(label))
            // Text(tx["day"] as String)
          ],
        );
      },
    );
  }
}
