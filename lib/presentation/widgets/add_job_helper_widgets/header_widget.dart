import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
Widget sectionHeader(IconData icon, String title) {
  return Builder(
    builder: (context) => Padding(
      padding: EdgeInsets.only(top: 6, bottom: 6),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: AppColor.blue),
              SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: AppColor.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: Theme.of(context).platform == TargetPlatform.iOS ? 20 : 18,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}