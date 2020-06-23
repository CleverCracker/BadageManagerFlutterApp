import 'package:FLUTTER_COMPLETE_GUIDE/models/transaction.dart';
import 'package:FLUTTER_COMPLETE_GUIDE/widgets/chart.dart';
import 'package:FLUTTER_COMPLETE_GUIDE/widgets/new_transaction.dart';
import 'package:FLUTTER_COMPLETE_GUIDE/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'Opensand',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'Opensand',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                button: TextStyle(
                  color: Colors.white,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  final List<Transaction> _userTranactions = [
    Transaction(
      id: 't1',
      title: "New Shose",
      amount: 69.99,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: 't2',
      title: "Weekly Grocery",
      amount: 26.99,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 't3',
      title: "Nike Shose",
      amount: 169.99,
      date: DateTime.now().subtract(Duration(days: 4)),
    ),
    Transaction(
      id: 't4',
      title: "Bablo Grocery",
      amount: 16.99,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: 't5',
      title: "Milk",
      amount: 6.99,
      date: DateTime.now().subtract(Duration(days: 6)),
    ),
    Transaction(
      id: 't6',
      title: "New Shose",
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't7',
      title: "Weekly Grocery",
      amount: 16.99,
      date: DateTime.now(),
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTranactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
        title: title,
        amount: amount,
        date: chosenDate,
        id: DateTime.now().toString());
    setState(() {
      _userTranactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTranactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  /* Using Gesture Detector */
  // void _startAddNewTransaction(BuildContext ctx) {
  //   showModalBottomSheet(
  //       context: ctx,
  //       builder: (_) {
  //         return GestureDetector(
  //           child: NewTransaction(_addNewTransaction),
  //           onTap: () {},
  //           behavior: HitTestBehavior.opaque,
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Show Chart"),
                Switch(
                  value: true,
                  onChanged: (val) {},
                )
              ],
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.3,
              child: Chart(_recentTransactions),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: TransactionList(_userTranactions, _deleteTransaction),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
