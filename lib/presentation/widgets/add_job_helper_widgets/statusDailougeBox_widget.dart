import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';

 showStatusDialog(BuildContext context, String selectedStatus, statuses, onPressed,) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? tempSelectedStatus = selectedStatus;
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text('Select Status'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children:
                      statuses.map((status) {
                        return RadioListTile<String>(
                          title: Text(status),
                          value: status,
                          groupValue: tempSelectedStatus,
                          onChanged: (value) {
                            setState(() {
                              tempSelectedStatus = value;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: onPressed,
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }