import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
  final String label;
  final String prefix;
  final TextEditingController controller;
  final void Function(String text) onChanged;

  const InputTextWidget(
      {Key? key,
      required this.label,
      required this.prefix,
      required this.controller,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.amber),
            border: const OutlineInputBorder(),
            prefix: Text(prefix)),
        style: const TextStyle(color: Colors.amber, fontSize: 25),
      ),
    );
  }
}
