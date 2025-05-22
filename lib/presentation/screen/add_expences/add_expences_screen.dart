import 'package:assistify/components/custome_text_field.dart';
import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/presentation/cubit/add_expences/add_expences_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExpenseScreen extends StatefulWidget {
  String? title;
  dynamic data;
  AddExpenseScreen({Key? key, this.title, this.data}) : super(key: key);
  @override
  _AddExpenseViewState createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;
  String? selectedPaymentMode;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  bool errorDescription = false;
  bool errorAmount = false;
  bool errorCategory = false;
  bool errorPaymentMode = false;
  String? userId = '';
  String? companyId = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    if (widget.title == 'Edit Expense') {
      _populateEditData();
    }
  }

  void _populateEditData() {
    if (widget.data != null) {
      setState(() {
        selectedDate = DateTime.parse(widget.data.expenseDate);
        descriptionController.text = widget.data.description;
        selectedCategory = widget.data.category;
        amountController.text = widget.data.amount.toString();
        selectedPaymentMode = widget.data.paymentMode;
        referenceController.text = widget.data.referenceNumber;
      });
    }
  }

  Future<void> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    companyId = prefs.getString('companyId') ?? '';
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? tempSelectedCategory = selectedCategory;
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text('Select Category'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: ['Food', 'Transport', 'Shopping', 'Office Supplies']
                      .map((category) {
                    return RadioListTile<String>(
                      fillColor: MaterialStateProperty.all(AppColor.blue),
                      title: Text(category),
                      value: category,
                      groupValue: tempSelectedCategory,
                      onChanged: (value) {
                        setState(() {
                          tempSelectedCategory = value;
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
              child: Text('Cancel', style: TextStyle(color: AppColor.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK', style: TextStyle(color: AppColor.blue)),
              onPressed: () {
                setState(() {
                  selectedCategory = tempSelectedCategory;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPaymentModeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? tempSelectedPaymentMode = selectedPaymentMode;
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text('Select Payment Mode'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: ['Cash', 'Card', 'UPI'].map((mode) {
                    return RadioListTile<String>(
                      title: Text(mode),
                      value: mode,
                      groupValue: tempSelectedPaymentMode,
                      onChanged: (value) {
                        setState(() {
                          tempSelectedPaymentMode = value;
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
              onPressed: () {
                setState(() {
                  selectedPaymentMode = tempSelectedPaymentMode;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
                widget.title == 'Edit Expense' ? 'Edit Expenses' : 'Add Expenses',
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            centerTitle: true,
            backgroundColor: AppColor.white,
            shadowColor: AppColor.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 1,
          ),
          backgroundColor: AppColor.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Expense Date", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                _buildCalendar(),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _showCategoryDialog,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.gray),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedCategory ?? 'Select Category'),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                customTextField(
                  descriptionController,
                  'Description',
                  errorText:
                      errorDescription ? 'Please enter a description' : null,
                  onChanged: (value) =>
                      setState(() => errorDescription = value.isEmpty),
                ),
                customTextField(
                  amountController,
                  'Amount',
                  errorText: errorAmount ? 'Please enter a amount' : null,
                  onChanged: (value) =>
                      setState(() => errorAmount = value.isEmpty),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _showPaymentModeDialog,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.gray),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedPaymentMode ?? 'Payment Mode'),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                customTextField(
                  referenceController,
                  'Reference Number',
                  errorText:
                      errorAmount ? 'Please enter a Reference Number' : null,
                  onChanged: (value) =>
                      setState(() => errorAmount = value.isEmpty),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColor.blue,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    onPressed: () {
                      if(widget.title == 'Edit Expense') {
                        setState(() {
                          isLoading = true;
                        });
                        context.read<AddExpencesCubit>().edit_expences(
                            context,
                            {
                              "id": widget.data.id,
                              "expenseDate": selectedDate.toIso8601String(),
                              "description": descriptionController.text,
                              "category": selectedCategory,
                              "amount": amountController.text,
                              "paymentMode": selectedPaymentMode,
                              "referenceNumber": referenceController.text,
                              "userId": userId,
                              "companyId": companyId,
                            },
                            companyId!);
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                         context.read<AddExpencesCubit>().add_Expences(
                          context,
                          {
                            "expenseDate": selectedDate.toIso8601String(),
                            "description": descriptionController.text,
                            "category": selectedCategory,
                            "amount": amountController.text,
                            "paymentMode": selectedPaymentMode,
                            "referenceNumber": referenceController.text,
                            "userId": userId,
                            "companyId": companyId,
                          },
                          companyId!);
                          setState(() {
                            isLoading = false;
                          });
                      }
                     
                    },
                    child: isLoading ?  CupertinoActivityIndicator(color: AppColor.white) : Text(
                      widget.title == 'Edit Expences'
                          ? 'UPDATE EXPENSE'
                          : 'SAVE EXPENSE',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child:CupertinoActivityIndicator(color: AppColor.white)
            ),
          ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Theme(
  data: Theme.of(context).copyWith(
    colorScheme: ColorScheme.light(
      primary: AppColor.blue,
      onPrimary: Colors.white,  
      onSurface: Colors.black,
    ),
  ),
  child: CalendarDatePicker(
    initialDate: selectedDate,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
    onDateChanged: (date) => setState(() => selectedDate = date),
  ),
);
  }
}
