import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  bool obscureText;

  MyTextField(
      {super.key,
      required this.hintText,
      required this.obscureText,
      this.focusNode,
      required this.controller});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool showPass = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        suffixIcon: (widget.hintText == "Password" ||
                widget.hintText == "Confirm Password")
            ? IconButton(
                icon: widget.obscureText
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    widget.obscureText =
                        !widget.obscureText; // Toggle obscureText
                  });
                },
              )
            : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: theme.primary),
        fillColor: theme.secondary,
        filled: true,
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: theme.tertiary)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: theme.primary)),
      ),
    );
  }
}
