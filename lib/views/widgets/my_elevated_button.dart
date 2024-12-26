import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const MyElevatedButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    double screenWidth = MediaQuery.sizeOf(context).width;
    var theme = Theme.of(context).colorScheme;
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(screenWidth, screenHeight * 0.07),
          backgroundColor: theme.secondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            // side: const BorderSide(width: 1),
          ),
        ),
        onPressed: onPressed,
        child: Text(text));
  }
}
