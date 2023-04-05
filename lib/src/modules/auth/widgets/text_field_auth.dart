import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldAuth extends StatelessWidget {
  TextEditingController? controller;
  Function()? onTap;
  Function(String)? onChanged;
  bool isObscureText;
  String label;
  IconData icon;

  TextFieldAuth({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.onTap,
    this.onChanged,
    this.isObscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      obscureText: isObscureText,
      onTap: onTap,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      style: theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.primaryContainer,
      ),
      cursorColor: theme.colorScheme.onSecondary,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.primaryColor,
        hintText: label,
        hintStyle: theme.textTheme.bodyLarge!.copyWith(
          color: theme.colorScheme.primaryContainer,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: Icon(icon),
        ),
        prefixIconColor: theme.colorScheme.primaryContainer,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
