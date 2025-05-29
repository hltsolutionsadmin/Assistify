import 'package:assistify/components/custome_text_field.dart';
import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:assistify/presentation/widgets/helper_widgets.dart/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterOptionsView extends StatefulWidget {
  final String? companyId;
  final String? userId;

  final String? initialName;
  final String? initialPhone;
  final String? initialStatus;
  final DateTime? initialFromDate;
  final DateTime? initialToDate;

  const FilterOptionsView({
    Key? key,
    this.companyId,
    this.userId,
    this.initialName,
    this.initialPhone,
    this.initialStatus,
    this.initialFromDate,
    this.initialToDate,
  }) : super(key: key);

  @override
  State<FilterOptionsView> createState() => _FilterOptionsViewState();
}

class _FilterOptionsViewState extends State<FilterOptionsView> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  DateTime? fromDate;
  DateTime? toDate;

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
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName ?? '');
    phoneController = TextEditingController(text: widget.initialPhone ?? '');
    selectedStatus = widget.initialStatus;
    fromDate = widget.initialFromDate;
    toDate = widget.initialToDate;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button top right
              Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: AppColor.black),
                  onPressed: () {
                    Navigator.pop(context, {
                      'name': nameController.text,
                      'phone': phoneController.text,
                      'status': selectedStatus,
                      'fromDate': fromDate,
                      'toDate': toDate,
                    });
                  },
                ),
              ),

              // Name input
              customTextField(
                nameController,
                'Name',
                errorText: null,
                onChanged: (value) {
                  // No need to update controller text manually here
                },
              ),
              SizedBox(height: 12),

              // Phone input with digit filtering and max length
              customTextField(
                phoneController,
                'Phone Number',
                errorText: null,
                onChanged: (value) {},
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              SizedBox(height: 12),

              // Status dropdown
              _buildStatusDropdown(),

              SizedBox(height: 20),

              // From Date picker
              _buildDateSelector('From Date', fromDate, true),
              SizedBox(height: 12),

              // To Date picker
              _buildDateSelector('To Date', toDate, false),
              SizedBox(height: 30),

              // Buttons: Apply filter and Clear filters
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      value: selectedStatus,
      items: [null, ...statusList].map((status) {
        if (status == null) {
          return DropdownMenuItem<String>(
            value: null,
            child: Text('Select Status'),
          );
        }
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedStatus = value;
        });
      },
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, bool isFromDate) {
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
              date != null
                  ? '${date.month}/${date.day}/${date.year}'
                  : isFromDate
                      ? 'From Date'
                      : 'To Date',
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
      initialDate: isFromDate ? (fromDate ?? now) : (toDate ?? (fromDate ?? now)),
      firstDate: isFromDate ? DateTime(now.year - 1) : (fromDate ?? DateTime(now.year - 1)),
      lastDate: isFromDate ? (toDate ?? now) : now,
      selectableDayPredicate: (DateTime date) {
        if (isFromDate) {
          return date.isBefore(now.add(Duration(days: 1)));
        } else {
          return date.isAfter((fromDate ?? DateTime(now.year - 1)).subtract(Duration(days: 1))) &&
              date.isBefore(now.add(Duration(days: 1)));
        }
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
          if (toDate != null && toDate!.isBefore(picked)) {
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
                selectedStatus == null &&
                fromDate == null &&
                toDate == null) {
              CustomSnackbars.showErrorSnack(
                context: context,
                title: 'Alert',
                message: 'Please add one option to filter',
              );
              return;
            }

            Navigator.pop(context);
            context.read<AllBillsCubit>().all_bills(context, {
              "companyId": widget.companyId,
              "userId": widget.userId,
              "customerName": nameController.text,
              "phoneNumber": phoneController.text,
              "status": selectedStatus,
              "fromDate": fromDate?.toIso8601String(),
              "toDate": toDate?.toIso8601String(),
              "pageNumber": "1",
              "pageSize": "40",
            });
          },
        ),
        SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            side: BorderSide(color: const Color.fromARGB(255, 126, 124, 124)),
            minimumSize: Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () {
            // Clear all filters
            nameController.clear();
            phoneController.clear();
            setState(() {
              selectedStatus = null;
              fromDate = null;
              toDate = null;
            });
          },
          child: Text('CLEAR FILTER'),
        ),
      ],
    );
  }
}
