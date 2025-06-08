import 'package:eco_explorer/constants/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/theme.dart';

class TextInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int i;
  final IconData? prefixIcon;
  const TextInputField(
      {super.key, required this.label, required this.hint, required this.controller, required this.i, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Themes.textboxLabel),
      decoration: InputDecoration(
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Themes.cardText) : null,
        labelText: label,
        hintText: hint,
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
      ),
      obscureText: (i==2) ?true:false,
    );
  }
}
