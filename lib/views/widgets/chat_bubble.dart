import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble(
      {super.key, required this.isCurrentUser, required this.message});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    // Dynamically set the bubble color based on the theme mode
    Color backgroundColor = isCurrentUser
        ? (theme.brightness == Brightness.dark
            ? Colors.green.shade600
            : Colors.green.shade500)
        : (theme.brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade200);

    Color textColor = isCurrentUser
        ? Colors.white
        : (theme.brightness == Brightness.dark ? Colors.white : Colors.black);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 2.5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
