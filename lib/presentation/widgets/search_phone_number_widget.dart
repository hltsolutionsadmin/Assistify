import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget BuildSearchNumberField({
  required BuildContext context,
  required TextEditingController searchController,
  required Function(String) onChanged,
  bool enabled = true,
  bool readOnly = false,
    Icon? prefixIcon,

}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
    child: Focus(
      autofocus: false,
      child: Builder(
        builder: (innerContext) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: TextField(
          
              controller: searchController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              
              autofocus: false,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                        prefixIcon: prefixIcon,

                hintText: 'Mobile Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: AppColor.gray),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: AppColor.gray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: AppColor.blue, width: 2),
                ),
                filled: true,
                fillColor: AppColor.white,
                isDense: true,
              ),
              onChanged: onChanged,
              enabled: enabled,
              readOnly: readOnly,
            ),
          );
        },
      ),
    ),
  );
}
