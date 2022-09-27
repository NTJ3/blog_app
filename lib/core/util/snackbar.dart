import 'package:flutter/material.dart';

showToast(String message, BuildContext context, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          '${message}',
          textAlign: TextAlign.left,
        ),
      ),
      duration: Duration(milliseconds: 2000),
      backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
    ),
  );
}
