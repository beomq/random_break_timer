import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final IconData icon;

  CustomTextFormField({
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.validator,
    required this.icon, // validator 초기화
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 40,
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(labelText),
              TextFormField(
                onSaved: (value) => controller.text = value!,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                ),
                validator: validator,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
