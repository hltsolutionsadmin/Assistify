import 'package:assistify/components/custome_text_field.dart';
import 'package:assistify/core/constants/colors.dart';
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
  final VoidCallback? fetchData;
  final void Function(bool)? onRefresh;
  final void Function(bool)? onFilter;

  const FilterOptionsView({
    Key? key,
    this.companyId,
    this.userId,
    this.initialName,
    this.initialPhone,
    this.initialStatus,
    this.initialFromDate,
    this.initialToDate,
    this.fetchData,
    this.onRefresh,
    this.onFilter,
  }) : super(key: key);

  @override
  State<FilterOptionsView> createState() => _FilterOptionsViewState();
}

class _FilterOptionsViewState extends State<FilterOptionsView> {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  DateTime? fromDate;
  DateTime? toDate;
  String? selectedStatus;

  static const List<String> statusList = [
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: AppColor.black),
                onPressed: () => _popWithFilters(),
              ),
            ),
            customTextField(
              nameController,
              'Name',
              errorText: null,
              onChanged: (_) {},
            ),
            const SizedBox(height: 12),
            customTextField(
              phoneController,
              'Phone Number',
              errorText: null,
              onChanged: (_) {},
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatusDropdown(),
            const SizedBox(height: 20),
            _buildDateSelector('From Date', fromDate, true),
            const SizedBox(height: 12),
            _buildDateSelector('To Date', toDate, false),
            const SizedBox(height: 30),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  void _popWithFilters() {
    Navigator.pop(context, {
      'name': nameController.text,
      'phone': phoneController.text,
      'status': selectedStatus,
      'fromDate': fromDate,
      'toDate': toDate,
    });
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      value: selectedStatus,
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Select Status'),
        ),
        ...statusList.map(
          (status) =>
              DropdownMenuItem<String>(value: status, child: Text(status)),
        ),
      ],
      onChanged: (value) => setState(() => selectedStatus = value),
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, bool isFromDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColor.black)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _selectDate(context, isFromDate),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.gray),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              date != null
                  ? '${date.month}/${date.day}/${date.year}'
                  : (isFromDate ? 'From Date' : 'To Date'),
              style: TextStyle(fontSize: 16, color: AppColor.black),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final now = DateTime.now();
    final initial =
        isFromDate ? (fromDate ?? now) : (toDate ?? (fromDate ?? now));
    final first =
        isFromDate
            ? DateTime(now.year - 1)
            : (fromDate ?? DateTime(now.year - 1));
    final last = isFromDate ? (toDate ?? now) : now;

    final picked = await showDatePicker(
      context: context,
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColor.blue,
                onPrimary: Colors.white,
                onSurface: AppColor.black,
              ),
            ),
            child: child!,
          ),
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      selectableDayPredicate: (date) {
        if (isFromDate) {
          return date.isBefore(now.add(const Duration(days: 1)));
        } else {
          return date.isAfter(
                (fromDate ?? DateTime(now.year - 1)).subtract(
                  const Duration(days: 1),
                ),
              ) &&
              date.isBefore(now.add(const Duration(days: 1)));
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
            _applyFilter();
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            side: const BorderSide(color: Color.fromARGB(255, 126, 124, 124)),
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: _clearFilters,
          child: const Text('CLEAR FILTER'),
        ),
      ],
    );
  }

  void _applyFilter() {
    final isAllEmpty =
        nameController.text.isEmpty &&
        phoneController.text.isEmpty &&
        selectedStatus == null &&
        fromDate == null &&
        toDate == null;

    if (isAllEmpty) {
      widget.onRefresh?.call(true);
      widget.fetchData?.call();
      if (widget.onFilter != null) {
        widget.onFilter!(false);
      }
      Navigator.pop(context, null);
      return;
    }
    if (widget.onFilter != null) {
      widget.onFilter!(true);
    }
    _popWithFilters();

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
    }, isFilter: true);
  }

  void _clearFilters() {
    nameController.clear();
    phoneController.clear();
    setState(() {
      selectedStatus = null;
      fromDate = null;
      toDate = null;
    });
  }
}
