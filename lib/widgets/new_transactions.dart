import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount! <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
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
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(labelText: "Title"),
                    controller: _titleController,
                    onSubmitted: (_) => _submitData(),
                    // onChanged: (value) {
                    //   titleInput = value;
                    // },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: "Amount"),
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _submitData(),
                    // onChanged: (value) {
                    //   amountInput = value;
                    // },
                  ),
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(_selectedDate == null
                              ? "No Date Chosen!"
                              : "Picked Date: ${DateFormat.yMMMd().format(_selectedDate as DateTime)}"),
                        ),
                        AdaptiveButton("Choose Date", _presentDatePicker)
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: _submitData,
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.primary,
                          textStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.button?.color)),
                      child: const Text("Add Transaction"))
                ])),
      ),
    );
  }
}
