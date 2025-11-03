import 'package:assistify/presentation/widgets/printing_screen_widget.dart';
import 'package:flutter/material.dart';

void showFilePopup(
  BuildContext context,
  dynamic data,
  Function? fetchData,
  num? category,
  String? companyName,
  String? banner,
  String? logo,
  String? companyPhone,
) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PrintingCard(
                            title: 'Bill',
                            data: data,
                            category: category,
                            companyName: companyName,
                          ),
                    ),
                  ).then((_) {
                    if (fetchData != null) fetchData();
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.description, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Generate Bill', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PrintingCard(
                            title: 'Invoice',
                            data: data,
                            category: category,
                            companyName: companyName,
                            companyPhone: companyPhone,
                          ),
                    ),
                  ).then((_) {
                    if (fetchData != null) fetchData();
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.description_outlined, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Generate Invoice', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PrintingCard(
                            title: 'Estimation',
                            data: data,
                            category: category,
                            companyName: companyName,
                          ),
                    ),
                  ).then((_) {
                    if (fetchData != null) fetchData();
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.file_open_sharp, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Generate Estimation', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
