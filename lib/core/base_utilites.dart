import 'package:flutter/material.dart';

class BaseUtilites {
  static Widget commonTextFeild(
      TextInputAction? textInputAction,
      AutovalidateMode? autoValidateMode,
      TextEditingController? textEditingController,
      bool isautoFocus,
      String ValidateMessage,
      TextStyle? style,
      InputDecoration? inputDecoration,
      void Function(String)? method,
      String? Function(String?)? validatemethod,
      bool obscure) {
    return TextFormField(
      onChanged: method,
      textInputAction: textInputAction,
      autovalidateMode: autoValidateMode,
      controller: textEditingController,
      autofocus: isautoFocus,
      validator: validatemethod,
      style: style,
      decoration: inputDecoration,
      obscureText: obscure,
    );
  }
}
