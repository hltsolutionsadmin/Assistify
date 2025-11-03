import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';

Widget buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: AppColor.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value),
      ],
    );
  }

   Widget buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Icon(Icons.circle, size: 6),
        ),
        SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }