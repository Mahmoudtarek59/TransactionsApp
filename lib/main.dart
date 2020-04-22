import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transactionapp/widgets/chart.dart';
import 'package:transactionapp/widgets/new_transaction.dart';
import 'package:transactionapp/widgets/transactions_list.dart';
import 'code/transaction.dart';
import 'package:intl/intl.dart';

void main() {
//  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations([//to prevent landscape mode
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown,
//  ]);
  runApp(new MaterialApp(
    home: MyApp(),
    title: "Personal Expenses",
    theme: ThemeData(
      primarySwatch: Colors.purple,
      fontFamily: 'Pacifico',
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  final List<Transaction> transactions = [
//    Transaction(
//        id: "T1", title: "New Shoes", amount: 230.0, date: DateTime.now()),
//    Transaction(id: "T2", title: "Tshirt", amount: 150.0, date: DateTime.now()),
  ];


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {//check state if canceled or dispose or create
    print("###################### $state");
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return transactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime dateTime) {
    final newTX = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: dateTime,
    );
    setState(() {
      transactions.add(newTX);
    });
  }

  void _deleteTransaction(int index) {
    setState(() {
      transactions.removeAt(index);
    });
  }

  void _startAddNewTransactionInASheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(
              addTransaction: _addNewTransaction,
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = (MediaQuery.of(context).orientation ==
        Orientation.landscape); //to check is landscape or not
    final appBar = AppBar(
      title: Text("Personal Expenses"),
      actions: [
        IconButton(
            icon: Icon(Icons.add), onPressed: _startAddNewTransactionInASheet),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
//        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: isLandscape
              ? _landscape(appBar, context)
              : _portrat(appBar, context),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS?Container():FloatingActionButton(
        onPressed: _startAddNewTransactionInASheet,
        child: Icon(Icons.add),
      ),
    );
  }

  _landscape(AppBar appBar, context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch.adaptive(//for Change switch in IOS
            activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) => setState(() => _showChart = val)),
        ],
      ),
      _showChart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          : Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  .7,
              child: TransactionsList(
                transaction: transactions,
                deleteTransaction: _deleteTransaction,
              ),
            ),
    ];
  }

  _portrat(AppBar appBar, context) {
    return [
      Container(
          height: (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            .7,
        child: TransactionsList(
          transaction: transactions,
          deleteTransaction: _deleteTransaction,
        ),
      ),
    ];
  }
}
