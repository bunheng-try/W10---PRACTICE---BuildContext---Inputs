import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.food;
  DateTime? _selectedDate;

  @override
  void dispose(){
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }
  
  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  String _getDateText() {
    if (_selectedDate == null) {
      return "No date selected";
    }
    return DateFormat('EEE, MMM dd').format(_selectedDate!);
  }

  void _showErrorDialog(String messege){
    showDialog(context: context, 
      builder: (ctx) => AlertDialog(
        title: Text("Invalid Input"),
        content: Text(messege),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("okay"))
        ],
      ),
    );
  }
  void onCreate() {
    String title = _titleController.text;
    double amount = 0;
    Category category = _selectedCategory;
    DateTime date = _selectedDate ?? DateTime.now();
    
    if (title.isEmpty){
      return _showErrorDialog("Required!!");
    }
    
    final enteredAmount = double.tryParse(_amountController.text);
    if (enteredAmount == null || enteredAmount <= 0) {
      return _showErrorDialog("Please enter a valid amount");
    }

    amount = enteredAmount;
    Expense newExpense = Expense(
      title: title,
      amount: amount,
      date: date,
      category: category);

    Navigator.pop(context, newExpense);
  }
  
  void onCancel() {
   
    // Close the modal
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(label: Text("Title")),
            maxLength: 50,
          ),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            controller: _amountController,
            decoration: InputDecoration(
              label: Text("Amount"),
              prefix: Text('\$ '),
            ),
            maxLength: 50,
          ),
          SizedBox(height: 16),
          DropdownButton<Category>(
            value: _selectedCategory,
            isExpanded: true,
            items: Category.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (Category? newValue) {
              setState(() {
                _selectedCategory = newValue ?? Category.food;
              });
            },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(_getDateText()),
              ),
              IconButton(
                onPressed: _showDatePicker,
                icon: Icon(Icons.calendar_today),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(onPressed: onCancel, child: Text("Cancel")),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(onPressed: onCreate, child: Text("Save Expense")),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
