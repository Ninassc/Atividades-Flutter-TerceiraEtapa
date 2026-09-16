import 'package:flutter/material.dart';

class CampoInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const CampoInput({super.key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(
          label,
          style: TextStyle(color: Colors.deepOrange),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 243, 111, 70))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange)),
      ),
    );
  }
}
