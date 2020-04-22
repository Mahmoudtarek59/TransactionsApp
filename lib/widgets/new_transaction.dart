import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;
  NewTransaction({this.addTransaction});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime _SelecteDate;

  void _submitData() {
    if(amountController.text.isEmpty)return;
    final enteredTitel = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    if (enteredTitel.isEmpty || enteredAmount <= 0||_SelecteDate==null) {
      return;
    }
    widget.addTransaction(
      enteredTitel,
      enteredAmount,
      _SelecteDate,
    );
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now()).then((value){
          if(value == null) return;
          setState(() {
            _SelecteDate=value;
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom +10
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Text(_SelecteDate==null?"NO Date Chosen!":'Picked Date: ${DateFormat.yMd().format(_SelecteDate)}'),
                    Spacer(),
                    FlatButton(
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        _presentDatePicker();
                      },
                    ),
                  ],
                ),
              ),
              RaisedButton(
                  onPressed: _submitData,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("Add Transaction"))
            ],
          ),
        ),
      ),
    );
  }
}
