import 'package:flutter/material.dart';

class BotaoPadrao extends StatelessWidget {
  final String label;
  final IconData icone;
  final VoidCallback onPressed;
  const BotaoPadrao(
      {super.key,
      required this.label,
      required this.icone,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(label),
      icon: Icon(icone),
    );
  }
}
