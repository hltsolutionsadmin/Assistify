import 'package:assistify/components/custome_text_field.dart';
import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:assistify/presentation/widgets/dash_board_helper_widget.dart';
import 'package:assistify/presentation/widgets/helper_widgets.dart/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterOptionsView extends StatefulWidget {
  FilterOptionsView({Key? key}) : super(key: key);

  @override
  State<FilterOptionsView> createState() => _FilterOptionsViewState();
}

class _FilterOptionsViewState extends State<FilterOptionsView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String? selectedStatus;
  final List<String> statusList = [
    'Received',
    'Assigned',
    'In Progress',
    'Estimated',
    'Pending',
    'Delivered',
    'Completed',
    'Paid',
    "Return",
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              customTextField(
                nameController,
                'Name',
                errorText: null,
                onChanged: (value) => {},
              ),
              SizedBox(height: 12),
              customTextField(
                phoneController,
                'Phone Number',
                errorText: null,
                onChanged: (value) => {},
              ),
              SizedBox(height: 12),
              BuildDropdown(selectedStatus, statusList, (value) {
                setState(() {
                  selectedStatus = value;
                });
              }),
              SizedBox(height: 20),
              _buildDateSelector('From Date', fromDate, true),
              SizedBox(height: 12),
              _buildDateSelector('To Date', toDate, false),
              SizedBox(height: 30),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime date, bool isFromDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColor.black)),
        SizedBox(height: 6),
        InkWell(
          onTap: () => _selectDate(context, isFromDate),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.gray),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${date.month}/${date.day}/${date.year}',
              style: TextStyle(fontSize: 16, color: AppColor.black),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.blue,
              onPrimary: Colors.white,
              onSurface: AppColor.black,
            ),
          ),
          child: child!,
        );
      },
      initialDate: isFromDate ? fromDate : toDate,
      firstDate: isFromDate ? DateTime(now.year - 1) : fromDate,
      lastDate: isFromDate ? toDate : now,
      selectableDayPredicate: (DateTime date) {
        if (isFromDate) {
          return date.isBefore(now.add(Duration(days: 1)));
        } else {
          return date.isAfter(fromDate.subtract(Duration(days: 1))) &&
              date.isBefore(now.add(Duration(days: 1)));
        }
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
          // If toDate is before the new fromDate, update toDate
          if (toDate.isBefore(picked)) {
            toDate = picked;
          }
        } else {
          toDate = picked;
        }
      });
    }
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        buildButton(
          text: 'APPLY FILTER',
          handleAction: () {
            if (nameController.text.isEmpty &&
                phoneController.text.isEmpty &&
                selectedStatus == null&& fromDate == null && toDate == null) {
              CustomSnackbars.showErrorSnack(
                context: context,
                title: 'Alert',
                message: 'Please add one option to filter',
              );
            } else {
              Navigator.pop(context);
              context.read<AllBillsCubit>().all_bills(context, {
                "companyId": "1928ef90-f0cf-45c5-b707-bdb0c02fdc66",
                "userId": "e1a13218-3893-401a-826f-f29885c5e2c1",
                "customerName": nameController.text,
                "phoneNumber": phoneController.text,
                "status": selectedStatus,
                "fromDate": fromDate.toIso8601String(),
                "toDate": toDate.toIso8601String(),
                "pageNumber": "1",
                "pageSize": "40",
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              side: BorderSide(color: const Color.fromARGB(255, 126, 124, 124)),
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {
              nameController.clear();
              phoneController.clear();
              setState(() {
                selectedStatus = null;
                fromDate = DateTime.now();
                toDate = DateTime.now();
              });
            },
            child: Text('CLEAR FILTER'),
          ),
        ),
      ],
    );
  }
}
