import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addHandler;
  NewTransaction({required this.addHandler});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? _selectedTime;

  void _showDialog({required String alertTitle, required String alertContent}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(alertTitle),
            content: Text(alertContent),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("close"))
            ],
          );
        });
  }

  void startDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((DateTime? _pickedDate) {
      setState(() {
        _selectedTime = _pickedDate!;
      });
    });
  }

  void onSubmit() {
    final title = titleController.text;
    final amountInString = amountController.text;
    if (title.isEmpty || amountInString.isEmpty) {
      // to check if the user left any field empty then prompt them
      _showDialog(
          alertTitle: "Empy fields",
          alertContent: "Please enter all the fields");
    } else {
      dynamic amount;
      // to check if the user entered a valid number if not then it will prompt the user to do so
      try {
        amount = double.parse(amountController.text);
        // if the number isn't valid
        if (amount <= 0) {
          // if the user entered a number that is less than 0 then propt them with a message
          _showDialog(
              alertTitle: "Value error",
              alertContent: "Please enter the amount correctly !!");
        } else if (_selectedTime == null) {
          // if the user didn't pick a date
          _showDialog(
              alertTitle: "Date Error", alertContent: "No date was chosen !!");
        }
      } on FormatException {
        // if the user provided non numerical value
        _showDialog(
            alertTitle: "Value error",
            alertContent: "Please enter the amount correctly !!");
      }
      widget.addHandler(title: title, amount: amount, date: _selectedTime);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        TextField(
          decoration: const InputDecoration(labelText: "Title"),
          controller: titleController,
        ),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Amount"),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(children: [
            Expanded(
                // if the selected time is null which means the user didn't pick a date yet
                child: _selectedTime == null
                    ? const Text('no date chosen!')
                    //else render the picked date
                    : Text(DateFormat.yMMMEd().format(_selectedTime!))),
            TextButton(
              onPressed: startDatePicker,
              child: const Text("Choose a date"),
            )
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
            onPressed: () => onSubmit(),
            child: const Text(
              "Add Transaction",
            ),
          ),
        )
      ]),
    );
  }
}
