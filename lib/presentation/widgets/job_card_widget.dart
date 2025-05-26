import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/presentation/screen/addjob/add_job_form_screen.dart';
import 'package:assistify/presentation/widgets/contact_popup_widget.dart';
import 'package:assistify/presentation/widgets/file_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class JobCard extends StatefulWidget {
  final dynamic jobData;
  final Function? fetchData;
  String? companyName;
  JobCard({super.key, required this.jobData, this.fetchData, this.companyName});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
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
                        widget.jobData.customerName ?? 'No Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Job ID: ${widget.jobData?.jobId ?? ''}    Balance: ${(widget.jobData.totalAmount - widget.jobData.paidAmount) ?? 0}",
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
                      builder: (_) => AddJobFormScreen(
                        jobData: widget.jobData,
                        title: 'Edit Job',
                        companyName: widget.companyName
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
                            showFilePopup(
                              context,
                              widget.jobData,
                              widget.fetchData,
                            ),
                          },
                      child: Icon(Icons.description, size: 24),
                    ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () => {},
                      child: Icon(Icons.upload, size: 24),
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
                      widget.jobData.phoneNumber,
                      widget.jobData,
                    );
                  },
                  icon: const Icon(Icons.phone, color: Colors.blue),
                  label: Text(
                    widget.jobData.phoneNumber ?? 'No Phone',
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
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, size: 16),
                      SizedBox(width: 4),
                      Text(
                        widget.jobData.status ?? 'PENDING',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
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
                  "Created on ${widget.jobData.createdAt != null ? _dateFormat.format(DateTime.parse(widget.jobData.createdAt!)) : 'N/A'}",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                Text(
                  "Total Amount: ₹ ${widget.jobData.totalAmount?.toStringAsFixed(2) ?? '0.00'}",
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
