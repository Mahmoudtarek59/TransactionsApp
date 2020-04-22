import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transactionapp/code/transaction.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTransaction;
  TransactionsList({this.transaction, this.deleteTransaction});

  @override
  Widget build(BuildContext context) {
    return transaction.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Text("No transactions added yet!"),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/zzzz.png",
                  fit: BoxFit.cover,
                  height: constraints.maxHeight * 0.6,
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transaction.length,
            itemBuilder: (builder, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text(
                          "\$${transaction[index].amount.toStringAsFixed(2)}",
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    '${transaction[index].title}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      '${DateFormat.yMMMd().format(transaction[index].date)}'),
                  trailing: MediaQuery.of(context).size.width > 460?
                  FlatButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text("Delete"),
                    textColor: Theme.of(context).errorColor,
                    onPressed: () => deleteTransaction(index),):
                  IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => deleteTransaction(index)),
                ),
              );
            },
          );
  }
}
