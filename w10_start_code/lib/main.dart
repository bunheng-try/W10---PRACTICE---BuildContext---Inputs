import 'package:flutter/material.dart';

import '../../ui/expenses/expenses_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpensesScreen(),
    ),
  );
}
