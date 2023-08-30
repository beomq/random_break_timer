import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    num deviceWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        backgroundColor: const Color(0xffa8c7fa),
        elevation: 2.0,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Text(
          text,
          style: TextStyle(
            fontSize: deviceWidth < 380 ? 9 : 14,
            color: const Color(0xff072f71),
          ),
        ),
      ),
    );
  }
}
