import 'package:flutter/material.dart';

class CustomRecordedContainer extends StatelessWidget {
  final IconData iconData;
  final String resultText;
  final String detailText;

  const CustomRecordedContainer(
      {Key? key,
      required this.iconData,
      required this.resultText,
      required this.detailText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          (iconData),
        ),
        Text(resultText),
        Text(detailText),
      ],
    );
  }
}
