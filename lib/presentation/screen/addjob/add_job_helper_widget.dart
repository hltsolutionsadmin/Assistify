import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';

void ShowPaymentDialog({context, paymentMode, onPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? tempPaymentMode = paymentMode;
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text('Select Payment Mode'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children:
                      paymentMode.map((payment) {
                        return RadioListTile<String>(
                          title: Text(payment),
                          value: payment,
                          groupValue: tempPaymentMode,
                          onChanged: (value) {
                            setState(() {
                              tempPaymentMode = value;
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
              child: Text('OK'),
              onPressed: onPressed,
            ),
          ],
        );
      },
    );
  }

  void ShowSelectProductDialogForSpareBox({int? spareBoxIndex, context,tempProductMode, spareBoxes, selectProducts, onPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
         tempProductMode = spareBoxes[spareBoxIndex]['selectedProduct'];
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text('Select Product'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children:
                      selectProducts.map((product) {
                        return RadioListTile<String>(
                          fillColor: WidgetStateProperty.all(Colors.blue),
                          title: Text(product),
                          value: product,
                          groupValue: tempProductMode,
                          onChanged: (value) {
                            setState(() {
                              tempProductMode = value;
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
              child: Text('Cancel', style: TextStyle(color: AppColor.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK', style: TextStyle(color: AppColor.blue)),
              onPressed: onPressed,
            ),
          ],
        );
      },
    );
  }