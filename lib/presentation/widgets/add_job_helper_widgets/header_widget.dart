import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/cupertino.dart';

Widget sectionHeader(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.only(top: 6, bottom: 6, left: 4),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.blue),
          borderRadius: BorderRadius.circular(24),
        ),
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColor.blue),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: AppColor.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }