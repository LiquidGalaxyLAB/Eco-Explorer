import 'package:eco_explorer/constants/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/theme.dart';

class TextInputField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int i;
  final IconData? prefixIcon;
  const TextInputField(
      {super.key, required this.label, required this.hint, required this.controller, required this.i, this.prefixIcon});

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: TextStyle(color: Themes.textboxLabel),
      decoration: InputDecoration(
          prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: Themes.cardText) : null,
          labelText: widget.label,
          hintText: widget.hint,
          labelStyle: Fonts.medium.copyWith(color: Themes.textboxLabel),
          hintStyle: Fonts.medium.copyWith(color: Themes.textboxHint),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.cardRadius(context)*0.5),
            borderSide: BorderSide(color: Themes.textboxOutline,width: Constants.totalHeight(context)/10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.cardRadius(context)*0.5),
            borderSide: BorderSide(color: Themes.textboxOutline),
          ),
          suffixIcon: (widget.i==2) ? IconButton(
            icon: Icon(passwordVisible
                ? Icons.visibility
                : Icons.visibility_off, color: Themes.cardText),
            onPressed: () {
              setState(
                    () {
                  passwordVisible = !passwordVisible;
                },
              );
            },
          ):null
      ),
      obscureText: (widget.i==2) ?passwordVisible:false,
    );
  }
}