import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String hintText;
  final String? selectedValue;
  final VoidCallback onTap;

  const CustomDropdownField({super.key, 
    required this.hintText,
    this.selectedValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.gray),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedValue ?? hintText),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}