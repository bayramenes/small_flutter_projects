import 'dart:io';

import 'package:flutter/material.dart';

import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() => runApp(myapplication());

class myapplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "expense tracker",
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(fontFamily: 'OpenSans', fontSize: 20),
          ),
        ),
        home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<transaction> _userTransactions = [];
  List<transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(
      {required String title, required double amount, required DateTime date}) {
    dynamic prevId;
    if (_userTransactions.isEmpty) {
      prevId = 0;
    } else {
      prevId = _userTransactions[_userTransactions.length - 1].id;
    }
    setState(() {
      _userTransactions.add(transaction(
          id: prevId + 1, title: title, amount: amount, date: date));
    });
  }

  void startANewTrancastion(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: NewTransaction(addHandler: _addTransaction));
        });
  }

  void deleteTransaction(int index) {
    setState(() {
      _userTransactions.removeAt(index);
    });
  }

  bool _showChartLandScape = false;
  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final AppBar _appBar = AppBar(
      actions: [
        IconButton(
            onPressed: () => startANewTrancastion(context),
            icon: const Icon(Icons.add))
      ],
      title: const Text("Expense tracker"),
      centerTitle: true,
    );
    final _txList = Container(
      padding: const EdgeInsets.all(8),
      height: (MediaQuery.of(context).size.height -
              _appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(
        transactions: _userTransactions,
        deleteHandler: deleteTransaction,
      ),
    );
    return Scaffold(
      appBar: _appBar,
      body: SingleChildScrollView(
          child: isLandscape
              ? Column(children: [
                  Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _showChartLandScape,
                      onChanged: (value) {
                        setState(() {
                          _showChartLandScape = value;
                        });
                      }),
                  _showChartLandScape
                      ? SizedBox(
                          height: (MediaQuery.of(context).size.height -
                                  _appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.7,
                          child: Chart(_recentTransactions))
                      : _txList
                ])
              : Column(
                  children: [
                    SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                _appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.3,
                        child: Chart(_recentTransactions)),
                    _txList
                  ],
                )),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              onPressed: () => startANewTrancastion(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
