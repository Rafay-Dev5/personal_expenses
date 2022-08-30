import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import './widgets/transaction_list.dart';
import '../widgets/new_transactions.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Personal Expenses',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.amber),
            fontFamily: "Quicksand",
            textTheme: ThemeData.light().textTheme.copyWith(
                headlineLarge: const TextStyle(
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                button: const TextStyle(color: Colors.white)),
            appBarTheme: AppBarTheme(
                toolbarTextStyle: ThemeData.light()
                    .textTheme
                    .copyWith(
                        titleLarge: const TextStyle(
                            fontFamily: "OpenSans", fontSize: 18))
                    .bodyText2,
                titleTextStyle: ThemeData.light()
                    .textTheme
                    .copyWith(
                        titleLarge: const TextStyle(
                            fontFamily: "OpenSans", fontSize: 20))
                    .headline6)),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String? titleInput;

  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', title: "New Shoes", amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: "t2", title: "Old Shoes", amount: 39.99, date: DateTime.now()),
  ];

  void _addNewTransaction(String title, double amount, DateTime selectedDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: selectedDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context, builder: (_) => NewTransaction(_addNewTransaction));
  }

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.date
          .isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final iosAppBar = CupertinoNavigationBar(
      middle: const Text(
        "Personal Expenses",
        style: TextStyle(fontFamily: "Open Sans"),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () => _startAddNewTransaction(context),
            child: const Icon(CupertinoIcons.add),
          )
        ],
      ),
    );
    final appBar = AppBar(
      title: const Text(
        "Personal Expenses",
        style: TextStyle(fontFamily: "Open Sans"),
      ),
      actions: <Widget>[
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: const Icon(Icons.add))
      ],
    );

    final txListWidget = SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Show Chart",
                    style: Theme.of(context).appBarTheme.titleTextStyle),
                Switch.adaptive(
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    })
              ],
            ),
          if (!isLandscape)
            SizedBox(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions)),
          if (!isLandscape) txListWidget,
          if (isLandscape)
            _showChart
                ? SizedBox(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : txListWidget
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(navigationBar: iosAppBar, child: pageBody)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransaction(context),
                    child: const Icon(Icons.add),
                  ),
          );
  }
}
