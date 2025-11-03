import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/presentation/screen/addjob/add_items_screen.dart';
import 'package:assistify/presentation/widgets/contact_popup_widget.dart';
import 'package:assistify/presentation/widgets/printing_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class VegiCustomerDetailsCard extends StatefulWidget {
  final dynamic custData;
  final Function? fetchData;
  String? companyName;
  String? companyPhone;
  num? category;
  VegiCustomerDetailsCard({
    super.key,
    required this.custData,
    this.fetchData,
    this.companyName,
    this.category,
    this.companyPhone,
  });

  @override
  State<VegiCustomerDetailsCard> createState() => _JobCardState();
}

class _JobCardState extends State<VegiCustomerDetailsCard> {
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    print(' companyPhone: ${widget.companyPhone}');
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColor.gray,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.custData.customerName ?? 'No Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Balance: ${(widget.custData.totalAmount - widget.custData.paidAmount) ?? 0}",
                        style: TextStyle(fontSize: 13, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => AddItemsScreen(
                                  jobData: widget.custData,
                                  title: 'Edit Details',
                                  companyName: widget.companyName,
                                  category: widget.category,
                                  companyPhone: widget.companyPhone,
                                ),
                          ),
                        ).then((_) {
                          if (widget.fetchData != null) widget.fetchData!();
                        });
                      },
                      child: Icon(Icons.edit, size: 24),
                    ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap:
                          () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PrintingCard(
                                      title: 'Bill',
                                      data: widget.custData,
                                      category: widget.category,
                                      companyName: widget.companyName,
                                      companyPhone: widget.companyPhone,
                                    ),
                              ),
                            ).then((_) {
                    if (widget.fetchData != null) widget.fetchData!();
                  }),
                          },
                      child: Icon(Icons.description, size: 24),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showContactPopup(
                      context,
                      widget.custData.phoneNumber,
                      widget.custData,
                    );
                  },
                  icon: const Icon(Icons.phone, color: Colors.blue),
                  label: Text(
                    widget.custData.phoneNumber ?? 'No Phone',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF0D47A1),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Created on ${widget.custData.createdAt != null ? _dateFormat.format(DateTime.parse(widget.custData.createdAt!)) : 'N/A'}",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                Text(
                  "Total Amount: ₹ ${widget.custData.totalAmount?.toStringAsFixed(2) ?? '0.00'}",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
