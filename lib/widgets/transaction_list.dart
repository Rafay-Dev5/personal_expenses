import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: ((context, constraints) {
            return Column(
              children: <Widget>[
                Text("No transactions added yet!",
                    style: Theme.of(context).appBarTheme.titleTextStyle),
                Container(
                    height: constraints.maxHeight * 0.6,
                    margin: const EdgeInsets.all(10),
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover))
              ],
            );
          }))
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: ((context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: FittedBox(
                          child: Text(
                        "${transactions[index].amount.toStringAsFixed(2)}\$",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.button!.color),
                      )),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                  subtitle:
                      Text(DateFormat.yMMMd().format(transactions[index].date)),
                  trailing: MediaQuery.of(context).size.width > 300
                      ? TextButton.icon(
                          style: TextButton.styleFrom(
                              primary: Theme.of(context).errorColor),
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete"),
                          onPressed: () => deleteTx(transactions[index].id))
                      : IconButton(
                          onPressed: () => deleteTx(transactions[index].id),
                          icon: const Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                        ),
                ),
              );
            }));
  }
}

// Card(
//                   child: Row(
//                     children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 15),
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 width: 2)),
//                         padding: const EdgeInsets.all(10),
//                         child: Text(
//                           '${transactions[index].amount.toStringAsFixed(2)}\$',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20,
//                               color: Theme.of(context).colorScheme.primary),
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             transactions[index].title,
//                             style:
//                                 Theme.of(context).appBarTheme.toolbarTextStyle,
//                           ),
//                           Text(
//                               DateFormat.yMMMEd()
//                                   .format(transactions[index].date),
//                               style: const TextStyle(color: Colors.grey)),
//                         ],
//                       )
//                     ],
//                   ),
//                 );
