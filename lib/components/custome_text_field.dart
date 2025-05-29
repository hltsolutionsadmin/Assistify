import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customTextField(
  TextEditingController controller,
  String label, {
  String? errorText,
  required Function(String) onChanged,
  bool obscureText = false,
  bool enabled = true,
  bool readOnly = false,
  Icon? prefixIcon,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: TextFormField(
      inputFormatters: inputFormatters,
      controller: controller,
      onChanged: onChanged,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText ? true : false,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: label,
        labelStyle: TextStyle(color: AppColor.black, fontSize: 14),
        focusColor: AppColor.blue,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.gray),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.gray),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.red, width: 2),
        ),
        errorText: errorText,
      ),
    ),
  );
}
