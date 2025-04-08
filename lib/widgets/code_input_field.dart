import 'package:flutter/material.dart';

class CodeInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final Function(String)? onChanged;

  const CodeInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            nextFocusNode!.requestFocus();
          }
          onChanged?.call(value);
        },
      ),
    );
  }
} 