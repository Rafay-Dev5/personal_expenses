import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final VoidCallback handler;

  AdaptiveButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: handler,
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ))
        : TextButton(
            style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary),
            onPressed: handler,
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
  }
}
