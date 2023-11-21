import 'package:flutter/material.dart';

import '../config/colorpalette.dart';
import '../config/font/font.dart';

class CustomSearchBar extends StatelessWidget {
final TextEditingController controller;
ValueChanged<String>? onChanged;

  CustomSearchBar({required this.controller,this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: RobotoFonts.regular(color: ColorPalette.hintTestColor.withOpacity(0.8),fontSize: 16),
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: Icon(Icons.search_rounded),
        prefixIconColor: ColorPalette.hintTestColor.withOpacity(0.3),
        focusedBorder:  const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 3, color: ColorPalette.primaryColor),
        ),
        errorBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 3, color: Colors.redAccent),
        ),
        contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
        border: InputBorder.none,
        hintStyle: RobotoFonts.regular(color: ColorPalette.hintTestColor.withOpacity(0.3),fontSize: 16),
        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 3, color: ColorPalette.hintTestColor.withOpacity(0.2)),
        ),
      ),
    );
  }
}
