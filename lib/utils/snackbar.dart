import 'package:flutter/material.dart';

showSnackbar({required String content, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
