import 'package:flutter/material.dart';

Future showBaseDialog({
  required BuildContext context,
  required String confirmText,
  required Future<void> Function(String first, String second) onPressed,
  String firstField = '',
  String secondField = '',
}) =>
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (_, __, ___) {
        final nameController = TextEditingController(text: firstField);
        final descController = TextEditingController(text: secondField);
        return AlertDialog(
          title: const Text('New note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                onPressed(nameController.text, descController.text);
                Navigator.pop(context);
              },
              child: Text(confirmText),
            )
          ],
        );
      },
    );