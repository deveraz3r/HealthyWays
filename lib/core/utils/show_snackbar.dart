import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String content) {
  final snackBar = SnackBar(
    content: Text(content),
    duration: const Duration(seconds: 2),
    // backgroundColor: Colors.red,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);

  debugPrint("Snackbar: $content");
}
