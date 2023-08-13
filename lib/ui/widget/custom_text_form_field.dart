import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final FormFieldValidator<String>? validator; // validator 추가

  CustomTextFormField({
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.validator, // validator 초기화
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => controller.text = value!,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelStyle: const TextStyle(
          fontSize: 11,
        ),
        labelText: labelText,
      ),
      validator: validator,
    );
  }
}
